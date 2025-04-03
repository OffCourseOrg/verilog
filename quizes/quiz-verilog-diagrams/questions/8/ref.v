/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Question 8
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	UUT (
  input clk,
  input a,
  input b,
  output y
);
  reg hold_a, hold_b;

  always @(posedge clk) begin
    if (a & b) begin
      hold_a <= 0;
      hold_b <= 0;
    end else begin
      hold_a <= a;
      hold_b <= b;
    end
  end

  assign y = ~(hold_a ^ hold_b);
endmodule