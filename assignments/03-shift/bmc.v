/*
 *  OffCourse::Verilog
 *		- Shift Register BMC
 *
 *  Written by: Sybe
 *  License: MIT
 */

module	bmc(
  input wire clk,
  input wire enable,
  input wire reset,
  input wire serial_in,
);

  reg f_isReset;
  initial f_isReset <= 0;
  wire [7:0] ref_out, dut_out;

  REF REF (
    .clk(clk),
    .enable(enable),
    .reset(reset),
    .serial_in(serial_in),
    .serial_out(ref_out)
  );

  DUT DUT(
    .clk(clk),
    .enable(enable),
    .reset(reset),
    .serial_in(serial_in),
    .serial_out(dut_out)
  );

`ifdef	FORMAL
  always @(posedge clk) begin
    if(reset)
        f_isReset <= 1;
  end

  always @(*) begin
    if(f_isReset)
        assert(ref_out == dut_out);
  end
`endif
endmodule