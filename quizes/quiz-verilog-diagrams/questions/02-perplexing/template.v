/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Template Question perplexing
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
  
  reg a, b, s;
  wire y;
  
  UUT UUT (
    .s(s),
    .a(a),
    .b(b),
    .y(y)
  );
  
  initial begin
    a = 0;
    b = 0;
    s = 0;
    #1 check(y == 1, 1);
    a = 1;
    b = 0;
    s = 0;
    #1 check(y == 0, 2);
    a = 0;
    b = 1;
    s = 0;
    #1 check(y == 0, 3);
    a = 0;
    b = 0;
    s = 1;
    #1 check(y == 1, 4);
    a = 1;
    b = 1;
    s = 0;
    #1 check(y == 1, 5);
    a = 0;
    b = 1;
    s = 1;
    #1 check(y == 0, 6);
    a = 1;
    b = 0;
    s = 1;
    #1 check(y == 0, 7);
    a = 1;
    b = 1;
    s = 1;
    #1 check(y == 1, 8);
    pass(1);
  end
  
  
endmodule