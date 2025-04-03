/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Question pattern
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */


module	UUT (
		input clk,
		input [4:0] pattern,
		input in,
		output detected
	);

	reg a, b, c, d, e;
	always @(posedge clk) begin
		a <= b;
		b <= c;
		c <= d;
		d <= e;
		e <= in;
	end

	wire [4:0] sequence;
	assign detected = pattern == {a, b, c, d, e};

endmodule