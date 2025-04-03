/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Template Question pattern
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
  
  reg [4:0] pattern;
  reg in;
  wire detected;

  UUT UUT (
    .clk(clk),
    .pattern(pattern),
    .in(in),
    .detected(detected)
  );
  
  initial begin
    pattern = 5'b11001;
    in = 0;
    #10
    #1 in = 1;
    check(~detected, 1);
    #1 in = 1;
    #1 in = 0;
    check(~detected, 2);
    #1 in = 0;
    #1 in = 1;
    #1
    check(detected, 3);
    pass(1);

  end
  
  
endmodule