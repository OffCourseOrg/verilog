#!/usr/bin/env python
"""
 *  OffCourse::Verilog
 *		- fsm2graph.py
 *
 *    Parser for the text output of yosys FSM_info
 *    Reads additional information from verilog files with descriptiors
 *
 *  Written by: Sybe
 *  License: MIT
"""

import logging
import logging.config
import graphviz
import sys

class CustomFormatter(logging.Formatter):
    grey = "\\x1b[38;21m"
    yellow = "\\x1b[33;21m"
    red = "\\x1b[31;21m"
    bold_red = "\\x1b[31;1m"
    reset = "\\x1b[0m"
    format = "%(asctime)s - %(name)s - %(levelname)s - %(message)s (%(filename)s:%(lineno)d)"

    FORMATS = {
        logging.DEBUG: grey + format + reset,
        logging.INFO: grey + format + reset,
        logging.WARNING: yellow + format + reset,
        logging.ERROR: red + format + reset,
        logging.CRITICAL: bold_red + format + reset
    }

    def format(self, record):
        log_fmt = self.FORMATS.get(record.levelno)
        formatter = logging.Formatter(log_fmt)
        return formatter.format(record)

logger = logging.getLogger("fsm2graph")
sh = logging.StreamHandler()
sh.setLevel(logging.WARN)
sh.setFormatter(CustomFormatter())
logger.addHandler(sh)

##YoSys args and FSM data
yosys_target_header = "Executing FSM_INFO pass (dumping all available information on FSM cells)."
FSM_state_reg = ""
FSM_inputs = []
FSM_outputs = []
FSM_transitions = []
FSM_states = []
FSM_reset_input = "reset"
##Verilog parser result
VERILOG_params = {}

##Graphiz/Render arguments
DOT_remove_reset = True

#get signal name from line
# - either wire/reg name leading \
# - or functional blokc leading $
def signal_name(line):
  if ("\\" in line):
    return line[line.find("\\")+1::]
  if ("$" in line):
    return line[line.find("$")::]
  return "name error"

#is this a yosys header -> starts with digits
# Optional check if header text matches compare_header
def is_header(line, compare_header=""):
  #Empty line or debug info
  if(len(line) < 2 or line[0] in [" ", "-", "<"]):
      return False
  #Line is not header
  if(not (line[0].isdigit() and line[1] == ".")):
      return False
  
  if(compare_header == ""):
      return True
  
  for i, chr in enumerate(line):
      if(chr.isdigit() or chr in [" ", "."]):
          continue
      return compare_header == line[i::]

#Extract params from verilog
def read_verilog(file_input):
  global VERILOG_params
  block = ""
  for line in file_input:
    line = line.replace("\n", "").strip()

    if("//@" not in line and block == ""):
      continue
    
    if("//@" in line):
      block = line[line.find("@")+1::]
      VERILOG_params[block] = {}
      continue
    
    if(line != ""):
      key, value = line[:-1].split("=")
      key = key.strip().split(" ")[-1]
      VERILOG_params[block][key] = int(value.strip())
      if(line[-1] == ";"):
        block = ""
      continue

