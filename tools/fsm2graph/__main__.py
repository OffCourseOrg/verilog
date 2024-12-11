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
DOT_edge_label_spacing = "  "
netlist: Netlist = None
fsm: FSMInfoParser = None

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
   fsm.map_verilog_names(verilog["STATES"])
except:
  logging.warning("No state params available")

##Ensure Datastate
if(not fsm.data_valid()):
   raise Exception("incomplete FSM datastate")


##Execute Outputs
fsm.execute_outputs(netlist)
##Determine Type
fsm.get_fsm_type()

### Create Graphiz
dot = graphviz.Digraph(filename="fsm.gv",
                       directory="tmp/",
                       engine="neato",
                       node_attr={"style": "filled", "margin": "0.05", "fillcolor": "darkolivegreen3"}
                       )

#add states
for i, state in enumerate(fsm.states.values()):
  shape = "circle"
  if(i == 0):
    dot.node("_reset", "", style="invis")
    dot.edge("_reset", f"{state.fsm_id}", label="  reset", arrowhead="diamond")
    shape = "doublecircle"

  ## Output changes to state name -> Moore
  name = state.name
  if(fsm.is_moore() and state.get_executed_outputs() != []):
    name += "\n"
    for output in state.get_executed_outputs():
      name += f"{output}\n"
    name = name.replace("=", "<=")

  dot.node(f"{state.fsm_id}", name, shape=shape)

#add edges/transitions
for state in fsm.states.values():
  for transition in state.transitions:
    if(DOT_remove_reset and transition.reset):
      continue
    
    label = ""
    for key, value in transition.inputs.items():
      if(DOT_remove_reset and key == fsm.reset_input):
        continue
      if(value < 0):
        continue
      if(netlist != None):
        net = key if "$" not in key else netlist.resolve(key)
      else:
        net = key
      if(label != ""):
        label += f"{DOT_edge_label_spacing}&& "
      else:
        label = DOT_edge_label_spacing
      label += f"{'' if value else '!'}{net}\l"

    if(fsm.is_mealy()):
      for output in transition.executed_outputs:
        label += f"{DOT_edge_label_spacing}[{output}]\l"

    if(DOT_skip_label_loops and transition.state_fsm_id == transition.next_fsm_id):
      label=""
    dot.edge(f"{transition.state_fsm_id}", f"{transition.next_fsm_id}", label=label)


dot.save()