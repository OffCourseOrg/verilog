/*
 *  OffCourse::Verilog
 *		- Home Security BMC
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	bmc(
  input wire clk,
  input wire enable,
  input wire reset,
  input wire trigger,
  input wire [1:0] command,
  input wire [3:0] digit,
  input wire input_digit,
);

  reg f_isReset;
  initial f_isReset <= 0;
  wire armed_ref, armed_dut;
  wire alarm_ref, alarm_dut;
  wire [3:0] state_ref, state_dut;

  REF REF (
    .clk(clk),
    .reset(reset),
    .trigger(trigger),
    .command(command),
    .digit(digit),
    .input_digit(input_digit),

    .armed(armed_ref),
    .alarm(alarm_ref),
    .state_ref(state_ref)

  );

  UUT UUT(
    .clk(clk),
    .reset(reset),
    .trigger(trigger),
    .command(command),
    .digit(digit),
    .input_digit(input_digit),

    .armed(armed_dut),
    .alarm(alarm_dut),
    .state(state_dut)
  );

`ifdef	FORMAL
  always @(posedge clk) begin
    if(reset)
        f_isReset <= 1;
  end

  always @(*) begin
    if(f_isReset) begin
        assert(armed_ref == armed_dut);
        assert(alarm_ref == alarm_ref);
        assert(state_ref == state_dut);
    end
  end
`endif
endmodule
