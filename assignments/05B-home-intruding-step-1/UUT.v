/*
 *  OffCourse::Verilog
 *		- Home Intruding Step 1 UUT
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	UUT (
		input clk,
		input reset,
		input enable,

		output reg [3:0] count,
		output rollover
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