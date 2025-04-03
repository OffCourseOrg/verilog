/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Question concat
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	UUT (
  input [1:0] a,
  input b,
  output [2:0] y
);

assign y = {a, b};

endmodule