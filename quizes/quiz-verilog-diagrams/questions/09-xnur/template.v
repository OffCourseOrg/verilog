/*
 *  OffCourse::Verilog
 *		- Quiz Verilog Diagram Template Question xnur
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */


`timescale 1s/1ms

{{ANSWER}}

module bench();
  reg clk = 1;

  task pass(input unused);
    begin
      $display("PASS");
      $finish;
    end
  endtask

  task fail(input unused);
    begin
      #3
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
  wire y;
  
  reg hold_a_ref, hold_b_ref;
  always @(posedge clk) begin
    if (a & b) begin
      hold_a_ref <= 0;
      hold_b_ref <= 0;
    end else begin
      hold_a_ref <= a;
      hold_b_ref <= b;
    end
  end

  wire ref_y;
  assign ref_y = (hold_a_ref ~^ hold_b_ref);

  UUT UUT (
    .clk(clk),
    .a(a),
    .b(b),
    .y(y)
  );
  
  initial begin
    a = 1;
    b = 1;
    #1.5
    a = 1;
    b = 0;
    #0.1
    check(y == ref_y, 1);
    #1 check(y == ref_y, 2);
    a = 0;
    b = 1;
    #1 check(y == ref_y, 3);
    a = 1;
    b = 1;
    #1 check(y == ref_y, 4);
    pass(1);
  end
  
  
endmodule