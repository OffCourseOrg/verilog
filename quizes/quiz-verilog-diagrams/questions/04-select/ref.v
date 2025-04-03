/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Question select
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	UUT (
  input [3:0] a,
  output [1:0] y,
  output [1:0] z
);

assign y = a[1:0];
assign z = a[3:2];

endmodule