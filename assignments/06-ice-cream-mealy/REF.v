/*
 *  OffCourse::Verilog
 *		- ice-cream-mealy REF
 *
 *  Copyright: Aleksandrs
 *  License: GPLv3 or later
 */

module REF (
  input clk,
	input reset,
  input [1:0] coins,
  output [1:0] ice_cream_balls,
`ifndef GEN_FSM
  output [1:0] state_ref,
`endif
);


localparam C0 = 2'b00,
           C1 = 2'b01,
           C2 = 2'b10;

//@STATES
localparam CS0 = 0,
           CS1 = 1,
           CS2 = 2,
           CS3 = 3;

reg [1:0] state_r;
reg [1:0] state_nxt;
reg [1:0] ice_cream_balls_r;
reg [1:0] ice_cream_balls_nxt;

always @(posedge clk) begin
  if (reset) begin
    state_r <= 0;
    ice_cream_balls_r <= 0;
  end else begin
    state_r <= state_nxt;
    ice_cream_balls_r <= ice_cream_balls_nxt;
  end
end

always @(*) begin
  state_nxt = state_r;
  case (state_r)
    CS0: begin
      case (coins)
        C1: state_nxt = CS1;
        C2: state_nxt = CS2;
      endcase
    end
    CS1: begin
      case (coins)
        C1: state_nxt = CS2;
        C2: state_nxt = CS3;
      endcase
    end
    CS2: begin
      case (coins)
        C0: state_nxt = CS0;
        C1: state_nxt = CS3;
        C2: state_nxt = CS1;
      endcase
    end
    CS3: begin
      case (coins)
        C0: state_nxt = CS0;
        C1: state_nxt = CS1;
        C2: state_nxt = CS2;
      endcase
    end
  endcase
end

always @(*) begin
  ice_cream_balls_nxt = ice_cream_balls_r;
  case (state_r)
    CS0: begin
      ice_cream_balls_nxt = 0;
    end
    CS1: begin
      case(coins)
        C2: ice_cream_balls_nxt = 2;
      endcase
    end
    CS2: begin
      case (coins)
        C0: ice_cream_balls_nxt = 1;
        C2: ice_cream_balls_nxt = 2;
      endcase
    end
    CS3: begin
      if (coins != 3)
        ice_cream_balls_nxt = 0;
    end
  endcase
end

assign state_ref = state_r;
assign ice_cream_balls = ice_cream_balls_nxt;

`ifdef FORMAL
  reg f_isReset = 0;
  
  always @(posedge clk) begin
    if (reset) begin
      f_isReset <= 1;
    end
    if (f_isReset) begin

    end
  end
`endif


endmodule
