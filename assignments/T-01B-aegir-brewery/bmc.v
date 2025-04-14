/*
 *  OffCourse::Verilog
 *		- Aegir's Brewery system_bmc
 *
 *  Copyright: Sybe Feitsma && e.t.s.v Thor
 *  License: GPLv3 or later
 */

 module bmc(
  input clk,
  input reset,
  input valid,
  input [7:0] level_sensor,
  input [7:0] temperature
 );

  reg f_isReset;
  initial f_isReset <= 0;
  wire motor_ref, grain_feed_ref, heater_ref, sparge_valve_ref, valve_ref;
  wire motor_uut, grain_feed_uut, heater_uut, sparge_valve_uut, valve_uut;
  wire [1:0] pump_ref, pump_uut;
  wire [7:0] level_ref, level_uut;

  brew_system_ref REF (
    .clock(clk),
    .nreset(reset),
    .valid(valid),
    .level_sensor(level_sensor),
    .temperature(temperature),
    .motor(motor_ref),
    .grain_feed(grain_feed_ref),
    .heater(heater_ref),
    .sparge_valve(sparge_valve_ref),
    .valve(valve_ref),
    .pump(pump_ref),
    .level(level_ref)
  );

  brew_system UUT (
    .clock(clk),
    .nreset(reset),
    .valid(valid),
    .level_sensor(level_sensor),
    .temperature(temperature),
    .motor(motor_uut),
    .grain_feed(grain_feed_uut),
    .heater(heater_uut),
    .sparge_valve(sparge_valve_uut),
    .valve(valve_uut),
    .pump(pump_uut),
    .level(level_uut)
  );

`ifdef	FORMAL
  always @(posedge clk) begin
    if(~reset)
        f_isReset <= 1;
  end

  always @(*) begin
    if(f_isReset) begin
        assert(level_ref == level_uut);
        assert(motor_ref == motor_uut);
        assert(grain_feed_ref == grain_feed_uut);
        assert(heater_ref == heater_uut);
        assert(sparge_valve_ref == sparge_valve_uut);
        assert(valve_ref == valve_uut);
        assert(pump_ref == pump_uut);
    end
  end
`endif
endmodule
