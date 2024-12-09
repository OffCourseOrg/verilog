"""
 *  OffCourse::Verilog
 *		- fsm2graph - utility functions
 *
 *
 *  Written by: Sybe
 *  License: MIT
"""

def is_binary_str(data: str):
  if(len(data) < 2):
    return False
  return data[1] == "'"

def is_value(data: str | int):
  if(isinstance(data, int)):
    return True
  if(is_binary_str(data)):
    return True
  return False

def get_string(data: str | int):
  if(isinstance(data, int)):
    binary = bin(data)[2:]
    return f"{len(binary)}'{binary}"
  if(is_binary_str(data)):
    return data
  raise Exception("Data neither Int nor BinaryString -> %s", data)

def get_value(data: str | int):
  if(isinstance(data, int)):
    return data
  if(is_binary_str(data)):
    return int(data[2::])
  raise Exception("Data neither Int nor BinaryString -> %s", data)

def get_binary_bits(data: str):
  return data[2::]

def get_subsection_binary(data: str, section_length: int, index: int):
  bits = data[2::]
  if(len(bits) % section_length != 0):
    raise Exception("Binary section_length not equally dividing bits")
  return f"{section_length}'{bits[index*section_length:section_length*(index+1)]}"
