/*
 *  OffCourse::Verilog
 *		- Shift Register BMC
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	bmc(
  input wire clk,
  input wire reset,
  input wire serial_in,
);

  reg f_isReset;
  initial f_isReset <= 0;
  wire [7:0] ref_out, uut_out;

  REF REF (
    .clk(clk),
    .reset(reset),
    .serial_in(serial_in),
    .serial_out(ref_out)
  );

  UUT UUT(
    .clk(clk),
    .reset(reset),
    .serial_in(serial_in),
    .serial_out(uut_out)
  );

`ifdef	FORMAL
  always @(posedge clk) begin
    if(reset)
        f_isReset <= 1;
  end

  always @(*) begin
    if(f_isReset)
        assert(ref_out == uut_out);
  end
`endif
endmodule