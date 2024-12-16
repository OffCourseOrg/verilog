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

  wire [1:0] ice_cream_balls_ref;
  wire [1:0] ice_cream_balls_uut;
    
  wire [2:0] state_ref; 
  wire [2:0] state_uut;


  REF REF (
    .clk(clk),
    .reset(reset),
    .coins(coins),
    .ice_cream_balls(ice_cream_balls_ref),
    .state_ref(state_ref),
  );

  UUT UUT(
    .clk(clk),
    .reset(reset),
    .coins(coins),
    .ice_cream_balls(ice_cream_balls_uut),
    .state(state_uut),
  );

`ifdef	FORMAL
  reg f_isReset;
  initial f_isReset <= 0;
  always @(posedge clk) begin
    if(reset)
      f_isReset <= 1;
    if(f_isReset) begin
      assert(ice_cream_balls_uut == ice_cream_balls_ref);
      assert(state_ref == state_uut);
    end
  end
`endif
endmodule
