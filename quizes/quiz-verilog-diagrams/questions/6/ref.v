/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Question 6
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	UUT (
  input [3:0] a,
  output [1:0] y,
  output [1:0] z
);

assign y = {a[0], a[2]};
assign z = {a[1], a[3]};

endmodule