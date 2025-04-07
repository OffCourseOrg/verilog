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
  
  reg [1:0] a;
  reg b;
  wire [2:0] y;
  
  UUT UUT (
    .a(a),
    .b(b),
    .y(y)
  );
  
  initial begin
    a = 2'b00;
    b = 0;
    #1 check(y == 3'b000, 1);
    a = 2'b10;
    b = 1;
    #1 check(y == 3'b101, 2);
    a = 2'b00;
    b = 1;
    #1 check(y == 3'b001, 3);
    a = 2'b11;
    b = 1;
    #1 check(y == 3'b111, 4);
    a = 2'b11;
    b = 0;
    #1 check(y == 3'b110, 5);
    pass(1);
  end
  
  
endmodule