module toplevel(CLOCK_50, KEY, SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    input CLOCK_50;
    input [3:0]KEY;
    input [9:0]SW;
    output [9:0]LEDR;
    output [6:0]HEX0;
    output [6:0]HEX1;
    output [6:0]HEX2;
    output [6:0]HEX3;
    output [6:0]HEX4;
    output [6:0]HEX5;

    wire clk;

    assign clk = SW[9] ? (~KEY[1]) : CLOCK_50;

    cpu cpu_core
    (
        .clk(clk),
        .rst(~KEY[0]),
        .GPIO0(),
        .GPIO1(),
        .GPIO2(),
        .SW(SW[4:0]),
        .LEDR(LEDR),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3)
    );

endmodule