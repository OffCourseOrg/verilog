/*
 *  OffCourse::Verilog
 *		- Shift Register DUT
 *
 *  Written by: Sybe
 *  License: MIT
 */

module DUT (
    input clk,
		input reset,
		input enable,
		input serial_in,
		output serial_out
	);
	reg [7:0] register;

  always @(posedge clk) begin
    if(reset) begin
      register <= 8'b0;
    end else if(enable) begin
      register <= register << 1;
      register[0] <= serial_in;
    end
  end

  assign serial_out = register[7];

endmodule