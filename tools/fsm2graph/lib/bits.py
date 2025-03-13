"""
 *  OffCourse::Verilog
 *		- fsm2graph - bits class
 *
 *  Written by: Sybe
 *  License: MIT
"""
import logging

class Bits:
  class BitsFormatException(Exception):
    pass
  
  class Selector():
     def __init__(self, end, start):
        self.end = end
        self.start = start

  def __init__(self, value: int, size: int):
    self._data = value
    self.yosys_str = ""
    self._size = size
  
  def sub_bits(self, section_count: int, index: int):
    if(section_count > self._size):
        raise IndexError(f"section_count: {section_count} is larger then self._size: {self._size}")
    if(not index < section_count):
        raise IndexError(f"index: {index} is not smaller then section_count: {section_count}")
    bits_per_section = self._size // section_count
    value = self._data >> (bits_per_section * (index))
    return Bits(value & int("1" * bits_per_section, 2), bits_per_section)

  def __invert__(self):
    return Bits(~self._data, self._size)
  def __le__(self, other):
      if isinstance(other, Bits):
          return self._data <= other._data
      else:
          raise TypeError("Unsupported operand type for <=: 'Bits' and '{}'".format(type(other)))
  def __ge__(self, other):
      if isinstance(other, Bits):
          return self._data >= other._data
      else:
          raise TypeError("Unsupported operand type for >=: 'Bits' and '{}'".format(type(other)))
  def __lt__(self, other):
      if isinstance(other, Bits):
          return self._data < other._data
      else:
          raise TypeError("Unsupported operand type for <: 'Bits' and '{}'".format(type(other)))
  def __gt__(self, other):
      if isinstance(other, Bits):
          return self._data > other._data
      else:
          raise TypeError("Unsupported operand type for >: 'Bits' and '{}'".format(type(other)))

  def __eq__(self, other):
      if isinstance(other, Bits):
          return self._data == other._data
      else:
          return False
  def __neq__(self, other):
     return not (self == other)
  
  def __and__(self, other):
      if isinstance(other, Bits):
          return Bits(self._data & other._data, max(self._size, other._size))
      else:
          raise TypeError("Unsupported operand type for &: 'Bits' and '{}'".format(type(other)))
  def __or__(self, other):
      if isinstance(other, Bits):
          return Bits(self._data | other._data, max(self._size, other._size))
      else:
          raise TypeError("Unsupported operand type for |: 'Bits' and '{}'".format(type(other)))
  def __xor__(self, other):
      if isinstance(other, Bits):
          return Bits(self._data ^ other._data, max(self._size, other._size))
      else:
          raise TypeError("Unsupported operand type for &: 'Bits' and '{}'".format(type(other)))

  def __lshift__(self, other):
      if isinstance(other, Bits):
          return Bits(self._data << other._data, self._size + other._data)
      else:
          raise TypeError("Unsupported operand type for <<: 'Bits' and '{}'".format(type(other)))
  def __rshift__(self, other):
      if isinstance(other, Bits):
          return Bits(self._data >> other._data, self._size)
      else:
          raise TypeError("Unsupported operand type for >>: 'Bits' and '{}'".format(type(other)))

  def __add__(self, other):
    if isinstance(other, Bits):
      return Bits(self._data + other._data, max(self._size, other._size))
    else:
        raise TypeError("Unsupported operand type for +: 'Bits' and '{}'".format(type(other)))
  def __sub__(self, other):
    if isinstance(other, Bits):
      return Bits(self._data - other._data, max(self._size, other._size))
    else:
        raise TypeError("Unsupported operand type for -: 'Bits' and '{}'".format(type(other)))


  def __bool__(self):
     value = self._data & 1
     return value == 1

  def __str__(self):
    if self.yosys_str != "":
       return self.yosys_str
    return f"{self._size}'{'%0*d' % (self._size, int(bin(self._data)[2:]))}"


  #Verilog Selector
  #selector => [end, start]
  def select(self, sel: Selector):
    return self.from_str(bin(self._data)[-sel.end + 2:-sel.start + 1])

  @classmethod
  #Concat a list of bits -> [0] = MSB
  def concat(cls, bits: list):
    bits.reverse()
    result = 0
    size = 0
    for i, bit in enumerate(bits):
       if(not isinstance(bit, Bits)):
          raise TypeError("Unsupported type in Bits concat => {}".format(type(bit)))
       result += bit._data << i
       size += bit._size
    return Bits(result, size)

  #Make bits instance from xxx string
  @classmethod
  def from_str(cls, bits_str: str):
    ##Eumerate bits_str in reverse to the first chr -> bit 0 / LSB
    data = ""
    size = 0
    for i, chr in enumerate(bits_str):
      if(chr not in "01"):
        raise Bits.BitsFormatException("Bits string contains non-0/1 -> %s", bits_str)
      size += 1
      data += chr
    return cls(int(data, 2), size)

  #Make bits instance form xxx string with 'x' 
  @classmethod
  def from_x_str(cls, bits_str: str):
    ##Eumerate bits_str in reverse to the first chr -> bit 0 / LSB
    size = int(bits_str[0])
    data = "0" * size
    return cls(int(data, 2), size)

  #Make bits instance from x'xxx string
  @classmethod
  def from_yosys_bits(cls, yosys_str: str):
    inst = None
    if(len(yosys_str) < 3 or yosys_str[1] != "'"):
      raise Bits.BitsFormatException("Malformed yosys_str not x'xxx format -> %s", yosys_str)
      return None
    if('x' in yosys_str):
      logging.warning("yosys_str contains 'x' -> %s", yosys_str)
      inst = cls.from_x_str(yosys_str)
    else:
       inst = cls.from_str(yosys_str[2::])
    inst.yosys_str = yosys_str
    return inst
  
  @staticmethod
  def is_yosys_bits(yosys_str: str):
    if(len(yosys_str) < 3 or yosys_str[1] != "'"):
      return False
    return True

