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
		D_2 = 4'd0;

	localparam COM_NONE = 0,
		COM_ARM = 1,
		COM_DIS = 2;

	//@STATES
	localparam _MIN_STATE=0,
		DISARMED = 0,
		ARM = 1,
		ARM_1 =2,
		ARM_2 = 3,
		ARM_3 = 4,
		ARMED = 5,
		DISARM = 6,
		DISARM_1= 7,
		DISARM_2 = 8,
		DISARM_3 = 9,
		ALARM = 10,
		_MAX_STATE = 10;

	reg [3:0] state;
	reg [3:0] state_next;
	reg [3:0] digits [3];
	reg active_digit;

	//Labels FSM Logic
	wire pincode_correct = (digits[0] == D_0 && digits[1] == D_1 && digits[2] == D_2);
	wire cmd_disarm = command == COM_DIS;
	wire cmd_arm = command == COM_ARM;

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

			if(digit_enterd)
				digits[active_digit] <= digit;
		end
	end

	always @(*) begin
		state_next = state; //default
		case(state)
			//Disarm flow
			DISARM: begin
				alarm = 0;
				if(digit_enterd)
					state_next = DISARM_1;
				if(trigger && !alarm)
					state_next = ALARM;
			end
			DISARM_1: begin
				if(digit_enterd)
					state_next = DISARM_2;
				if(trigger && !alarm)
					state_next = ALARM;
			end
			DISARM_2: begin
				if(digit_enterd)
					state_next = DISARM_3;
				if(trigger && !alarm)
					state_next = ALARM;
			end
			DISARM_3: begin
				if(pincode_correct)
					state_next = DISARMED;
				else
					state_next = ARMED;
				if(trigger && !alarm)
					state_next = ALARM;
			end
			DISARMED: begin
				if(cmd_arm)
					state_next = ARM; 
			end

			//Arming flow
			ARM: begin
				if(digit_enterd)
					state_next = ARM_1;
			end
			ARM_1: begin
				if(digit_enterd)
					state_next = ARM_2;
			end
			ARM_2: begin
				if(digit_enterd)
					state_next = ARM_3;
			end
			ARM_3: begin
				if(pincode_correct)
					state_next = ARMED;
				else
					state_next = DISARMED;
			end
			ARMED: begin
				if(cmd_disarm)
					state_next = DISARM; 
				if(trigger && !alarm)
					state_next = ALARM;
			end
			ALARM: begin
				alarm = 1;
				if(cmd_disarm)
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