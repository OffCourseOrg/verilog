/*
 *  OffCourse::Verilog
 *		- IIC PLACEHOLDER REF
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	REF (
		input clk,
		input reset,

		input SCL,
		input SDA_in,
		output reg write_SDA,
		output reg SDA_out,

	`ifndef GEN_FSM
		output [3:0] state_ref,
	`endif
	);

	//@STATES
	localparam _MIN_STATE=0,
		IDLE = 0,
		START = 1,
		ADDR1 = 2,
		ADDR2 = 3,
		ADDR3 = 4,
		ADDR4 = 5,
		ADDR5 = 6,
		ADDR6 = 7,
		ADDR7 = 8,
		ACK = 9,
		_MAX_STATE = 0;


	reg [3:0] state;
	reg [3:0] state_next;

	`ifndef GEN_FSM
		assign state_ref = state;
	`endif

	//Labels FSM Logic
	always @(posedge clk) begin
		if(reset) begin
			state <= DISARMED;
		end else begin
			state <= state_next;
		end
	end

	always @(*) begin
		state_next = state; //default
		case(state)

		endcase
	end

`ifdef FORMAL
	reg f_is_reset;

	initial begin
		f_is_reset = 0;
	end

	always @(posedge clk) begin
		//track if rest into valid state
		if(reset) begin
			f_is_reset <= 1;

		end

		if(f_is_reset) begin
			assert(state <= _MAX_STATE);
			assert(state >= _MIN_STATE);
		end

		if(!reset) begin
			//Completed FSM
		end
	end

	always @(*) begin
		if(f_is_reset) begin
			
		end
	end
`endif

endmodule