"""
 *  OffCourse::Verilog
 *		- fsm2graph - yosys fsm parsing
 *
 *    Parser for the text output of yosys FSM_info
 *
 *  Written by: Sybe
 *  License: MIT
"""

from enum import Enum
import logging
from typing import List

import re 
from .bits import Bits


class Transition:
  def __init__(self, state_fsm_id, next_fsm_id, reset=False):
    self.state_fsm_id: str = state_fsm_id
    self.next_fsm_id: str = next_fsm_id
    self.inputs: dict[str, int] = {}
    self.outputs: dict[str, int] = {}
    self.reset: bool = reset
    self.executed_outputs = []

  def add_input(self, netname, value):
    self.inputs[netname] = value

  def has_input(self, netname):
    return netname in self.inputs
  
  def input_value(self, netname):
    return self.inputs[netname]

  def add_output(self, netname, value):
    self.outputs[netname] = value
  
  def has_output(self, netname):
    return netname in self.outputs

class State:
  def __init__(self, verilog_id, fsm_id, is_reset=False, name=""):
    self.name = f"s{verilog_id}" if name == "" else name
    self.verilog_id = verilog_id
    self.fsm_id = fsm_id
    self.is_reset = is_reset
    self.transitions: List[Transition] = []

  def add_transition(self, transition: Transition):
     self.transitions.append(transition)
  
  def get_executed_outputs(self):
    if(self.transitions == []):
      return {}
    return self.transitions[0].executed_outputs

