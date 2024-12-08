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
		DISARMED = 0,
		ARM = 1,
		ARM_1 =2,
		ARM_2 = 3,
		ARMED = 4,
		DISARM = 5,
		DISARM_1= 6,
		DISARM_2 = 7,
		ALARM = 8,
		ARM_1_BAD =9,
		ARM_2_BAD = 10,
		DISARM_1_BAD = 11,
		DISARM_2_BAD  = 12,
		_MAX_STATE = 12;

	reg [3:0] state;
	reg [3:0] state_next;
	reg active_digit;

	//Labels FSM Logic

	always @(posedge clk) begin
		if(reset) begin
			state <= DISARMED;
			armed <= 0;
			alarm <= 0;
		end else begin
			state <= state_next;
			case (state)
				ARMED: begin
					armed <= 1;
				end
				DISARMED: begin
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
			DISARM: begin
				if(digit_enterd)
					state_next = digit == D_0 ? DISARM_1 : DISARM_1_BAD;
				if(trigger && !alarm)
					state_next = ALARM;
			end
			DISARM_1: begin
				if(digit_enterd)
					state_next = digit == D_1 ? DISARM_2 : DISARM_2_BAD;
				if(trigger && !alarm)
					state_next = ALARM;
			end
			DISARM_2: begin
				if(digit_enterd)
					state_next = digit == D_2 ? ARMED : DISARMED;
				if(trigger && !alarm)
					state_next = ALARM;
			end
			DISARM_1_BAD: begin
				if(digit_enterd)
					state_next = DISARM_2_BAD;
			end
			DISARM_2_BAD: begin
				if(digit_enterd)
					state_next = ARMED;
			end
			DISARMED: begin
				if(command == COM_ARM)
					state_next = ARM; 
			end

			//Arming flow
			ARM: begin
				if(digit_enterd)
					state_next = digit == D_0 ? ARM_1 : ARM_1_BAD;
			end
			ARM_1: begin
				if(digit_enterd)
					state_next = digit == D_1 ? ARM_2 : ARM_2_BAD;
			end
			ARM_2: begin
				if(digit_enterd)
					state_next = digit == D_2 ? DISARMED : ARMED;
			end
			ARM_1_BAD: begin
				if(digit_enterd)
					state_next = ARM_2_BAD;
			end
			ARM_2_BAD: begin
				if(digit_enterd)
					state_next = DISARMED;
			end
			ARMED: begin
				if(command == COM_DIS)
					state_next = DISARM; 
				if(trigger && !alarm)
					state_next = ALARM;
			end
			ALARM: begin
				if(command == COM_DIS)
					state_next = DISARM;
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
		if(reset)
			f_is_reset <= 1;

		if(f_is_reset) begin
			assert(state <= MAX_STATE);
			assert(state >= MIN_STATE);
		end

		//Completed FSM
		if(f_is_reset)
			cover(state == ARMED);
		if(f_is_reset && f_was_armed && state == DISARMED)
			cover($past(state) == DISARM_3);

		//Can arm
		if(f_is_reset && state == ARMED) begin
			f_was_armed <= 1;
			assert(armed == 1);
		end
		//Can disarm
		if(f_is_reset && state == DISARMED)
			assert(armed == 0);
		//Can maintenace
		if(f_is_reset && !$past(reset) && $past(command) == COM_MAINT)
			assert(state == MAINTENACE && alarm == 0);

		//Alarm ouput
		if(f_is_reset && trigger)
			assert(alarm == armed);
	end

	always @(*) begin
		case (state)
			ARM, DISARM: 
				assume(digit == 4);
			ARM_1, DISARM_1: 
				assume(digit == 2);
			ARM_2, DISARM_2: 
				assume(digit == 0);
		endcase

		if(f_is_reset) begin
			
		end
	end
`endif

endmodule