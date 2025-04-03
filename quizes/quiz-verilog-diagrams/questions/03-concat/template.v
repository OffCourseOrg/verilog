/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Template Question concat
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
  
  reg a, b;
  wire [1:0] y;
  
  UUT UUT (
    .a(a),
    .b(b),
    .y(y)
  );
  
  initial begin
    a = 0;
    b = 0;
    #1 check(y == 2'b00, 1);
    a = 1;
    b = 0;
    #1 check(y == 2'b10, 2);
    a = 0;
    b = 1;
    #1 check(y == 2'b01, 3);
    a = 1;
    b = 1;
    #1 check(y == 2'b11, 4);
    pass(1);
  end
  
  
endmodule