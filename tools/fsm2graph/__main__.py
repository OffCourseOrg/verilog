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

from lib import FSMInfoParser, VerilogExtractor, Netlist

logging.basicConfig(level=logging.WARN)

##Graphiz/Render arguments
DOT_remove_reset = True
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
      case("n"): #verilog
        with open(filepath) as f:
          content = f.read().splitlines()
        netlist = Netlist(content)
      case("l"): #log
        logging.getLogger().setLevel(logging.INFO)

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
      if(value == state["verilog_id"]):
        fsm.states[i]["name"] = key
except:
  for i, state in enumerate(fsm.states):
     fsm.states[i]["name"] = f"s{state["verilog_id"]}"
  logging.warning("No state params available")

##Ensure Datastate
if(not fsm.data_valid()):
   raise Exception("incomplete FSM datastate")

### Create Graphiz
dot = graphviz.Digraph(filename="fsm.gv",
                       directory="tmp/",
                       engine="neato",
                       node_attr={"style": "filled", "margin": "0.02", "fillcolor": "gray"}
                       )

#add states
for i, state in enumerate(fsm.states):
   shape = "circle"
   if(i == 0):
      dot.node("_reset", "", style="invis")
      dot.edge("_reset", f"{state["fsm_id"]}", label="  reset", arrowhead="diamond")
      shape = "doublecircle"
   dot.node(f"{state["fsm_id"]}", state["name"], shape=shape)

#add edges/transitions
for i, transistion in enumerate(fsm.transitions):
  if(DOT_remove_reset and transistion["reset"]):
    continue

  label = "  "
  for key, value in transistion["inputs"].items():
    if(DOT_remove_reset and key == fsm.reset_input):
      continue
    if(netlist != None):
      net = key if "$" not in key else netlist.resolve(key)
    else:
      net = key
    label += f"{"" if value else "!"}{net} && "
  label = label[:-3]
  for key, value in transistion["outputs"].items():
    label += ""

  dot.edge(f"{transistion["state"]}", f"{transistion["state_next"]}", label=label)

dot.save()