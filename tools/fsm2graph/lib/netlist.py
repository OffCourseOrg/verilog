"""
 *  OffCourse::Verilog
 *		- fsm2graph - yosys table netlist wrapper
 *
 *    Parser for the yosys table netlist output
 *
 *  Written by: Sybe
 *  License: MIT
"""

import logging
from cell import Cell

if(len(logging.getLogger().handlers) == 0):
  logging.basicConfig(level=logging.WARN)

class Module:
  def __init__(self, name) -> None:
    self.name = name
    self.io = {}
    self.cells: dict[str, Cell]  = {}
    pass

  def add_io(self, name, direction, netname):
    self.io[name] = self.IO(name, direction, netname)

  def has_cell(self, cell):
    return cell.name in self.cells.keys()

  def add_cell(self, cell):
    if(not self.has_cell(cell)):
      self.cells[cell.name] = cell
      return
    self.cells[cell.name].merge(cell)

  class IO:
    def __init__(self, name, direction, netname):
      self.name = name
      self.direction = "output" if direction == "po" else "input"
      self.netname = netname
    pass

class Net:
  def __init__(self, netname, cell_name) -> None:
    self.name = netname
    self.cell_name = cell_name
    self.is_internal = "$" in self.name
    self.resolved = ""
    
  def resolve(self, netlist):
    if(not self.is_internal):
      return self.name
    if(self.resolved == ""):
      self.resolved = self.get_cell(netlist).resolve(netlist)
      logging.info("Resolved: %s -> %s", self.name, self.resolved)
    return self.resolved
    
  def get_cell(self, netlist):
    return netlist.get_cell(self.cell_name)


class Netlist:
  def add_net(self, net: Net):
      if(net.name in self.nets):
        return
      self.nets[net.name] = net

  def __init__(self, file_input):
    self.modules: dict[str, Module] = {}
    self.nets: dict[str, Net]  = {}

    skipped_cells = []
    for line in file_input:
      line = line.replace("\\", "")
      module_name, cell_name, type, port, direction, netname = line.split("\t")

      if(module_name not in self.modules.keys()):
        self.modules[module_name] = Module(module_name)
      module = self.modules[module_name]

      #module in-out
      if(type == "-" and port == "-"):
        module.add_io(cell_name, direction, netname)
        continue
      
      if(cell_name in skipped_cells):
        continue

      #Cells
      try:
        cell = Cell(cell_name, type, port, direction, netname)
        module.add_cell(cell)

        #Nets come from somewhere:
        if(cell.is_output(netname)):
          net = Net(netname, cell_name)
          self.add_net(net)
        
      except Cell.CellTypeError:
        skipped_cells.append(cell_name)
        logging.debug("Skipping Unknown Type: %s for cell -> %s", type, cell_name)

  def get_cell(self, cell_name: str):
    for module in self.modules.values():
      if(cell_name in module.cells):
        return module.cells[cell_name]
    return None
  
  def resolve(self, netname):
    if(netname not in self.nets):
      logging.warning("Net not in netlist -> %s", netname)
      return
    net = self.nets[netname]
    return net.resolve(self)

# import logging.handlers
# import sys
# with open(sys.argv[1]) as f:
#   netlist = Netlist(f.read().splitlines())
#   resolved = netlist.resolve("trigger_$logic_and_A_Y")
# pass