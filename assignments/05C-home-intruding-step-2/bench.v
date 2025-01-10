`timescale 1ns/1ps

module bench(
  output armed,
  output alarm
);
  wire [3:0] uut_input_digit, ref_input_digit;
  wire [1:0] uut_command, ref_command;
  wire uut_digit_entered, ref_digit_entered;
  reg enable, reset, clk;

  REF REF(
    .clk(clk),
    .enable(enable),
    .reset(reset),
		.command(ref_command),
		.digit(ref_input_digit),
		.digit_entered(ref_digit_entered)
  );

  UUT UUT(
    .clk(clk),
    .enable(enable),
    .reset(reset),
		.command(uut_command),
		.digit(uut_input_digit),
		.digit_entered(uut_digit_entered)
  );

  TARGET TARGET(
		.clk(clk),
		.reset(reset),

		.command(uut_command),
		.digit(uut_input_digit),
		.digit_enterd(uut_digit_entered),

		.armed(armed),
		.alarm(alarm)
  );

  always begin
    //Clock
    #0.5 clk = ~clk;

    //Pass Condition
    if (uut_command != ref_command ||
      uut_digit_entered != ref_digit_entered ||
      uut_input_digit != ref_input_digit ) begin
      $display("%d => %d", uut_command, ref_command);
      $display("%d => %d", uut_digit_entered, ref_digit_entered);
      $display("%d => %d", uut_input_digit, ref_input_digit);
      $display("FAIL");
      $finish;
    end

    if(armed == 0) begin
      //Reconstruct decimal and subtract one. Accounts for us lagging one clockcycle
      $display("Found pincode: %3d", REF.digit_0*100 + REF.digit_1*10 + REF.digit_2 - 1);
      $display("PASS");
      $finish;
    end
  end

  reg isDebug;
  initial begin
    clk = 1;
    enable = 1;
    reset = 1;

    //GTKwave
    $dumpfile("trace.vcd");
    $dumpvars(0,UUT);
    $dumpvars(1,REF);
    $dumpvars(2,TARGET);

    #1 reset = 0;

    #4001
    $display("Timeout");
    $display("FAIL");
    $finish;
  end
endmodule