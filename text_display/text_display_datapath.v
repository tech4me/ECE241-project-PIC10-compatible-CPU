// This is part of the ECE241 final project
// Date created: November 23 2016
// This file contains the components to print text from cpu to VGA

module text_display_datapath(clk, rst, );
    input clk;
    input rst;

    text_display_FIFO FIFO
    (
        .clock(clk),
        .data(),
        .rdreq(),
        .sclr(rst),
        .wrreq(),
        .empty(),
	    .q()
    );

endmodule