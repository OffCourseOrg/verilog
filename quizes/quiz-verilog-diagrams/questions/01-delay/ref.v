/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Question delay
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	UUT (
    input clk,
    input reset,
    input [7:0] a,
    output reg [7:0] y
  );

  reg [7:0] state;

  always @(posedge clk) begin
    if(reset) begin
      state <= 0;
      y <= 0;
    end else begin
      y <= state;
      state <= a;
    end
  end

endmodule