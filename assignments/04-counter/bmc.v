/*
 *  OffCourse::Verilog
 *		- Counter BMC
 *
 *  Copyright: Sybe
 *  License: GPLv3 or later
 */

module	bmc(
    input wire clk,
    input wire	enable,
    input wire reset,
);

    reg f_isReset;
    initial f_isReset <= 0;
    wire [15:0] count_ref, count_uut;

    REF #(
        .MAX_AMOUNT(69)
    ) REF (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .count(count_ref)
    );

    UUT UUT(
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .count(count_uut)
    );

`ifdef	FORMAL
    always @(posedge clk) begin
        if(reset)
            f_isReset <= 1;
    end

    always @(*) begin
        if(f_isReset)
            assert(count_ref == count_uut);
    end
`endif
endmodule