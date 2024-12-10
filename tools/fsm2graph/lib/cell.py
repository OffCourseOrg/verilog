"""
 *  OffCourse::Verilog
 *		- fsm2graph - yosys table netlist cells
 *
 *  Written by: Sybe
 *  License: MIT
"""
import logging

from .utils import get_binary_bits, get_subsection_binary, is_value, get_value

class Cell:
  resolve_format = ""
  type= ""
  class CellTypeError(Exception):
    pass
  
  class CellExecuteError(Exception):
    pass

  class Port:
    def __init__(self, dir, netname) -> None:
      self.direction = dir
      self.netname = netname
      self.netnames = []
    
    def is_output(self):
      return self.direction == "out"

  def __init__(self, name, port, dir, netname) -> None:
    self.name = name
    self.ports: dict[str, Cell.Port] = {}
    self.add_port(port, dir, netname)

  def add_port(self, port, dir, netname) -> Port:
    #Direct net
    if("{" not in netname):
     self.ports[port] = self.Port(dir, netname)
     return self.ports[port]
    #Combined net
    ##split nets from combined net and reverse due to bit order
    if(dir == "out" and self.type != "$fsm"):
      raise NotImplementedError("Cell output is combined net!")
    self.ports[port] = self.Port(dir, "")
    for i, split_netname in enumerate(netname[2:-2].split(" ")[::-1]):
      logging.info("Pulled '%s' with index: %d from %s", split_netname, i, netname)
      self.ports[port].netnames.append(split_netname)
    

  def merge(self, cell):
    if(self.name != cell.name):
      return
    self.ports |= cell.ports

  def is_output(self, netname):
    for port in self.ports.values():
      if(port.netname == netname):
        return port.is_output()
    return False

  #Resolve output of cell in terms of cell inputs
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
      
  #Execute cell to obtain output mapping 
  def execute(self, netlist, args={}, start_net="") -> str:
    return self.resolve(netlist)
  
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

class NE(Cell):
  type = "$ne"
  resolve_format = "A != B"

class EQX(Cell):
  type = "$eqx"
  resolve_format = "A === B"

class NEX(Cell):
  type = "$nex"
  resolve_format = "A !== B"

class LT(Cell):
  type = "$lt"
  resolve_format = "A < B"

class LE(Cell):
  type = "$neq"
  resolve_format = "A <= B"

class GE(Cell):
  type = "$ge"
  resolve_format = "A >= B"

class GT(Cell):
  type = "$gt"
  resolve_format = "A > B"

class ADD(Cell):
  type = "$add"
  resolve_format = "A + B"

class SUB(Cell):
  type = "$sub"
  resolve_format = "A - B"

class MUL(Cell):
  type = "$mul"
  resolve_format = "A * B"

class DIV(Cell):
  type = "$neq"
  resolve_format = "A / B"

class POW(Cell):
  type = "$pow"
  resolve_format = "A ** B"

##Execute Enabled
#Multiplexer
class MUX(Cell):
  # Y = S ? B : A
  type = "$mux"
  resolve_format = "S ? B : A"

  def execute(self, netlist, args={}, start_net=""):
    execute_net = self.ports["S"].netname
    if(execute_net not in args):
      execute_net = netlist.execute(self.ports["S"].netname, args, start_net)
    value = args[execute_net] if execute_net in args else get_value(execute_net)
    if(value == 1):
      return self.ports['B'].netname
    return self.ports['A'].netname
  
#Priority Multipler
class PMUX(Cell):
  # Y = A
  # for bit in S
  #   if(bit == 1 or bit == X)
  #      Y = bit
  type = "$pmux"
  resolve_format = "pmux"
  def execute(self, netlist, args={}, start_net=""):
    if(len(self.ports['S'].netnames) == 0):
      raise NotImplementedError("$pmux with non-combined S port")
    
    execute_nets = self.ports["S"].netnames
    for index, netname in enumerate(self.ports["S"].netnames):
      if(netname not in args):
        execute_nets[index] = netlist.execute(netname, args, start_net)
    
    #Combined B net
    if(len(self.ports["B"].netnames)):
      for i, execute_net in enumerate(execute_nets):
        if(args[execute_net] == 1):
          return netlist.execute(self.ports["B"].netnames[i], args, start_net)
    else:
      #Static B net
      if(not is_value(self.ports["B"].netname)):
        raise NotImplementedError("$pmux with non-static 'B' -> %s", self.ports["B"])
      for i, execute_net in enumerate(execute_nets):
        if(args[execute_net] == 1 if execute_net in args else get_value(execute_net) == 1):
          subsection_length = len(get_binary_bits(self.ports["B"].netname)) // len(execute_nets)
          return get_subsection_binary(self.ports['B'].netname, subsection_length, i)
    return self.ports['A'].netname

#dff latch
class DFF(Cell):
  # Q = D
  type = "$dff"
  resolve_format = "$dff"
  def execute(self, netlist, args={}, start_net=""):
    return self.ports['D'].netname
  
###UNIQUE
class FSM(Cell):
  type = "$fsm"
  resolve_format = "$fsm"

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
    case(NE.type):
      return NE(cell_name, port, direction, netname)
    case(EQX.type):
      return EQX(cell_name, port, direction, netname)
    case(NEX.type):
      return NEX(cell_name, port, direction, netname)
    case(MUX.type):
      return MUX(cell_name, port, direction, netname)
    case(PMUX.type):
      return PMUX(cell_name, port, direction, netname)
    case(DFF.type):
      return DFF(cell_name, port, direction, netname)
    case(LT.type):
      return LT(cell_name, port, direction, netname)
    case(LE.type):
      return LE(cell_name, port, direction, netname)
    case(GT.type):
      return GT(cell_name, port, direction, netname)
    case(GE.type):
      return GE(cell_name, port, direction, netname)
    case(ADD.type):
      return ADD(cell_name, port, direction, netname)
    case(SUB.type):
      return SUB(cell_name, port, direction, netname)
    case(MUL.type):
      return MUL(cell_name, port, direction, netname)
    case(DIV.type):
      return DIV(cell_name, port, direction, netname)
    case(POW.type):
      return POW(cell_name, port, direction, netname)
    case(FSM.type):
      return FSM(cell_name, port, direction, netname)
    case _:
        raise Cell.CellTypeError("Unknown type -> %s", type)