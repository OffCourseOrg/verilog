"""
 *  OffCourse::Verilog
 *		- fsm2graph - yosys table netlist cells
 *
 *  Written by: Sybe
 *  License: MIT
"""

class Cell:
  resolve_format = ""
  type= ""
  class CellTypeError(Exception):
    pass

  class Port:
    def __init__(self, dir, netname) -> None:
      self.direction = dir
      self.netname = netname
    
    def is_output(self):
      return self.direction == "out"

  def __init__(self, name, port, dir, netname) -> None:
    self.name = name
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
    text = self.resolve_format
    for port_name, port in self.ports.items():
      if(port.is_output()):
        continue
      if("$") not in port.netname:
        text = text.replace(port_name, port.netname) 
        continue
      text = text.replace(port_name, netlist.resolve(port.netname))
    return text
  
class Not(Cell):
  type = "$not"
  resolve_format = "~A"

class Pos(Cell):
  type = "$pos"
  resolve_format = "+A"

class Neg(Cell):
  type = "$neg"
  resolve_format = "-A"

class ReduceAND(Cell):
  type = "$reduce_and"
  resolve_format = "&A"

class ReduceOR(Cell):
  type = "$reduce_or"
  resolve_format = "|A"

class ReduceXOR(Cell):
  type = "$reduce_xor"
  resolve_format = "^A"

class ReduceXNOR(Cell):
  type = "$reduce_xnor"
  resolve_format = "~^A"

class ReduceBOOL(Cell):
  type = "$reduce_bool"
  resolve_format = "|A"

class LogicNOT(Cell):
  type = "$logic_not"
  resolve_format = "!A"

class LogicAND(Cell):
  type = "$logic_and"
  resolve_format = "A && B"

class LogicOR(Cell):
  type = "$logic_or"
  resolve_format = "A || B"

class AND(Cell):
  type = "$and"
  resolve_format = "A & B"

class OR(Cell):
  type = "$or"
  resolve_format = "A | B"

class XOR(Cell):
  type = "$xor"
  resolve_format = "A ^ B"

class XNOR(Cell):
  type = "$xnor"
  resolve_format = "A ~^ B"

class SHL(Cell):
  type = "$shl"
  resolve_format = "A << B"

class SHR(Cell):
  type = "$shr"
  resolve_format = "A >> B"

class SSHL(Cell):
  type = "$sshl"
  resolve_format = "A <<< B"

class SSHR(Cell):
  type = "$sshr"
  resolve_format = "A <<< B"

class EQ(Cell):
  type = "$eq"
  resolve_format = "A == B"

class EQX(Cell):
  type = "$eqx"
  resolve_format = "A === B"

class NEQ(Cell):
  type = "$neq"
  resolve_format = "A !== B"


###Specials
class MUX(Cell):
  type = "$mux"
  resolve_format = "S ? B : A"

class PMUX(Cell):
  type = "$pmux"
  resolve_format = "S ? B : A"

def cell_factory(cell_name, type, port, direction, netname):
  match(type):
    case(Not.type):
      return Not(cell_name, port, direction, netname)
    case(Pos.type):
      return Pos(cell_name, port, direction, netname)
    case(Neg.type):
      return Neg(cell_name, port, direction, netname)
    case(ReduceAND.type):
      return ReduceAND(cell_name, port, direction, netname)
    case(ReduceOR.type):
      return ReduceOR(cell_name, port, direction, netname)
    case(ReduceXOR.type):
      return ReduceXOR(cell_name, port, direction, netname)
    case(ReduceXNOR.type):
      return ReduceXNOR(cell_name, port, direction, netname)
    case(ReduceBOOL.type):
      return ReduceBOOL(cell_name, port, direction, netname)
    case(LogicNOT.type):
      return LogicNOT(cell_name, port, direction, netname)
    case(LogicAND.type):
      return LogicAND(cell_name, port, direction, netname)
    case(LogicOR.type):
      return LogicOR(cell_name, port, direction, netname)
    case(AND.type):
      return AND(cell_name, port, direction, netname)
    case(OR.type):
      return OR(cell_name, port, direction, netname)
    case(XOR.type):
      return XOR(cell_name, port, direction, netname)
    case(XNOR.type):
      return XNOR(cell_name, port, direction, netname)
    case(SHL.type):
      return SHL(cell_name, port, direction, netname)
    case(SHR.type):
      return SHR(cell_name, port, direction, netname)
    case(SSHL.type):
      return SSHL(cell_name, port, direction, netname)
    case(SSHR.type):
      return SSHR(cell_name, port, direction, netname)
    case(EQ.type):
      return EQ(cell_name, port, direction, netname)
    case(EQX.type):
      return EQX(cell_name, port, direction, netname)
    case(NEQ.type):
      return NEQ(cell_name, port, direction, netname)
    case(MUX.type):
      return MUX(cell_name, port, direction, netname)
    case(PMUX.type):
      return PMUX(cell_name, port, direction, netname)
    case _:
        raise Cell.CellTypeError("Unknown type -> %s", type)