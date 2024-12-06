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


class Cell:
  type_lookup = {
    "$not": "~A",
    "$pos": "+A",
    "$neg": "-A",
    "$reduce_and":  "&A",
    "$reduce_or": "|A",
    "$reduce_xor":  "^A",
    "$reduce_xnor": "~^A",
    "$reduce_bool": "|A",
    "$logic_not":  "!A",
    "$and": "A & B", 
    "$or": "A | B",
    "$xor": "A  ^ B",
    "$xnor": "A ~^ B",
    "$shl": "A << B",
    "$shr": "A >> B",
    "$sshl": "A <<< B",
    "$sshr": "A >>> B",
    "$logic_and": "A && B",
    "$logic_or": "A || B",
    "$eq": "A == B",
    "$eqx": "A === B",
    "$nex": "A !== B",
    "$mux": "S ? B : A",
    "$pmux": "pmux"
  }
  class CellTypeError(Exception):
    pass

  class Port:
    def __init__(self, dir, netname) -> None:
      self.direction = dir
      self.netname = netname
    
    def is_output(self):
      return self.direction == "out"

  def __init__(self, name, type, port, dir, netname) -> None:
    if(type not in self.type_lookup):
      raise self.CellTypeError
    
    self.name = name
    self.type = type
    self.ports: dict[str, Cell.Port] = {}
    self.add_port(port, dir, netname)

  def add_port(self, port, dir, netname):
    self.ports[port] = self.Port(dir, netname)
  
  def merge(self, cell):
    if(self.name != cell.name):
      return
    self.ports |= cell.ports

  def is_output(self, netname):
    for port in self.ports.values():
      if(port.netname == netname):
        return port.is_output()
    return False

  def resolve(self, netlist):
    text = self.type_lookup[self.type]
    for port_name, port in self.ports.items():
      if(port.is_output()):
        continue
      if("$") not in port.netname:
        text = text.replace(port_name, port.netname) 
        continue
      text = text.replace(port_name, netlist.resolve(port.netname))
    return text

class Net:
  def __init__(self, netname, cell_name) -> None:
    self.name = netname
    self.cell_name = cell_name
    self.is_internal = "$" in self.name
    
  def resolve(self, netlist):
    if(not self.is_internal):
      return self.name
    return self.get_cell(netlist).resolve(netlist)
    
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