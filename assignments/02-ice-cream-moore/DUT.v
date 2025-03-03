/*
 *  OffCourse::Verilog
 *		- ice-cream-moore UUT
 *
 *  Copyright: Aleksandrs
 *  License: GPLv3 or later
 */

module UUT (
  input clk,
	input reset,
  input insert,
  input wire [1:0] coins,
  output reg [1:0] ice_cream_balls,
  output reg [2:0] state
);


  localparam COIN0 = 2'b00,
             COIN1 = 2'b01,
             COIN2 = 2'b10;
  //@STATES
  localparam 
             
  reg [2:0] state;
  reg insert_prev;
  reg [2:0] state_next;



endmodule
