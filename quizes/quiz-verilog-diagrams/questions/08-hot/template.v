/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Template Question hot
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
  
  wire y;

  UUT UUT (
    .clk(clk),
    .reset(reset),
    .y(y)
  );
  
  always begin
    //Clock
    #0.5 clk = ~clk;
  end

  initial begin
    reset = 0;
    #1
    reset = 1;
    check(y == 0, 1);
    #1
    check(y == 0, 2);
    #1
    check(y == 1, 3);
    #1
    check(y == 0, 4);
    #1
    check(y == 0, 5);
    #1
    check(y == 0, 6);
    #3
    reset = 0;
    check(y == 0, 7);
    #1
    reset = 1;
    check(y == 0, 8);
    #2
    check(y == 1, 9);
    pass(1);
    
  end
  
  
endmodule