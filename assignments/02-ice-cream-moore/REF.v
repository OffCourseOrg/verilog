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
  output reg coffee,
  output reg [2:0] state
);


  localparam COIN0 = 2'b00,
             COIN1 = 2'b01,
             COIN2 = 2'b10;
  
  reg insert_prev;
  reg [2:0] state_next;

  always @(posedge clk) begin
    if(reset) begin
      insert_prev <= 0;
      coffee <= 0;
      state <= 0;
    end
    else if (insert && !insert_prev) begin
      insert_prev <= insert;
      state <= state_next;
      
      case (state)
        3: coffee <= 1;
        4: coffee <= 1;
        default: coffee <= 0;
      endcase
    end
    else begin
      insert_prev <= insert;
      state <= state_next;
    end
  end

  always @(*) begin
    case(state)
      1: begin
        case (coins)
          COIN1: state_next = 2;
          COIN2: state_next = 3;
          default: state_next = state;
        endcase
    end
    2: begin
        case (coins)
          COIN1: state_next = 3;
          COIN2: state_next = 4;
          default: state_next = state;
        endcase
    end
    3: begin
        case (coins)
          COIN1: state_next = 1;
          COIN2: state_next = 2;
          default: state_next = 0;
        endcase
    end
    4: begin
        case (coins)
          COIN1: state_next = 2;
          COIN2: state_next = 3;
          default: state_next = 1;
        endcase
    end
    default: begin
        case (coins)
          COIN1: state_next = 1;
          COIN2: state_next = 2;
          default: state_next = 0;
        endcase
      end
    endcase
  end

`ifdef FORMAL
  reg f_isReset = 0;
  reg [7:0] tracer;
  initial tracer = 0;
  always @(posedge clk) begin
    if (reset) begin
      f_isReset <= 1;
    end
    if (!reset && f_isReset) begin
      tracer <= tracer + 1;
      assert(tracer < 99);
    end
    if (f_isReset) begin
      assert(state >= 0);
      assert(state_next >= 0);
      if (state == 3 || state == 4) begin
        assert(coffee);
      end else begin
        assert(!coffee);
      end
    end
  end
`endif


endmodule
