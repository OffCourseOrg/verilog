/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Template Question gray
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */


`timescale 1s/1ms

{{ANSWER}}

module bench();
  reg clk = 0;
  reg reset = 0;

  task pass(input unused);
    begin
      $display("PASS");
      $finish;
    end
  endtask

  task fail(input unused);
    begin
      $display("FAIL");
      $finish;
    end
  endtask

  task check(input ok, input [7:0] step);
    begin
      if(ok) begin
        $display("step %d", step);
      end else begin
        fail(0);
      end
    end
  endtask

  always begin
    //Clock
    #0.5 clk = ~clk;
  end
  
  wire [2:0] y;
  
  UUT UUT (
    .clk(clk),
    .reset(reset),
    .y(y)
  );
  
  initial begin
    reset = 1;
    #1
    reset = 0;
    check(y == 3'b000, 1);
    #1
    check(y == 3'b001, 2);
    #1
    check(y == 3'b011, 3);
    #1
    check(y == 3'b010, 4);
    #1
    check(y == 3'b110, 5);
    #1
    check(y == 3'b111, 6);
    #1
    check(y == 3'b101, 7);
    #1
    check(y == 3'b100, 8);
    #1
    check(y == 3'b000, 9);
    #3
    reset = 1;
    #1
    check(y == 3'b000, 10);
    pass(1);
  end
  
  
endmodule