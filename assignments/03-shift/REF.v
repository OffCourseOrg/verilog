/*
 *  OffCourse::Verilog
 *		- Shift Register REF
 *
 *  Written by: Sybe
 *  License: MIT
 */

module	REF (
		input clk,
		input reset,
		input enable,
		input serial_in,
		output serial_out,
		output [7:0] data_out,
	);
	reg [7:0] register;


	always @(posedge clk) begin
		if (reset) begin
			register <= 8'b0;
		end else if (enable) begin
			register <= {register[7:1], serial_in};
		end
	end

	assign serial_out = register[7];

`ifdef FORMAL
	reg f_past_valid;

	initial begin
		f_past_valid = 0;
	end

	always @(posedge clk) begin
		//track if rest into valid state
		if(reset)
			f_past_valid <= 1;

		//Data shifted
		if(f_past_valid && $past(enable) && !$past(reset)) begin
			assert(register[0] == $past(serial_in));
			assert(serial_out == $past(register[7]));
		end
	end

	always @(*) begin
		assume(serial_in != 1'b0);
	end
`endif

endmodule