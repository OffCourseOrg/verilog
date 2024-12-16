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
  
  def __init__(self, value: int, size: int):
    self._data = value
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
    return f"{self._size}'{'%0*d' % (self._size, int(bin(self._data)[2:]))}"

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

  #Make bits instance from x'xxx string
  @classmethod
  def from_yosys_bits(cls, yosys_str: str):
    if(len(yosys_str) < 3 or yosys_str[1] != "'"):
      raise Bits.BitsFormatException("Malformed yosys_str not x'xxx format -> %s", yosys_str)
    return cls.from_str(yosys_str[2::])
  
  @staticmethod
  def is_yosys_bits(yosys_str: str):
    if(len(yosys_str) < 3 or yosys_str[1] != "'"):
      return False
    return True

