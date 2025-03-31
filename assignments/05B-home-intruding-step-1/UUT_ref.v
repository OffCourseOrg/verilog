/*
 *  OffCourse::Verilog
 *		- Home Intruding Step 1 UUT Solution
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
			if(count != 9)
				count <= count + 1;
			else
				count <= 0;
		end
	end

	assign rollover = (count == 9) && enable;

endmodule