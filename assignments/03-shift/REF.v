/*
 *  OffCourse::Verilog
 *		- Shift Register REF
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	REF (
		input clk,
		input reset,
		input enable,
		input serial_in,
		output serial_out
	);
	reg [7:0] register;

	always @(posedge clk) begin
		register <= register;

		if (reset) begin
			register <= 8'b0;
		end else if (enable) begin
			register <= register << 1;
			register[0] <= serial_in;
		end
	end

	assign serial_out = register[7];

`ifdef FORMAL
	reg f_is_reset;

	initial begin
		f_is_reset = 0;
	end

	always @(posedge clk) begin
		//track if rest into valid state
		if(reset)
			f_is_reset <= 1;

		//Data shifted
		if(f_is_reset && $past(enable) && !$past(reset)) begin
			assert(register[0] == $past(serial_in));
		end
	end

	always @(*) begin
		if(f_is_reset) begin
			cover(register[7] != 1'b0);
		end
	end
`endif

endmodule