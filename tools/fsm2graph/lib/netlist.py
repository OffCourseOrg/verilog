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

from .utils import is_value
from .cell import Cell, cell_factory

if(len(logging.getLogger().handlers) == 0):
  logging.basicConfig(level=logging.WARN)

class Module:
  class IO:
    def __init__(self, name, direction, netname):
      self.name = name
      self.direction = "out" if direction == "po" else "in"
      self.netname = netname
      self.outputs = []

  def __init__(self, name) -> None:
    self.name = name
    self.io: dict[str, Module.IO] = {}
    self.cells: dict[str, Cell]  = {}

  def add_io(self, name, direction, netname):
    self.io[name] = self.IO(name, direction, netname)
    return self.io[name]

  def get_outputs(self):
    self.outputs = []
    for key, io in self.io.items():
      if(io.direction == "out"):
        self.outputs.append(key)
    return self.outputs
  
  def is_io(self, net):
    for key, io in self.io.items():
      if(net == io.netname):
        return True
    return False

  def has_cell(self, cell):
    return cell.name in self.cells.keys()

  def add_cell(self, cell):
    if(not self.has_cell(cell)):
      self.cells[cell.name] = cell
      return
    self.cells[cell.name].merge(cell)

  def get_cell_by_output(self, netname):
    for cell in self.cells.values():
      for port in cell.ports.values():
        if(port.direction == "out"):
          if(port.netname == netname):
            return cell
    return None

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
  class CellNotImplementedError(Exception):
    pass
  def add_net(self, net: Net):
      if(net.name in self.nets):
        return
      self.nets[net.name] = net

  def __init__(self, file_input):
    self.modules: dict[str, Module] = {}
    self.nets: dict[str, Net]  = {}
    self.top: Module = None
    self.external_driven_net = []
    self.output_netnames = []

    skipped_cells = []
    for line in file_input:
      line = line.replace("\\", "")
      module_name, cell_name, type, port, direction, netname = line.split("\t")


      if(module_name not in self.modules.keys()):
        self.modules[module_name] = Module(module_name)
        if(self.top == None):
          self.top = self.modules[module_name]
      module = self.modules[module_name]

      #module in-out
      if(type == "-" and port == "-"):
        io = module.add_io(cell_name, direction, netname)
        if(io.direction == "in"):
          self.external_driven_net.append(netname)
        else:
          self.output_netnames.append(netname)
        continue
      
      if(cell_name in skipped_cells):
        continue

      #Cells
      cell = cell_factory(cell_name, type, port, direction, netname)
      module.add_cell(cell)

      #Nets come from somewhere:
      if(cell.is_output(netname)):
        net = Net(netname, cell_name)
        self.add_net(net)

  def get_net(self, netname: str) -> Net:
    if(netname in self.external_driven_net):
      return netname
    if(netname not in self.nets):
      return netname
    return self.nets[netname]

  def get_cell(self, cell_name: str):
    for module in self.modules.values():
      if(cell_name in module.cells):
        return module.cells[cell_name]
    return None
  
  def resolve(self, netname):
    if(netname not in self.nets):
      logging.warning("Net not in netlist -> %s", netname)
      return netname
    net = self.nets[netname]
    return net.resolve(self)
  
  def execute(self, netname, args={}, start_net=""):
    if(is_value(netname)):
      return netname
    if(netname in args):
      return args[netname]
    if(start_net == netname):
      return netname
    if(start_net == ""):
      start_net = netname
    if(netname in self.external_driven_net):
      return netname
    cell = self.get_cell_by_output(netname)
    if(cell == None):
      if(netname in self.output_netnames):
        logging.warning("Output is not driven by module =/=> %s",netname)
        return netname
      raise Cell.CellExecuteError("No cell drives net => %s", netname)
    return cell.execute(self, args, start_net)
  
  def get_cell_by_output(self, netname) -> Cell:
    for module in self.modules.values():
      cell = module.get_cell_by_output(netname)
      if(cell == None):
        continue
      return cell