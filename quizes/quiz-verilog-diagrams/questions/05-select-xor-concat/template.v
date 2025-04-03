/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Template Question select-xor-concat
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
  
  reg [3:0] a = 0;
  wire [1:0] y;
  
  UUT UUT (
    .a(a),
    .y(y)
  );
  
  reg commenced = 0;
  always begin
    //Clock
    #0.5 clk = ~clk;

    if(a == 4'b0000 && commenced)
      pass(1);
    commenced = 1;

    check(y == {a[3] ^ a[2], a[1] ^ a[0]}, a + 1);
    a = a + 1;
    #1;
  end
  
  
endmodule