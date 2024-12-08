/*
 *  OffCourse::Verilog
 *		- ice-cream-moore REF
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
  output state_ref,
`endif
);


  localparam COIN0 = 2'b00,
             COIN1 = 2'b01,
             COIN2 = 2'b10;
  //@STATES
  localparam ZERO_COINS_NO_ICE_CREAM = 0,
             ONE_COIN_NO_ICE_CREAM = 1,
             TWO_COINS_ONE_BALL = 2,
             THREE_COINS_TWO_BALLS = 3;
             
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
    case (state)
      ZERO_COINS_NO_ICE_CREAM: begin
        case (coins)
          COIN1: state_next = ONE_COIN_NO_ICE_CREAM;
          COIN2: state_next = TWO_COINS_ONE_BALL;
          default: state_next = state;
        endcase
      end
      ONE_COIN_NO_ICE_CREAM: begin
        case (coins)
          COIN1: state_next = TWO_COINS_ONE_BALL;
          COIN2: state_next = THREE_COINS_TWO_BALLS;
          default: state_next = state;
        endcase
      end
      TWO_COINS_ONE_BALL: begin
        case (coins)
          COIN1: state_next = THREE_COINS_TWO_BALLS;
          default: state_next = ZERO_COINS_NO_ICE_CREAM;
        endcase
      end
      THREE_COINS_TWO_BALLS: state_next = ZERO_COINS_NO_ICE_CREAM;
    endcase
  end

  always @(*) begin
    if (state == TWO_COINS_ONE_BALL)
      ice_cream_balls = 1;
    else if (state == THREE_COINS_TWO_BALLS)
      ice_cream_balls = 2;
    else
      ice_cream_balls = 0;
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
      assert(state <= THREE_COINS_TWO_BALLS);
      assert(state_next <= THREE_COINS_TWO_BALLS);

      if(state == TWO_COINS_ONE_BALL)
        assert(ice_cream_balls == 1);
      else if (state == THREE_COINS_TWO_BALLS)
        assert(ice_cream_balls == 2);
      else
        assert(ice_cream_balls == 0);
    end
  end
`endif


endmodule
