/*
 *  OffCourse::Verilog
 *		- ice-cream-mealy REF
 *
 *  Written by: Aleksandrs
 *  License: MIT
 */

module REF (
  input clk,
	input reset,
  input insert,
  input wire [1:0] coins,
  output reg [1:0] ice_cream_balls,
`ifndef GEN_FSM
  output wire [2:0] state_ref,
`endif
);


  localparam COIN0 = 2'b00,
             COIN1 = 2'b01,
             COIN2 = 2'b10;
  //@STATES
  localparam ZERO_COINS_NO_ICE_CREAM = 0,
             ONE_COIN_NO_ICE_CREAM = 1,
             TWO_COINS_ONE_BALL = 2;
             
  reg [2:0] state;
  reg insert_prev;
  reg [2:0] state_next;
`ifndef GEN_FSM
  assign state_ref = state;
`endif

  always @(posedge clk) begin
    if (reset) begin
      state <= ZERO_COINS_NO_ICE_CREAM;
    end else begin
      state <= state_next;
    end
  end


  always @(*) begin
    state_next = 0;
    ice_cream_balls = 0;
    case (state)
      ZERO_COINS_NO_ICE_CREAM: begin
        case (coins)
          COIN1: state_next <= ONE_COIN_NO_ICE_CREAM;
          COIN2: begin 
            state_next <= TWO_COINS_ONE_BALL;
            ice_cream_balls <= 1;
          end
          default: state_next <= state;
        endcase
      end
      ONE_COIN_NO_ICE_CREAM: begin
        case (coins)
          COIN1: begin
            state_next <= TWO_COINS_ONE_BALL;
            ice_cream_balls <= 1;
          end
          COIN2: begin 
            state_next <= ZERO_COINS_NO_ICE_CREAM;
            ice_cream_balls <= 2;
          end
          default: state_next <= state;
        endcase
      end
      TWO_COINS_ONE_BALL: begin
        case(coins)
          COIN1: begin
            state_next <= ZERO_COINS_NO_ICE_CREAM;
            ice_cream_balls <= 2;
          end
          default: begin
            state_next <= ZERO_COINS_NO_ICE_CREAM;
            ice_cream_balls <= 1;
          end
        endcase
      end
    endcase
  end
`ifdef FORMAL
  reg f_isReset = 0;
  
  always @(posedge clk) begin
    if (reset) begin
      f_isReset <= 1;
    end
    if (f_isReset) begin
      assert(state >= ZERO_COINS_NO_ICE_CREAM);
      assert(state_next >= ZERO_COINS_NO_ICE_CREAM);
      assert(state <= TWO_COINS_ONE_BALL);
      assert(state_next <= TWO_COINS_ONE_BALL);
      
      if((state == ONE_COIN_NO_ICE_CREAM && coins == COIN1) || (state == ZERO_COINS_NO_ICE_CREAM && coins == 2) || (state == TWO_COINS_ONE_BALL && coins != 1))
        assert(ice_cream_balls == 1);
      else if ((state == ONE_COIN_NO_ICE_CREAM && coins == 2) || (state == TWO_COINS_ONE_BALL && coins == 1))
        assert(ice_cream_balls == 2);
      else
        assert(ice_cream_balls == 0);
    end
  end
`endif


endmodule
