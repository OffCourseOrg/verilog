/*
 *  OffCourse::Verilog
 *		- ice-cream-mealy UUT
 *
 *  Copyright: Aleksandrs
 *  License: GPLv3 or later
 */
 module UUT (
  input clk,
  input reset,
  input insert,
  input wire [1:0] coins,
  output reg [1:0] ice_cream_balls,
  output reg [2:0] state
);


  localparam COIN0 = 2'b00,
             COIN1 = 2'b01,
             COIN2 = 2'b10;
  //@STATES
  localparam ZERO_COINS_NO_ICE_CREAM = 0,
             ONE_COIN_NO_ICE_CREAM = 1,
             TWO_COINS_ONE_BALL = 2;
             
  reg insert_prev;
  reg [2:0] state_next;


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
endmodule