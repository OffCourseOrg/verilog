/*
 *  OffCourse::Verilog
 *		- Home Intruding Step 1 BMC
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	bmc(
  input wire clk,
  input wire enable,
  input wire reset
);

  reg f_isReset;
  initial f_isReset = 0;
  wire [3:0] ref_count, uut_count;
  wire ref_rollover, uut_rollover;

  REF REF (
    .clk(clk),
    .enable(enable),
    .reset(reset),

    .count(ref_count),
    .rollover(ref_rollover)
  );

  UUT UUT(
    .clk(clk),
    .enable(enable),
    .reset(reset),

    .count(uut_count),
    .rollover(uut_rollover)
  );

`ifdef	FORMAL
  always @(posedge clk) begin
    if(reset)
        f_isReset <= 1;
  end

  always @(*) begin
    if(f_isReset) begin
        assert(ref_count == uut_count);
        assert(ref_rollover == uut_rollover);
    end
  end
`endif
endmodule