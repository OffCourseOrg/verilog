/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Question 9
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */


module register (
	input clk,
	input reset,
	input in,
	output reg out
);
	
	always @(posedge clk) begin
		if(reset)
			out <= 0;
		else 
			out <= in;
	end

endmodule

module	UUT (
		input clk,
		input reset,
		input in,
		output detected
	);

	wire [2:0] sequence;

	register S1 (
		.clk(clk),
		.reset(reset),
		.in(in),
		.out(sequence[0])
	);

	register S2 (
		.clk(clk),
		.reset(reset),
		.in(sequence[0]),
		.out(sequence[1])
	);

	register S3 (
		.clk(clk),
		.reset(reset),
		.in(sequence[1]),
		.out(sequence[2])
	);

	assign detected = sequence == 3'b101;

endmodule