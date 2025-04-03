/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Question 3
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module UUT (
  input clk,
  input reset,
  output [2:0] y
);
  
  reg [2:0] gray_state;
  always @(posedge clk) begin
    if(reset)
      gray_state <= 0;
    else if (gray_state == 0)
      gray_state <= 3'b001;
    else
      gray_state <= 2 * gray_state;
  end

  assign y = gray_state;

endmodule