/*
 *  OffCourse::Verilog
 *		- Counter REF
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	REF #(
		parameter [15:0] MAX_AMOUNT = 22,
	) (
		input clk,
		input reset,
		input enable,
		output reg [15:0] count,
	);

	reg f_isReset = 0;

	always @(posedge clk) begin
		if(reset) begin
			f_isReset <= 1;
			count <= 0;
		end
		else if(enable)
			if(count != MAX_AMOUNT)
				count <= count + 1;
			else begin
				count <= count;
			end
	end

`ifdef FORMAL

	always @(posedge clk) begin
		if(f_isReset && count >= MAX_AMOUNT) begin
			cover();
		end
	end

	always @(*) begin
		if(f_isReset) begin
			assert(count <= MAX_AMOUNT);
			assert(count >= 0);
		end
	end
`endif

endmodule