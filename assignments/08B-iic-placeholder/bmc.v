/*
 *  OffCourse::Verilog
 *		- Home Security BMC
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	bmc(
  input wire clk,
  input wire reset
);

  reg f_isReset;
  initial f_isReset <= 0;
  wire [7:0] ref_out, uut_out;

  REF REF (
    .clk(clk),
    .reset(reset)
  );

  UUT UUT(
    .clk(clk),
    .reset(reset)
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