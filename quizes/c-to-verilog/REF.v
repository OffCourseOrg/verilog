`timescale 1ps/1ps

module REF(
    input clk,
    input resetn,
    input in,
    output reg out
);

    localparam COUNTER_INIT = 5'h13;

    reg [4:0] counter;
    reg in_latch;

    //counter logic not simplified
    always@(posedge clk) begin
        if(~resetn) begin
            counter <= COUNTER_INIT;
        end else if(counter == 0) begin
            counter <= COUNTER_INIT;
        end else if(in != in_latch) begin
            counter <= counter - 1;
        end else begin
            counter <= COUNTER_INIT;
        end
    end
    
    //in_latch logic not simplified
    always@(posedge clk) begin
        if(~resetn) begin
            in_latch <= 0;
        end else if(counter == 0) begin
            in_latch <= ~in_latch;
        end else begin
            in_latch <= in_latch;
        end
    end

    //out logic not simplified
    always@(posedge clk) begin
        if(~resetn) begin
            out <= 0;
        end else if(counter == 0) begin
            out <= ~in_latch;
        end else begin
            out <= 0;
        end
    end
    
endmodule
