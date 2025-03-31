/*
 *  OffCourse::Verilog
 *		- Home Security UUT Solution
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	UUT (
		input clk,
		input reset,
		input trigger,
		input [1:0] command,
		input [3:0] digit,
		input input_digit,
		output reg armed,
		output reg alarm
	);
	localparam D_2 = 4'd4,
		D_1 = 4'd2,
		D_0 = 4'd1;

	localparam COM_NONE = 0,
		COM_ARM = 1,
		COM_DIS = 2;

	//@STATES
	localparam _MIN_STATE=0,
		DISARMED = 0,
		ARM0 = 1,
		ARM1 = 2,
		ARM2 = 3,
		ARMED = 4,
		DISARM0 = 5,
		DISARM1= 6,
		DISARM2 = 7,
		ALARM = 8,
		ARM1B = 9,
		ARM2B = 10,
		DISARM1B = 11,
		DISARM2B  = 12,
		_MAX_STATE = 12;


	reg [3:0] state, state_next;
	reg active_digit;

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
		alarm = alarm;
		armed = armed;
		case(state)
			//Disarm flow
			DISARM0: begin
				if(input_digit == 1)
					state_next = digit == D_0 ? DISARM1 : DISARM1B;
			end
			DISARM1: begin
				if(input_digit == 1)
					state_next = digit == D_1 ? DISARM2 : DISARM2B;
			end
			DISARM2: begin
				if(input_digit == 1)
					state_next = digit == D_2 ? DISARMED : ARMED;
			end
			DISARM1B: begin
				if(input_digit == 1)
					state_next = DISARM2B;
			end
			DISARM2B: begin
				if(input_digit == 1)
					state_next = ARMED;
			end
			DISARMED: begin
				alarm = 0;
				armed = 0;
				if(command == COM_ARM)
					state_next = ARM0; 
			end

			//Arming flow
			ARM0: begin
				if(input_digit == 1)
					state_next = digit == D_0 ? ARM1 : ARM1B;
			end
			ARM1: begin
				if(input_digit == 1)
					state_next = digit == D_1 ? ARM2 : ARM2B;
			end
			ARM2: begin
				if(input_digit == 1)
					state_next = digit == D_2 ? ARMED : DISARMED;
			end
			ARM1B: begin
				if(input_digit == 1)
					state_next = ARM2B;
			end
			ARM2B: begin
				if(input_digit == 1)
					state_next = DISARMED;
			end
			ARMED: begin
				armed = 1;
				if(command == COM_DIS)
					state_next = DISARM0; 
				if(trigger)
					state_next = ALARM;
			end
			ALARM: begin
				alarm = 1;
				if(command == COM_DIS)
					state_next = DISARM0;
			end
		endcase
	end

endmodule