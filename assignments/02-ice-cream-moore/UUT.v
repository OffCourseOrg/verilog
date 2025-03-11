/*
 *  OffCourse::Verilog
 *		- ice-cream-moore UUT
 *
 *  Copyright: Aleksandrs
 *  License: GPLv3 or later
 */

module UUT (
    input clk,
    input reset,
    input insert,
    input [1:0] coins,
    output reg [1:0] ice_cream_balls,
    output [2:0] state
);


  localparam COIN0 = 2'b00, COIN1 = 2'b01, COIN2 = 2'b10;
  //@STATES
  localparam C0B0 = 0,
           C1B0 = 1,
           C2B0 = 2,
           C3B0 = 3,
           C0B1 = 4,
           C1B1 = 5,
           C0B2 = 6,
           C1B2 = 7,
           C2B2 = 8;

  reg [3:0] state_r;
  reg [3:0] state_nxt;

  always @(posedge clk) begin
    if (reset) begin
      state_r <= 0;
    end else begin
      state_r <= state_nxt;
    end
  end

  assign state = state_r;

  always @(*) begin
    state_nxt = state_r;
    case (state_r)
      C0B0: begin
        case (coins)
          COIN1: begin
            state_nxt = C1B0;
          end
          COIN2: begin
            state_nxt = C2B0;
          end
        endcase
      end
      C1B0: begin
        case (coins)
          COIN1: begin
            state_nxt = C2B0;
          end
          COIN2: begin
            state_nxt = C3B0;
          end
        endcase
      end
      C2B0: begin
        case (coins)
          COIN1: begin
            state_nxt = C3B0;
          end
          COIN2: begin
            state_nxt = C1B1;
          end
          COIN0: begin
            state_nxt = C0B1;
          end
        endcase
      end
      C3B0: begin
        case (coins)
          COIN1: begin
            state_nxt = C1B2;
          end
          COIN2: begin
            state_nxt = C2B2;
          end
          COIN0: begin
            state_nxt = C0B2;
          end
        endcase
      end

      C0B1: begin
        case (coins)
          COIN1: begin
            state_nxt = C1B0;
          end
          COIN2: begin
            state_nxt = C2B0;
          end
        endcase
      end
      C1B1: begin
        case (coins)
          COIN1: begin
            state_nxt = C2B0;
          end
          COIN2: begin
            state_nxt = C3B0;
          end
        endcase
      end

      C0B2: begin
        case (coins)
          COIN1: begin
            state_nxt = C1B0;
          end
          COIN2: begin
            state_nxt = C2B0;
          end
        endcase
      end
      C1B2: begin
        case (coins)
          COIN1: begin
            state_nxt = C2B0;
          end
          COIN2: begin
            state_nxt = C3B0;
          end
        endcase
      end
      C2B2: begin
        case (coins)
          COIN1: begin
            state_nxt = C3B0;
          end
          COIN2: begin
            state_nxt = C1B1;
          end
        endcase
      end
    endcase
  end

  always @(*) begin
    ice_cream_balls = 0;
    case (state_r)
      C0B0: begin
        ice_cream_balls = 0;
      end
      C1B0: begin
        ice_cream_balls = 0;
      end
      C2B0: begin
        ice_cream_balls = 0;
      end
      C3B0: begin
        ice_cream_balls = 0;
      end

      C0B1: begin
        ice_cream_balls = 1;
      end
      C1B1: begin
        ice_cream_balls = 1;
      end

      C0B2: begin
        ice_cream_balls = 2;
      end
      C1B2: begin
        ice_cream_balls = 2;
      end
      C2B2: begin
        ice_cream_balls = 2;
      end
    endcase
    
  end



endmodule
