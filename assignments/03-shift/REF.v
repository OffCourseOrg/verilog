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
	localparam SHIFT_SIZE = 8;

	reg [SHIFT_SIZE-1:0] register;

	generate
	genvar i;

	always @(posedge clk) begin
		if (reset) begin
				for (i = SHIFT_SIZE-1; i >= 0; i = i -1) begin
					register[i] <= 1'b0;
				end
		end else if (enable) begin
				for (i = SHIFT_SIZE-1; i > 0; i = i -1) begin
					register[i] <= register[i-1]; 
				end

			register[0] <= serial_in;
		end
	end
	endgenerate

	assign serial_out = register[SHIFT_SIZE-1];

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