`timescale 1ns/1ps
`default_nettype none
module uart_top_tb;
    parameter integer SYS_CLK_FREQ = 256;
    parameter integer BAUD_RATE    = 2;
    reg sys_clk;
    reg sys_rst_l;
    reg        xmitH;
    reg [7:0]  xmit_dataH;
    wire uart_XMIT_dataH;
    wire xmit_doneH;
    wire xmit_active;
    wire [7:0] rec_dataH;
    wire rec_readyH;
    wire rec_busy;
    wire uart_REC_dataH;
    assign uart_REC_dataH = uart_XMIT_dataH;
    uart_top #(
        .SYS_CLK_FREQ(SYS_CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) dut (
        .sys_clk(sys_clk),
        .sys_rst_l(sys_rst_l),

        .xmitH(xmitH),
        .xmit_dataH(xmit_dataH),

        .uart_REC_dataH(uart_REC_dataH),

        .uart_XMIT_dataH(uart_XMIT_dataH),
        .xmit_doneH(xmit_doneH),
        .xmit_active(xmit_active),

        .rec_dataH(rec_dataH),
        .rec_readyH(rec_readyH),
        .rec_busy(rec_busy)
    );
    initial begin
        $dumpfile("uart_top_tb.vcd");
        $dumpvars(0, uart_top_tb);
    end
    initial begin
        sys_clk = 0;
        forever #10 sys_clk = ~sys_clk;
    end
    initial begin
        $monitor("TIME=%0t | TX=%b DONE=%b ACTIVE=%b TX_DATA=%h | RX_READY=%b RX_BUSY=%b RX_DATA=%h",
                 $time, uart_XMIT_dataH, xmit_doneH, xmit_active, xmit_dataH,
                 rec_readyH, rec_busy, rec_dataH);
    end
    initial begin
        sys_rst_l   = 0;
        xmitH       = 0;
        xmit_dataH  = 8'h00;

        #200;
        sys_rst_l = 1;
        #500;
        xmit_dataH = 8'b10101011;
//        #400;
        xmitH = 1;
        #400;
        xmitH = 0;
        wait(xmit_doneH);
        wait(rec_readyH);
        #500;
        xmit_dataH = 8'b11001100;
        xmitH = 1;
        #400;
        xmitH = 0;
        wait(xmit_doneH);
        wait(rec_readyH);
        #1000;
        $finish;
    end
endmodule
