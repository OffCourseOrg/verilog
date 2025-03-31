/*
 *  OffCourse::Verilog
 *		- Home Intruding Step 2 UUT Solution
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	UUT (
    input clk,
    input enable,
    input reset,
    output [1:0] command,
    output reg [3:0] digit,
    output digit_entered
	);
	wire en_digit_1, en_digit_2;
	wire [3:0] digit_0, digit_1, digit_2;
	wire [3:0] active_digit;
  wire active_digit_overflow;

  counter counter_2(
    .clk(clk),
    .enable(active_digit_overflow),
    .reset(reset),

    .count(digit_2),
    .rollover(en_digit_1)
  );

	counter counter_1(
    .clk(clk),
    .enable(en_digit_1),
    .reset(reset),

    .count(digit_1),
    .rollover(en_digit_2)
  );

	counter counter_0(
    .clk(clk),
    .enable(en_digit_2),
    .reset(reset),

    .count(digit_0)
  );

	counter counter_active(
    .clk(clk),
    .enable(enable),
    .reset(active_digit_overflow || reset),

    .count(active_digit)
  );

	always @(*) begin
		digit = digit_0;
		if(active_digit == 2)
			digit = digit_1;
		if(active_digit == 3)
			digit = digit_2;
	end

	assign active_digit_overflow = active_digit == 3;
	assign command = 2'b10; //DISARM command
	assign digit_entered = 1; //Just needs to be set

endmodule
