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
import graphviz
import sys

from lib import FSMInfoParser, VerilogExtractor, Netlist, is_value, get_value

logging.basicConfig(level=logging.WARN)

##Graphiz/Render arguments
DOT_remove_reset = True
DOT_skip_label_loops = True
DOT_label_line_sep = "\l  "
netlist = None

#Process Arguments
yosys_is_read = False
for index, arg in enumerate(sys.argv[1::]):
  if(arg[0] != "-"):
    continue

  filepath = sys.argv[index+2]
  match(arg.lstrip("-")[0]):
      case("f"): #fsm
        with open(filepath) as f:
          content = f.read().splitlines()
          yosys_is_read = True
          fsm = FSMInfoParser(content) 
      case("v"): #verilog
        with open(filepath) as f:
          content = f.read().splitlines()
        verilog = VerilogExtractor(content)
      case("n"): #netlist
        with open(filepath) as f:
          content = f.read().splitlines()
        netlist = Netlist(content)
      case("i"): #Info
        logging.getLogger().setLevel(logging.INFO)
      case("l"): #loops
        DOT_skip_label_loops = False

#Process stdin
if(not yosys_is_read):
    print("Reading from stdin...")
    with sys.stdin as f:
     content = f.read().splitlines()
     fsm = FSMInfoParser(content) 

##Merge Verilog and YoSys
# Map Verilog state params to FSM states
try:
   for i, state in enumerate(fsm.states):
    for key, value in verilog["STATES"].items():
      if(value == state.verilog_id):
        fsm.states[i].name = key
except:
  for i, state in enumerate(fsm.states):
     fsm.states[i].name = f"s{state.verilog_id}"
  logging.warning("No state params available")

##Ensure Datastate
if(not fsm.data_valid()):
   raise Exception("incomplete FSM datastate")

### Create Graphiz
dot = graphviz.Digraph(filename="fsm.gv",
                       directory="tmp/",
                       engine="neato",
                       node_attr={"style": "filled", "margin": "0.02", "fillcolor": "darkolivegreen3"}
                       )

#Compile outputs into states
for i, transistion in enumerate(fsm.transitions):
  #Ignore Reset Transition
  if(transistion["reset"] == 1):
    continue
  execute_args = transistion["inputs"] | transistion["outputs"] | {"reset": int(transistion["reset"])}
  for input in fsm.inputs:
    if(input not in execute_args):
      execute_args[input] = 0

  outputs = []
  state_index = fsm.get_state_index(transistion["state"])
  for output_net in netlist.output_netnames:
    result = netlist.execute(output_net, execute_args)
    while(output_net != result and not is_value(result)):
      result = netlist.execute(result, execute_args, start_net=output_net)
    if(output_net == result):
      continue
    outputs.append(f"{output_net} = {result}")
  fsm.states[state_index].add_transition(transistion["state_next"], outputs) 
    

#### MOORE vs MEALY ######
# if the outputs for all states are equal for each outgoing transition -> MOORE
# if any state has an output different from its other transitions -> MEALY
IS_MOORE = True
for state in fsm.states:
  if(len(state.transitions) < 2):
    continue
  base = state.base_transition
  for i, outputs in enumerate(state.transitions.values()):
    if(i == 0):
      continue
    if(len(outputs) != len(base)):
      IS_MOORE = False
      break
    for y, ouput in enumerate(outputs):
      if(ouput != base[y]):
        IS_MOORE = False
        break

#add states
for i, state in enumerate(fsm.states):
  shape = "circle"
  if(i == 0):
    dot.node("_reset", "", style="invis")
    dot.edge("_reset", f"{state.fsm_id}", label="  reset", arrowhead="diamond")
    shape = "doublecircle"

  ## Output changes to state name -> Moore
  name = state.name
  if(IS_MOORE and state.base_transition != []):
    name += "\n"
    for output in state.base_transition:
      name += f"{output}\n"
    name = name.replace("=", "<=")

  dot.node(f"{state.fsm_id}", name, shape=shape)

#add edges/transitions
for i, transistion in enumerate(fsm.transitions):
  if(DOT_remove_reset and transistion["reset"]):
    continue
  
  label = ""
  for key, value in transistion["inputs"].items():
    if(DOT_remove_reset and key == fsm.reset_input):
      continue
    if(value < 0):
      continue
    if(netlist != None):
      net = key if "$" not in key else netlist.resolve(key)
    else:
      net = key
    if(label != ""):
      label += " && "
    else:
      label = " "
    label += f"{'' if value else '!'}{net}\l"

  if(not IS_MOORE):
    state = fsm.get_state(transistion["state"])
    for output in state.transitions[transistion["state_next"]]:
      label += f"  {output}\l"

  if(DOT_skip_label_loops and transistion["state"] == transistion["state_next"]):
    label=""
  dot.edge(f"{transistion['state']}", f"{transistion['state_next']}", label=label)

dot.save()