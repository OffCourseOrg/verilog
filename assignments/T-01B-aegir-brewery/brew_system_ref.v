/*
 *  OffCourse::Verilog
 *		- Aegir's Brewery brew_system_ref
 *
 *  Copyright: Sybe Feitsma && e.t.s.v Thor
 *  License: GPLv3 or later
 */

module brew_system_ref (
		input clock,
		input nreset,

		input valid,
		input [7:0] level_sensor,
		input [7:0] temperature,

		output heater,
		output motor,
		output [1:0] pump, // IN/OUT, TOGGLE
		output sparge_valve,
		output grain_feed,
		output valve,
		output [7:0] level
	);

	reg [7:0] level_r;
	always @(posedge clock) begin
		if(~nreset || valid) begin
			level_r <= level_sensor;
		end
	end

	wire [2:0] fsm_pump;
	brew_fsm FSM (
		.clk(clock),
		.reset(~nreset),
		.temp(temperature),
		.level(level_r),
		.heat(heater),
		.agitate(motor),
		.chute(grain_feed),
		.pump(fsm_pump)
	);

	assign valve = fsm_pump[0];
	assign sparge_valve = (fsm_pump[2:1] == 2'b11);
	assign pump = {fsm_pump[2], fsm_pump[0] | fsm_pump[1]};
	assign level = level_r;


endmodule