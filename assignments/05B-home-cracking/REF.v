/*
 *  OffCourse::Verilog
 *		- Home Cracking REF
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	REF (
		
	);

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
				cover(state_next == ALARM);
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