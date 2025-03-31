/*
 *  OffCourse::Verilog
 *		- ice-cream-moore UUT Solution
 *
 *  Copyright: Aleksandrs
 *  License: GPLv3 or later
 */

module UUT (
    input clk,
    input reset,
    input [1:0] coins,
    output [1:0] ice_cream_balls,
    output [3:0] state,
);


  localparam C0 = 2'b00, C1 = 2'b01, C2 = 2'b10;

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
  reg [1:0] ice_cream_balls_nxt;
  reg [1:0] ice_cream_balls_r;

  assign state = state_r;


  always @(posedge clk) begin
    if (reset) begin
      state_r <= 0;
      ice_cream_balls_r <= 0;
    end else begin
      state_r <= state_nxt;
      ice_cream_balls_r <= ice_cream_balls_nxt;
    end
  end

  assign ice_cream_balls = ice_cream_balls_nxt;

  always @(*) begin
    state_nxt = state_r;
    ice_cream_balls_nxt = ice_cream_balls_r;
    case (state_r)
      C0B0: begin
        ice_cream_balls_nxt = 0;
        case (coins)
          C1: begin
            state_nxt = C1B0;
          end
          C2: begin
            state_nxt = C2B0;
          end
        endcase
      end
      C1B0: begin
        ice_cream_balls_nxt = 0;
        case (coins)
          C1: begin
            state_nxt = C2B0;
          end
          C2: begin
            state_nxt = C3B0;
          end
        endcase
      end
      C2B0: begin
        ice_cream_balls_nxt = 0;
        case (coins)
          C1: begin
            state_nxt = C3B0;
          end
          C2: begin
            state_nxt = C1B1;
          end
          C0: begin
            state_nxt = C0B1;
          end
        endcase
      end
      C3B0: begin
        ice_cream_balls_nxt = 0;
        case (coins)
          C1: begin
            state_nxt = C1B2;
          end
          C2: begin
            state_nxt = C2B2;
          end
          C0: begin
            state_nxt = C0B2;
          end
        endcase
      end

      C0B1: begin
        ice_cream_balls_nxt = 1;
        case (coins)
          C1: begin
            state_nxt = C1B0;
          end
          C2: begin
            state_nxt = C2B0;
          end
        endcase
      end
      C1B1: begin
        ice_cream_balls_nxt = 1;
        case (coins)
          C1: begin
            state_nxt = C2B0;
          end
          C2: begin
            state_nxt = C3B0;
          end
        endcase
      end

      C0B2: begin
        ice_cream_balls_nxt = 2;
        case (coins)
          C1: begin
            state_nxt = C1B0;
          end
          C2: begin
            state_nxt = C2B0;
          end
        endcase
      end
      C1B2: begin
        ice_cream_balls_nxt = 2;
        case (coins)
          C1: begin
            state_nxt = C2B0;
          end
          C2: begin
            state_nxt = C3B0;
          end
        endcase
      end
      C2B2: begin
        ice_cream_balls_nxt = 2;
        case (coins)
          C1: begin
            state_nxt = C3B0;
          end
          C2: begin
            state_nxt = C1B1;
          end
        endcase
      end
    endcase
  end

endmodule
