/*
 *  OffCourse::Verilog
 *		- Counter BMC
 *
 *  Written by: Sybe
 *  License: MIT
 */

module	bmc(
    input wire clk,
    input wire	enable,
    input wire reset,
);

    reg f_isReset;
    initial f_isReset <= 0;
    wire [15:0] count_ref, count_dut;

    REF #(
        .MAX_AMOUNT(69)
    ) REF (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .count(count_ref)
    );

    DUT DUT(
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .count(count_dut)
    );

`ifdef	FORMAL
    always @(posedge clk) begin
        if(reset)
            f_isReset <= 1;
    end

    always @(*) begin
        if(f_isReset)
            assert(count_ref == count_dut);
    end
`endif
endmodule