/*
 *  OffCourse::Verilog
 *		- IIC CONTROLLER decoder
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	decoder (
		input clk,
		input SCL,
		inout SDA,

		input grab_SDA,
		input SDA_drive,
		output SDA_recv,

		output reg start,
		output reg stop,
    output reg edge_scl
	);
  assign SDA = grab_SDA ? SDA_drive : 1'bz;
  assign SDA_recv = SDA;

	reg prv_SDA;
  reg prv_scl;
	always @(posedge clk) begin
		start <= 0;
		stop <= 0;
    edge_scl <= 0;
		if(prv_scl != SCL) begin
			edge_scl <= 1;
		end
		if(SCL == 1) begin
			if(prv_SDA != SDA) begin
				if(SDA == 1)
					stop <= 1;
				else
					start <= 1;
			end
		end
    prv_scl <= SCL;
		prv_SDA <= SDA;
	end
endmodule