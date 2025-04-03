/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Question gray
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module UUT (
  input clk,
  input reset,
  output [2:0] y
);
  
  reg [2:0] state;
  always @(posedge clk) begin
    if(reset)
      state <= 0;
    else
      state <= state + 1;
  end

  assign y = {state[2], state[2] ^ state[1], state[1] ^ state[0]};

endmodule