def read_yosys(file_input):
  global yosys_target_header 
  global FSM_state_reg
  global FSM_inputs
  global FSM_outputs
  global FSM_transitions
  global FSM_states
  global FSM_reset_input

  in_block = False
  parsed = {"header": False, "state_reg": False, "inputs": False, "outputs": False, "states": False, "transitions": False}
  
  #Loop over stdin or file input
  for line in file_input:
    line = line.replace("\n", "")
    
    logger.info("-> {}", line)

    if(not parsed["header"]):
      if(not is_header(line, yosys_target_header)):
          continue
    parsed["header"] = True

    #Get state register name
    if(not parsed["state_reg"]):
      if(("Information on FSM" not in line)):
          continue
      
      FSM_state_reg = line[line.find("(")+1:line.find(")")]
    parsed["state_reg"] = True

    #Input signals
    if(not parsed["inputs"]):
      if(line.strip() != "Input signals:" and not in_block):
          continue
      in_block = True
      
      if(line.strip() == "Input signals:"):
          continue

      if(line != ""):
        FSM_inputs.append(signal_name(line))
        continue
      in_block = False
      parsed["inputs"] = True

    #Output signals
    if(not parsed["outputs"]):
      if(line.strip() != "Output signals:" and not in_block):
          continue
      in_block = True

      if(line.strip() == "Output signals:"):
          continue

      if(line != ""):
        FSM_outputs.append(signal_name(line))
        continue
      in_block = False
      parsed["outputs"] = True

    #States
    if(not parsed["states"]):
      if(line.strip() != "State encoding:" and not in_block):
          continue
      in_block = True

      if(line.strip() == "State encoding:"):
          continue

      if(line != ""):
        id_binary_str = line[line.find("'")+1::].replace("<RESET STATE>", "").strip()
        verilog_id = int(id_binary_str, 2)
        FSM_states.append({
          "name": "empty",
          "verilog_id": verilog_id,
          "fsm_id": len(FSM_states),
          "reset": "<RESET STATE>" in line
        })
        continue

      in_block = False
      parsed["states"] = True

    #transitions signals
    if(not parsed["transitions"]):
      if("Transition Table" not in line and not in_block):
          continue
      in_block = True

      if("Transition Table" in line):
          continue

      if(line != ""):
        i_inputs = line.find("'")+1
        i_outputs = line.find("'", i_inputs)+1
        i_arrow = line.find(">")
        transition = {
          "state": int(line[line.find(":")+1:i_inputs-2].strip()),
          "inputs": {},
          "state_next": int(line[i_arrow+1:i_outputs-2].strip()),
          "outputs": {},
          "reset": False
        }
        for i, chr in enumerate(line[i_inputs:line.find(" ", i_inputs)][::-1]):
          if(chr == "-"):
            continue
          transition["inputs"][FSM_inputs[i]] = int(chr)
        
        for i, chr in enumerate(line[i_outputs:line.find(" ", i_outputs)][::-1]):
          if(chr == "-"):
            continue
          transition["outputs"][FSM_outputs[i]] = int(chr)
        
        transition["reset"] = transition["inputs"][FSM_reset_input] == 1

        FSM_transitions.append(transition)
        continue
      in_block = False
      parsed["transitions"] = True
    pass

#Process Arguments
yosys_is_read = False
for arg in sys.argv[1::]:
  if(arg[0] == "-"):
    #Flags
    match(arg.lstrip()):
       case("verbose"):
          logger.setLevel(logging.INFO)
  else: 
    #Files input
    with open(arg) as f:
      content = f.read().splitlines()
    if(".v" in arg):
      read_verilog(content)
    else:
      yosys_is_read = True
      read_yosys(content)

#Process stdin
if(not yosys_is_read):
    print("Reading from stdin...")
    with sys.stdin as f:
     content = f.read().splitlines()
     read_yosys(content)

##Merge Verilog and YoSys
# Map Verilog state params to FSM states
try:
   for i, state in enumerate(FSM_states):
    for key, value in VERILOG_params["STATES"].items():
      if(value == state["verilog_id"]):
        FSM_states[i]["name"] = key
except:
  for i, state in enumerate(FSM_states):
     FSM_states[i]["name"] = f"s{state["verilog_id"]}"
  logger.warning("No state params available")

##Verify Datastate
if(FSM_state_reg == "" or
  FSM_inputs == [] or
  FSM_outputs == [] or
  FSM_transitions == [] or
  FSM_states == []):
   raise Exception("incomplete yosys datastate")

### Create Graphiz
dot = graphviz.Digraph(filename="fsm.gv",
                       directory="tmp/",
                       engine="neato")

#add states
for i, state in enumerate(FSM_states):
   shape = "circle"
   if(i == 0):
      dot.node("_reset", "", style="invis")
      dot.edge("_reset", f"{state["fsm_id"]}", label="  reset", arrowhead="diamond")
      shape = "doublecircle"
   dot.node(f"{state["fsm_id"]}", state["name"], shape=shape, margin="0.002", fillcolor="gray")

#add edges/transitions
for i, transistion in enumerate(FSM_transitions):
  if(DOT_remove_reset and transistion["reset"]):
    continue

  label = "  "
  for key, value in transistion["inputs"].items():
    if(DOT_remove_reset and key == FSM_reset_input):
      continue
    label += f"{"" if value else "!"}{key} &&"
  label = label[:-2]
  for key, value in transistion["outputs"].items():
    label += ""

  dot.edge(f"{transistion["state"]}", f"{transistion["state_next"]}", label=label)

dot.save()