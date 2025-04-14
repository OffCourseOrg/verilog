/*
 *  OffCourse::Verilog
 *		- Aegir's Brewery fsm_bmc
 *
 *  Copyright: Sybe Feitsma && e.t.s.v Thor
 *  License: GPLv3 or later
 */

 module bmc(
  input clk,
  input reset,
  input [7:0] temp,
  input [7:0] level
 );

  reg f_isReset;
  initial f_isReset <= 0;
  wire heat_ref, agitate_ref, chute_ref;
  wire heat_uut, agitate_uut, chute_uut;
  wire [7:0] state_ref, state_uut;
  wire [2:0] pump_ref, pump_uut;

  brew_fsm_ref REF (
    .clk(clk),
    .reset(reset),
    .temp(temp),
    .level(level),
    .state(state_ref),
    .heat(heat_ref),
    .agitate(agitate_ref),
    .chute(chute_ref),
    .pump(pump_ref)
  );

  brew_fsm_ref UUT (
    .clk(clk),
    .reset(reset),
    .temp(temp),
    .level(level),
    .state(state_uut),
    .heat(heat_uut),
    .agitate(agitate_uut),
    .chute(chute_uut),
    .pump(pump_uut)
  );

`ifdef	FORMAL
  always @(posedge clk) begin
    if(reset)
        f_isReset <= 1;
  end

  always @(*) begin
    if(f_isReset) begin
        assert(state_ref == state_uut);
        assert(heat_ref == heat_uut);
        assert(agitate_ref == agitate_uut);
        assert(chute_ref == chute_uut);
        assert(pump_ref == pump_uut);
    end
  end
`endif
endmodule
