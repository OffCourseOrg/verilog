/*
 *  OffCourse::Verilog
 *		- Shift Register REF
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	REF (
		input a,
		input [3:0] b,
		output [4:0] c,

		input [1:0] d,
		input [3:0] e,
		output [5:0] f,

		output [1:0] g,
		output [3:0] h,
		input [5:0] i,
	);

	assign c = {b, a};
	assign f = {e, d};
	assign g = i[1:0];
	assign h = i[5:2];

`ifdef FORMAL
	reg f_is_reset;

	initial begin
		f_is_reset = 0;
	end

`endif

endmodule