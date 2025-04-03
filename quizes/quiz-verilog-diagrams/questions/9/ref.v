/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Question 9
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	UUT (
		input clk,
		input reset,
		input in,
		output out
	);

	reg [7:0] register;

	always @(posedge clk) begin
	register <= register;
		if (reset) begin
			register <= 8'b00000000;
		end else begin
			register = {register[6:0], in};
		end
	end

	assign out = register[7];

endmodule