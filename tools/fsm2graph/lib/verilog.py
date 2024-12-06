"""
 *  OffCourse::Verilog
 *		- fsm2graph - verilog descriptor extractor
 *
 *    Extract descriptors from verilog files
 *      - State params
 *
 *  Written by: Sybe
 *  License: MIT
"""

class VerilogExtractor:
  def __init__(self, file_input):
    self.data = {}

    block = ""
    for line in file_input:
      line = line.replace("\n", "").strip()

      if("//@" not in line and block == ""):
        continue
      
      if("//@" in line):
        block = line[line.find("@")+1::]
        self.data[block] = {}
        continue
      
      if(line != ""):
        key, value = line[:-1].split("=")
        key = key.strip().split(" ")[-1]
        if(key[0] != "_"):
          self.data[block][key] = int(value.strip())
        if(line[-1] == ";"):
          block = ""
        continue
    
  def __getitem__(self, key):
    return self.data[key]

  def __iter__(self):
    return self.data.keys()
