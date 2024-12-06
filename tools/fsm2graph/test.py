#!/usr/bin/env python
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

import sys
from lib import Netlist
with open(sys.argv[1]) as f:
  netlist = Netlist(f.read().splitlines())
pass