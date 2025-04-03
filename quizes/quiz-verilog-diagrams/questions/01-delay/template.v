/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Template Question delay
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
  
  reg [7:0] a;
  wire [7:0] y;
  
  UUT UUT (
    .clk(clk),
    .reset(reset),
    .a(a),
    .y(y)
  );
  
  initial begin
    a = 0;
    reset = 1;
    #1
    reset = 0;
    #1 
    check(y == 0, 1);
    a = 250;
    #1
    a = 190;
    check(y == 0, 2);
    #1
    a = 170;
    check(y == 250, 3);
    #1
    reset = 1;
    check(y == 190, 4);
    #1
    check(y == 0, 5);
    pass(1);
  end
  
  
endmodule