/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Question shift
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	UUT (
		input clk,
		input enable,
		input in,
		output out
	);

	reg [7:0] register;

	always @(posedge clk) begin
		if (enable) begin
			register = {register[6:0], in};
		end else begin
			register <= register;
		end
	end

	assign out = register[7];

endmodule