/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Question 2
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module UUT (
  input s,
  input a,
  input b,
  output y
);
  
  assign y = s ? (b ? a : ~a) : (a ? b : ~b);
endmodule