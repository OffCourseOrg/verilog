/*
 *  OffCourse::Verilog
 *		- Aegir's Brewery brew_fsm_ref
 *
 *  Copyright: Sybe Feitsma && e.t.s.v Thor
 *  License: GPLv3 or later
 */

module brew_fsm (
		//FSM
		input clk,
		input reset,
		//INPUTS
		input [7:0] temp,
		input [7:0] level,

		`ifndef GEN_FSM
			output [7:0] state,
		`endif

		//OUTPUTs
		output heat,
		output agitate,
		output chute, //GRAIN, YEAST
		output [2:0] pump // IN, OUT, TANK
	);


	`ifndef GEN_FSM
		assign state = state_r;
	`endif

	//@STATES
	localparam IDLE = 0,
							DISPOSAL = 1,
							STERILISE = 2,
							COOL = 3,
							PROCESS = 4,
							FULL = 5,
							HOT = 6,
							MASH = 7,
							SPARGE = 8,
							SPARGE_B = 9,
							DONE = 10;


	//TIMER
	localparam 	TIMER_MASH = 60,
							TIMER_SPARGE = 40;

	//TEMP
	localparam 	T_SAFE = 30,
							T_PROCESS = 60,
							T_LIMIT = T_PROCESS + 5,
							T_STERILE = 80,
							T_BOIL = 100;
	
	//LEVEL
	localparam 	L_EMPTY = 0,
							L_PREPARE = 125,
							L_SPARGE_START = 70,
							L_SPARGE_END = 40,
							L_BOIL = 175;

	//PUMP
	localparam 	P_OFF = 3'b000,
							P_WASTE = 3'b010,
							P_TO_TANK = 3'b011,
							P_FROM_TANK = 3'b101,
							P_WATER = 3'b100,
							P_SPARGE = 3'b111;

	//CHUTE
	localparam  C_CLOSE = 0,
							C_GRAIN = 1;



	reg [7:0] state_r, state_nxt;
	reg heat_r, heat_nxt, agitate_r, agitate_nxt;
	reg [2:0] pump_r, pump_nxt;
	reg chute_r, chute_nxt;

	always @(posedge clk) begin
		if(reset) begin
			state_r <= IDLE;
			//BITS
			heat_r <= 0;
			agitate_r <= 0;
			//BUS
			pump_r <= P_OFF;
			chute_r <= C_CLOSE;
		end else begin
			state_r <= state_nxt;
			//BITS
			heat_r <= heat_nxt;
			agitate_r <= agitate_nxt;
			//BUS
			pump_r <= pump_nxt;
			chute_r <= chute_nxt;
		end
	end

	always @(*) begin
		//+++ DEFAULTS +++
		state_nxt = state_r;
		heat_nxt = heat_r;
		agitate_nxt = agitate_r;
		pump_nxt = pump_r;
		chute_nxt = chute_r;
		//++++++++++++++++
		

		case (state_r)
			IDLE: begin
				if (level == L_EMPTY) begin
					state_nxt = PROCESS;
					heat_nxt = 1;
					pump_nxt = P_WATER;
				end else begin
					state_nxt = DISPOSAL;
					pump_nxt = P_WASTE;
				end
			end

			//CLEANING CYCLE
			DISPOSAL: begin
				if (level == L_EMPTY) begin
					state_nxt = STERILISE;
					pump_nxt = P_OFF;
					heat_nxt = 1;
				end
			end
			STERILISE: begin
				if (temp == T_STERILE) begin
					state_nxt = COOL;
					heat_nxt = 0;
				end
			end
			COOL: begin
				if (temp == T_SAFE) begin
					state_nxt = IDLE;
				end
			end

			//PROCESS CYCLE
			PROCESS: begin
				if (level >= L_PREPARE) begin
					state_nxt = FULL;
					pump_nxt = P_OFF;
				end else if (temp >= T_PROCESS) begin
					state_nxt = HOT;
				end
			end
			FULL: begin
				if (temp >= T_PROCESS) begin
					state_nxt = MASH;
					chute_nxt = C_GRAIN;
					agitate_nxt = 1;
				end
			end
			HOT: begin
				if (level >= L_PREPARE) begin
					state_nxt = MASH;
					chute_nxt = C_GRAIN;
					agitate_nxt = 1;
					pump_nxt = P_OFF;
				end
			end
			MASH: begin
				chute_nxt = C_CLOSE;
				if (temp >= T_LIMIT) begin
					state_nxt = SPARGE;
					heat_nxt = 0;
					pump_nxt = P_TO_TANK;
				end				
			end
			SPARGE: begin
				if (level < L_SPARGE_START) begin
					state_nxt = SPARGE_B;
				end
				if (pump == P_TO_TANK && level < 20) begin 
					state_nxt = DONE;
				end
			end
			SPARGE_B: begin
				pump_nxt = P_SPARGE;
				if (level < L_SPARGE_END) begin
					state_nxt = SPARGE;
					pump_nxt = P_TO_TANK;
				end
			end
			DONE: begin
				state_nxt = IDLE;
			end
		endcase
	end

	assign heat = heat_nxt;
	assign agitate = agitate_nxt;
	assign pump = pump_nxt;
	assign chute = chute_nxt;

endmodule