class FSMInfoParser:
  fsm_info_header = "Executing FSM_INFO pass (dumping all available information on FSM cells)."

  class Types(Enum):
    UNKNOWN = 0
    MOORE = 1
    MEALY = 2

  def __init__(self, lines):
    self.state_reg: str = ""
    self.inputs = []
    self.outputs = []
    self.states: dict[str, State] = {}
    self.reset_input: str = "reset"
    self.type = self.Types.UNKNOWN

    in_block = False
    parsed = {"header": False, "state_reg": False, "inputs": False, "outputs": False, "states": False, "transitions": False}
    
    #Loop over stdin or file input
    for line in lines:
      line = line.replace("\n", "")
      
      logging.info("-> %s", line)

      if(not parsed["header"]):
        if(not self.is_header(line, self.fsm_info_header)):
            continue
      parsed["header"] = True

      #Get state register name
      if(not parsed["state_reg"]):
        if(("Information on FSM" not in line)):
            continue
        
        self.state_reg = line[line.find("(")+1:line.find(")")]
      parsed["state_reg"] = True

      #Input signals
      if(not parsed["inputs"]):
        if(line.strip() != "Input signals:" and not in_block):
            continue
        in_block = True
        
        if(line.strip() == "Input signals:"):
            continue

        if(line != ""):
          self.inputs.append(self.signal_name(line))
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
          self.outputs.append(self.signal_name(line))
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
          fsm_id = len(self.states)
          self.add_state(State(
             verilog_id = verilog_id,
             fsm_id = fsm_id,
             is_reset=("<RESET STATE>" in line)
          ))
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
          transition = Transition(
            state_fsm_id=int(line[line.find(":")+1:i_inputs-2].strip()),
            next_fsm_id=int(line[i_arrow+1:i_outputs-3].strip())
          )
          for i, chr in enumerate(line[i_inputs:line.find(" ", i_inputs)][::-1]):
            if(chr == "-"):
              continue
            transition.add_input(self.inputs[i], Bits.from_str(chr))
          
          for i, chr in enumerate(line[i_outputs::][::-1]):
            transition.add_output(self.outputs[i], Bits.from_str(chr))
          
          ##Transition is reset
          if(transition.has_input("reset")):
            transition.reset = transition.input_value("reset")
            
          self.get_state(transition.state_fsm_id).add_transition(transition)
          continue
        in_block = False
        parsed["transitions"] = True
  
  def add_state(self, state: State):
    self.states[f"{state.fsm_id}"] = state

  def get_state(self, fsm_id) -> State:
    return self.states[f"{fsm_id}"]

  def map_verilog_names(self, verilog_names: dict[str, str]):
    for state_id, state in self.states.items():
      for key, value in verilog_names.items():
        if(value == state.verilog_id):
          self.states[state_id].name = key

  def execute_outputs(self, netlist):
    #Compile outputs into states
    for state in self.states.values():
      global ACTIVE_STATE
      ACTIVE_STATE = state
      transitions = state.transitions
      state.transitions = []
      for i, transition in enumerate(transitions):
        #Ignore Reset Transition
        if(transition.reset):
          continue
        execute_args = transition.inputs | transition.outputs | {"reset": 0}
        for input in self.inputs:
          if(input not in execute_args):
            execute_args[input] = Bits(0,1)

        for output_net in netlist.output_netnames:
          NORMAL_STATE = True
          result = netlist.execute(output_net, execute_args)
          prv_result = ""
          if(type(result) is list):
              keep_running = True
              while(keep_running):
                keep_running = False
                for index, subnet in enumerate(result):
                  if(isinstance(subnet, Bits)):
                    continue
                  result[index] = netlist.execute(subnet, execute_args, start_net=output_net)
                  keep_running = prv_result != result
                  prv_result = result
              #Check if result => output net or bits are changed
              NORMAL_STATE = False
              for i, subnet in enumerate(result):
                if(not isinstance(subnet, str)):
                  continue
                match = re.search("(?!\[)\d+?(?=\])", subnet)
                if(match == None):
                  transition.executed_outputs.append(f"{output_net}[{i}] = {subnet}")
                else:
                  selected = int(match.group())
                  if(selected != i):
                    transition.executed_outputs.append(f"{output_net}[{i}] = {output_net}[{selected}]")

          if(NORMAL_STATE):
            while(not isinstance(result, Bits) and output_net != result):
              result = netlist.execute(result, execute_args, start_net=output_net)
              if(result == prv_result):
                break
              if(type(result) is list):
                keep_running = True
                while(keep_running):
                  keep_running = False
                  for index, subnet in enumerate(result):
                    if(isinstance(subnet, Bits)):
                      continue
                    result[index] = netlist.execute(subnet, execute_args, start_net=output_net)
                    keep_running = prv_result != result
                    prv_result = result
                result = Bits.concat(result)
              prv_result = result
            if(not isinstance(result, Bits) and output_net == result):
              continue
            ###Binary Value formatting
              
            transition.executed_outputs.append(f"{output_net} = {result}")
        state.add_transition(transition)

  #### MOORE vs MEALY ######
  #### MUST BE RUN AFTER OUTPUTS ARE EXECUTED
  # if the outputs for all states are equal for each outgoing transition -> MOORE
  # if any state has an output different from its other transitions -> MEALY
  def get_fsm_type(self):
    if(self.type != self.Types.UNKNOWN):
      return self.type
      
    self.type = self.Types.MOORE
    for state in self.states.values():
      if(len(state.transitions) < 2):
        continue
      base_outputs = []
      for i, transition in enumerate(state.transitions):
        if(i == 0):
          base_outputs = transition.executed_outputs
          continue
        if(transition.executed_outputs != base_outputs):
          self.type = self.Types.MEALY
          break
    return self.type

  def is_moore(self):
    return self.type == self.Types.MOORE
  
  def is_mealy(self):
    return self.type == self.Types.MEALY

  #is this a yosys header -> starts with digits
  # Optional check if header text matches compare_header
  @staticmethod
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
  
  #get signal name from line
  # - either wire/reg name leading \
  # - or functional blokc leading $
  @staticmethod
  def signal_name(line):
    if ("\\" in line):
      return line[line.find("\\")+1::]
    if ("$" in line):
      return line[line.find("$")::]
    return "name error"
  
  def data_valid(self):
    return not (self.state_reg == "" or
    self.inputs == [] or
    self.outputs == [] or
    self.states == [] or 
    self.reset_input == "")