// This is part of the ECE241 final project
// Date created: November 26 2016
// This file contains main module for the cpu to acheive text display with VGA

module text_display(VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK, SW, CLOCK_50, KEY, LEDR);
    //input clk;
    //input rst;

    output [7:0]VGA_R;
    output [7:0]VGA_G;
    output [7:0]VGA_B;
    output VGA_HS;
    output VGA_VS;
    output VGA_BLANK_N;
    output VGA_SYNC_N;
    output VGA_CLK;

    input [7:0]SW;
    input CLOCK_50;
    input [0:0]KEY;
    output [9:0]LEDR;

    wire clk = CLOCK_50;
    wire rst = ~KEY[0];

    wire fifo_empty;
    wire carriage_ascii;
    wire clear_screen;
    wire done_char;
    wire done_clear;
    wire rdreq;
    wire load_buff_reg;
    wire inc_cursor;
    wire carriage_cursor;
    wire display_char;
    wire do_clear;
    wire plot;

    text_display_controller display_controller
    (
        .clk(clk),
        .rst(rst),
        .fifo_empty(fifo_empty),
        .carriage_ascii(carriage_ascii),
        .clear_screen(clear_screen),
        .done_char(done_char),
        .done_clear(done_clear),
        .rdreq(rdreq),
        .load_buff_reg(load_buff_reg),
        .inc_cursor(inc_cursor),
        .carriage_cursor(carriage_cursor),
        .display_char(display_char),
        .do_clear(do_clear),
        .plot(plot),
        .LEDR(LEDR)
    );

    text_display_datapath display_datapath
    (
        .clk(clk),
        .rst(rst),
        .data(SW[6:0]),
        .rdreq(rdreq),
        .wrreq(SW[7]),
        .load_buff_reg(load_buff_reg),
        .inc_cursor(inc_cursor),
        .carriage_cursor(carriage_cursor),
        .display_char(display_char),
        .do_clear(do_clear),
        .plot(plot),
        .fifo_empty(fifo_empty),
        .carriage_ascii(carriage_ascii),
        .clear_screen(clear_screen),
        .done_char(done_char),
        .done_clear(done_clear),
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS),
        .VGA_BLANK(VGA_BLANK_N),
        .VGA_SYNC(VGA_SYNC_N),
        .VGA_CLK(VGA_CLK)
    );
endmodule