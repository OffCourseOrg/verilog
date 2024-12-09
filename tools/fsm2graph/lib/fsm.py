"""
 *  OffCourse::Verilog
 *		- fsm2graph - yosys fsm parsing
 *
 *    Parser for the text output of yosys FSM_info
 *
 *  Written by: Sybe
 *  License: MIT
"""

import logging

class FSMInfoParser:
  fsm_info_header = "Executing FSM_INFO pass (dumping all available information on FSM cells)."

  class state:
    def __init__(self, verilog_id, fsm_id, is_reset=False, name=""):
      self.name = name
      self.verilog_id = verilog_id
      self.fsm_id = fsm_id
      self.is_reset = is_reset
      self.base_transition = []
      self.transitions: dict[str, list] = {}

    def add_transition(self, state_next, outputs=[]):
      if(outputs == []):
         return
      if(self.base_transition == []):
         self.base_transition = outputs
      self.transitions[state_next] = outputs

  def __init__(self, lines):
    self.state_reg = ""
    self.inputs = []
    self.outputs = []
    self.transitions = []
    self.states = []
    self.reset_input = "reset"

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
          self.states.append(FSMInfoParser.state(
             verilog_id=verilog_id,
             fsm_id=len(self.states),
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
            transition["inputs"][self.inputs[i]] = int(chr)
          
          for i, chr in enumerate(line[i_outputs::][::-1]):
            transition["outputs"][self.outputs[i]] = int(chr)
          
          if("reset" in transition["inputs"]):
            transition["reset"] = transition["inputs"]["reset"] == 1

          self.transitions.append(transition)
          continue
        in_block = False
        parsed["transitions"] = True

  def get_state_index(self, fsm_id):
    for i, state in enumerate(self.states):
      if(state.fsm_id == fsm_id):
         return i
  
  def get_state(self, fsm_id):
    for state in self.states:
      if(state.fsm_id == fsm_id):
         return state

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
    self.transitions == [] or
    self.states == [] or 
    self.reset_input == "")