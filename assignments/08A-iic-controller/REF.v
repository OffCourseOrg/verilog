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
		input SDA_recv,
		input start,
		input stop,
		input edge_scl,
		output reg grab_SDA,
		output reg SDA_drive,
	`ifndef GEN_FSM
		output [7:0] state_ref,
	`endif
		output reg [7:0] mem
	);

	localparam [7:0] ADDRESS = 69;

	//@STATES
	localparam _MIN_STATE = 0,
		RESET = 0,
		IDLE = 1,
		START = 2,
		AB7 = 3,
		AB6 = 4,
		AB5 = 5,
		AB4 = 6,
		AB3 = 7,
		AB2 = 8,
		AB1 = 9,
		WRONG_ADDR = 54,
		OPERATION = 10,
		PREAD = 50,
		READ = 11,
		RB8 = 12,
		RB7 = 13,
		RB6 = 14,
		RB5 = 15,
		RB4 = 16,
		RB3 = 17,
		RB2 = 18,
		RB1 = 19,
		RELEASE = 53,
		PWRITE = 51,
		ACK_WRITE = 52,
		WRITE = 20,
		WB8 = 21,
		WB7 = 22,
		WB6 = 23,
		WB5 = 24,
		WB4 = 25,
		WB3 = 26,
		WB2 = 27,
		WB1 = 28,
		END_WRITE = 29,
		ACK_WRITE2 = 30,
		_MAX_STATE = 60;


	reg [7:0] state;
	reg [7:0] state_next;

	`ifndef GEN_FSM
		assign state_ref = state;
	`endif

	//Labels FSM Logic
	always @(posedge clk) begin
		if(reset) begin
			state <= RESET;
		end else begin
			state <= state_next;
		end
	end

	always @(*) begin
		grab_SDA = grab_SDA;
		SDA_drive = SDA_drive;
		mem = mem;
		state_next = state; //default
		case(state)
			RESET: begin
				grab_SDA = 0;
				SDA_drive = 1;
				mem = 8'b10000001;
				state_next = IDLE;
			end
			IDLE: begin
				state_next = start ? AB7 : IDLE;
			end
			AB7: begin
				if(edge_scl && SCL) begin
					state_next = ADDRESS[6] == SDA_recv ? AB6 : WRONG_ADDR;
				end
			end
			AB6: begin
				if(edge_scl && SCL) begin
					state_next = ADDRESS[5] == SDA_recv ? AB5 : WRONG_ADDR;
				end
			end
			AB5: begin
				if(edge_scl && SCL) begin
					state_next = ADDRESS[4] == SDA_recv ? AB4 : WRONG_ADDR;
				end
			end
			AB4: begin
				if(edge_scl && SCL) begin
					state_next = ADDRESS[3] == SDA_recv ? AB3 : WRONG_ADDR;
				end
			end
			AB3: begin
				if(edge_scl && SCL) begin
					state_next = ADDRESS[2] == SDA_recv ? AB2 : WRONG_ADDR;
				end
			end
			AB2: begin
				if(edge_scl && SCL) begin
					state_next = ADDRESS[1] == SDA_recv ? AB1 : WRONG_ADDR;
				end
			end
			AB1: begin
				if(edge_scl && SCL) begin
					state_next = ADDRESS[0] == SDA_recv ? OPERATION : IDLE;
				end
			end
			WRONG_ADDR: begin
				state_next = IDLE;
			end
			OPERATION: begin
				if(edge_scl && SCL) begin
					state_next = SDA_recv ? PREAD : PWRITE;
				end
			end
			//MASTER READ
			PREAD: begin
				if(edge_scl && !SCL) begin
					state_next = READ;
				end
			end
			READ: begin
				grab_SDA = 1;
				SDA_drive = 0;
				if(edge_scl && !SCL) begin
					state_next = RB8;
				end
			end
			RB8: begin
				SDA_drive = mem[7];
				if(edge_scl && !SCL) begin
					state_next = RB7;
				end
			end
			RB7: begin
				SDA_drive = mem[6];
				if(edge_scl && !SCL) begin
					state_next = RB6;
				end
			end
			RB6: begin
				SDA_drive = mem[5];
				if(edge_scl && !SCL) begin
					state_next = RB5;
				end
			end
			RB5: begin
				SDA_drive = mem[4];
				if(edge_scl && !SCL) begin
					state_next = RB4;
				end
			end
			RB4: begin
				SDA_drive = mem[3];
				if(edge_scl && !SCL) begin
					state_next = RB3;
				end
			end
			RB3: begin
				SDA_drive = mem[2];
				if(edge_scl && !SCL) begin
					state_next = RB2;
				end
			end
			RB2: begin
				SDA_drive = mem[1];
				if(edge_scl && !SCL) begin
					state_next = RB1;
				end
			end
			RB1: begin
				SDA_drive = mem[0];
				if(edge_scl && !SCL) begin
					state_next = RELEASE;
				end
			end
			RELEASE: begin
				grab_SDA = 0;
				state_next = IDLE;
			end

			//WRITE MASTER
			PWRITE: begin
				if(edge_scl && !SCL) begin
					state_next = ACK_WRITE;
				end
			end
			ACK_WRITE: begin
				grab_SDA = 1;
				SDA_drive = 0;
				if(edge_scl && !SCL) begin
					state_next = WRITE;
				end
			end
			WRITE: begin
				grab_SDA = 0;
				SDA_drive = 1;
				state_next = WB8;
			end
			WB8: begin
				mem[7] = SDA_recv;
				if(edge_scl && SCL) begin
					state_next = WB7;
				end
			end
			WB7: begin
				mem[6] = SDA_recv;
				if(edge_scl && SCL) begin
					state_next = WB6;
				end
			end
			WB6: begin
				mem[5] = SDA_recv;
				if(edge_scl && SCL) begin
					state_next = WB5;
				end
			end
			WB5: begin
				mem[4] = SDA_recv;
				if(edge_scl && SCL) begin
					state_next = WB4;
				end
			end
			WB4: begin
				mem[3] = SDA_recv;
				if(edge_scl && SCL) begin
					state_next = WB3;
				end
			end
			WB3: begin
				mem[2] = SDA_recv;
				if(edge_scl && SCL) begin
					state_next = WB2;
				end
			end
			WB2: begin
				mem[1] = SDA_recv;
				if(edge_scl && SCL) begin
					state_next = WB1;
				end
			end
			WB1: begin
				mem[0] = SDA_recv;
				if(edge_scl && SCL) begin
					state_next = END_WRITE;
				end
			end
			END_WRITE: begin
				if(edge_scl && !SCL) begin
					state_next = ACK_WRITE2;
				end
			end
			ACK_WRITE2: begin
				grab_SDA = 1;
				SDA_drive = 0;
				if(edge_scl && !SCL) begin
					state_next = RELEASE;
				end
			end
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
