/*
 *  OffCourse::Verilog
 *		- Shift Register UUT
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module UUT (
    input clk,
		input reset,
		input serial_in,
		output serial_out
	);
	reg [7:0] register;

  always @(posedge clk) begin
    if(reset) begin
      register <= 8'b0;
    end else begin
      register <= register << 1;
      register[0] <= serial_in;
    end
  end

  assign serial_out = register[7];

endmodule