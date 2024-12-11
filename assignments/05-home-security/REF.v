/*
 *  OffCourse::Verilog
 *		- Home Security REF
 *
 *  Written by: Sybe
 *  License: MIT
 */

module	REF (
		input clk,
		input reset,

		input trigger,
		input [1:0] command,
		input [3:0] digit,
		input digit_enterd,

	`ifndef GEN_FSM
		output [3:0]state_ref,
	`endif
		output reg armed,
		output reg alarm
	);
	localparam D_0 = 4'd4,
		D_1 = 4'd2,
		D_2 = 4'd1;

	localparam COM_NONE = 0,
		COM_ARM = 1,
		COM_DIS = 2;

	//@STATES
	localparam _MIN_STATE=0,
		DISARM = 0,
		ARM0 = 1,
		ARM1 =2,
		ARM2 = 3,
		ARMED = 4,
		DISARM0 = 5,
		DISARM1= 6,
		DISARM2 = 7,
		ALARM = 8,
		ALARMING = 9,
		ARM1B =10,
		ARM2B = 11,
		DISARM1B = 12,
		DISARM2B  = 13,
		ARM = 14,
		DISARMED = 15,
		_MAX_STATE = 15;


	reg [3:0] state;
	reg [3:0] state_next;
	reg active_digit;

	`ifndef GEN_FSM
		assign state_ref = state;
	`endif

	//Labels FSM Logic

	always @(posedge clk) begin
		if(reset) begin
			state <= DISARM;
			armed <= 0;
			alarm <= 0;
		end else begin
			state <= state_next;
			case (state)
				ARM: begin
					armed <= 1;
				end
				DISARM: begin
					armed <= 0;
					alarm <= 0;
				end
				ALARM: begin
					alarm <= 1;
				end
			endcase
		end
	end

	always @(*) begin
		state_next = state; //default
		case(state)
			//Disarm flow
			DISARM0: begin
				if(digit_enterd)
					state_next = digit == D_0 ? DISARM1 : DISARM1B;
			end
			DISARM1: begin
				if(digit_enterd)
					state_next = digit == D_1 ? DISARM2 : DISARM2B;
			end
			DISARM2: begin
				if(digit_enterd)
					state_next = digit == D_2 ? DISARM : ARMED;
			end
			DISARM1B: begin
				if(digit_enterd)
					state_next = DISARM2B;
			end
			DISARM2B: begin
				if(digit_enterd)
					state_next = ARMED;
			end
			DISARM: begin
				state_next = DISARMED;
			end
			DISARMED: begin
				if(command == COM_ARM)
					state_next = ARM0; 
			end

			//Arming flow
			ARM0: begin
				if(digit_enterd)
					state_next = digit == D_0 ? ARM1 : ARM1B;
			end
			ARM1: begin
				if(digit_enterd)
					state_next = digit == D_1 ? ARM2 : ARM2B;
			end
			ARM2: begin
				if(digit_enterd)
					state_next = digit == D_2 ? ARM : DISARMED;
			end
			ARM1B: begin
				if(digit_enterd)
					state_next = ARM2B;
			end
			ARM2B: begin
				if(digit_enterd)
					state_next = DISARMED;
			end
			ARM: begin
				state_next = ARMED;
			end
			ARMED: begin
				if(command == COM_DIS)
					state_next = DISARM0; 
				if(trigger)
					state_next = ALARM;
			end
			ALARM: begin
				state_next = ALARMING;
			end
			ALARMING: begin
				if(command == COM_DIS)
					state_next = DISARM0;
			end
		endcase
	end

`ifdef FORMAL
	reg f_is_reset;
	reg f_was_armed;

	initial begin
		f_is_reset = 0;
		f_was_armed = 0;
	end

	always @(posedge clk) begin
		//track if rest into valid state
		if(reset) begin
			f_is_reset <= 1;
			f_was_armed <= 0;
		end

		if(f_is_reset) begin
			assert(state <= _MAX_STATE);
			assert(state >= _MIN_STATE);
		end

		if(!reset) begin
			//Completed FSM
			if(f_is_reset && f_was_armed && state == DISARMED) begin
				cover($past(state) == DISARM);
				assert($past(state) == DISARMED || $past(state) == DISARM || $past(state) == ARM2 || $past(state) == ARM2B);
			end

			//Can arm
			if(f_is_reset && state == ARMED) begin
				f_was_armed = 1;
				assert(armed);
			end

			//Can disarm
			if(f_is_reset && state == DISARMED) begin
				assert(!armed && !alarm);
			end

			//Alarm ouput
			if(f_is_reset && trigger && state == ARMED) begin
				assert(state_next == ALARM);
			end
		end
	end

	always @(*) begin
		if(f_is_reset) begin
			
		end
	end
`endif

endmodule