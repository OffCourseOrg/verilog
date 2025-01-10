/*
 *  OffCourse::Verilog
 *		- Home Intruding Step 2 DIGIT_COUNTER
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module counter (
		input clk,
		input reset,
		input enable,

		output rollover,
		output reg [3:0] count
	);

	wire count_finish;

	always @(posedge clk) begin
		if(reset) begin
			count <= 0;
		end else if(enable) begin
			if(!count_finish)
				count <= count + 1;
			else
				count <= 0;
		end
	end

	assign count_finish = count == 9;
	assign rollover = enable && count_finish;
endmodule

