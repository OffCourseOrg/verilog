/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Template Question shift
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */


`timescale 1s/1ms

{{ANSWER}}

module bench();
  reg clk = 0;

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
  
  reg in, enable;
  wire out;
  
  UUT UUT (
    .clk(clk),
    .enable(enable),
    .in(in),
    .out(out)
  );
  
  initial begin
    enable = 1;
    in = 0;
    #10
    in = 1;
    check(out == 0, 1);
    #7
    check(out == 0, 2);
    enable = 0;
    #1
    check(out == 0, 3);
    enable = 1;
    #1
    check(out == 1, 3);
    pass(1);
  end
  
  
endmodule