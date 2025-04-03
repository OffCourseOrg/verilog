/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Question select-xor-concat
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	UUT (
  input [3:0] a,
  output [1:0] y
);

assign y = {a[3] ^ a[2], a[1] ^ a[0]};

endmodule