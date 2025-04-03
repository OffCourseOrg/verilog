/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Question 4
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	UUT (
  input a,
  input b,
  output [1:0] y
);

assign y = {a, b};

endmodule