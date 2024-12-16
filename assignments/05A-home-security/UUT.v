/*
 *  OffCourse::Verilog
 *		- Home Security UUT
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module UUT (
		input clk,
		input reset,

		input trigger,
		input [1:0] command,
		input [3:0] digit,
		input digit_enterd,

		output [3:0] state,
		output reg armed,
		output reg alarm
	);


endmodule