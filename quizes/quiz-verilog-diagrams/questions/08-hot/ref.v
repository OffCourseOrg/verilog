/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Question hot
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	UUT (
  input clk,
  input reset,
  output y
);
  reg [5:0] hot_r;
  wire [5:0] hot_nxt;

  always @(posedge clk) begin
    hot_r <= ~(reset) ? 5'b10000 : hot_nxt;
  end

  assign hot_nxt = hot_r == 5'b00001 ? 5'b10000 : {1'b0, hot_r[5:1]};
  assign y = hot_r[2];
endmodule