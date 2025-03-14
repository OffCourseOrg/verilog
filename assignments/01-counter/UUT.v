/*
 *  OffCourse::Verilog
 *		- Counter UUT
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module UUT (
	input clk,
	input reset,
	input enable,
	output reg [15:0] count
);

	always @(posedge clk) begin
		if(reset) begin
			count <= 0;
		end else if(enable && count < 69) begin
			count <= count + 1;
		end else begin
			count <= count;
		end
	end

endmodule
