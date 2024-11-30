/*
 *  OffCourse::Verilog
 *		- ice-cream-moore bmc
 *
 *  Written by: Aleksandrs
 *  License: MIT
 */

module	bmc(
  input wire clk,
  input wire reset,
  input wire [1:0] coins,
);

  reg f_isReset;
  initial f_isReset <= 0;

  reg coffee_ref, coffee_dut;
    
  reg [2:0] state_ref; 
  reg [2:0] state_dut;


  REF REF (
    .clk(clk),
    .reset(reset),
    .coins(coins),
    .coffee(coffee_ref),
    .state(state_ref),
  );

  DUT DUT(
    .clk(clk),
    .reset(reset),
    .coins(coins),
    .coffee(coffee_dut),
    .state(state_dut),
  );

`ifdef	FORMAL
  always @(posedge clk) begin
    if(reset)
      f_isReset <= 1;
    if(f_isReset) begin
      assert(coffee_ref == coffee_dut);
      assert(state_ref == state_dut);
    end
  end
`endif
endmodule
