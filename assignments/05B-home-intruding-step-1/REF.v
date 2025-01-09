/*
 *  OffCourse::Verilog
 *		- Home Intruding Step 1 REF
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	REF (
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

`ifdef FORMAL
	reg f_is_reset;

	initial begin
		f_is_reset = 0;
	end

	always @(posedge clk) begin
		if(reset) begin
			f_is_reset <= 1;
		end

		if(f_is_reset) begin
			assert(count <= 9);
			assert(count == $past(count)+1 || count == 0 || count == count);
			
			//Can complete cycle
			if($past(reset) == 0 && $past(count) == 9 && enable) begin
				cover(count == 0);
			end
		end
	end

	always @(*) begin
		if(f_is_reset) begin
			//rollover gets asserted
			if(count == 9 && enable) begin
				assert(rollover == 1);
			end
		end
	end

`endif

endmodule