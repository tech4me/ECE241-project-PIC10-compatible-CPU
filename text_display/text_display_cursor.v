// This is part of the ECE241 final project
// Date created: November 23 2016
// This file contains the cursor counter that save the current position for printing to the screen

module text_diaplay_cursor(clk, rst, inc_cursor, carriage_cursor, cursor);
    input clk;
    input rst;
    input inc_cursor;
    input carriage_cursor;

    output reg [11:0]cursor;

    always @ (posedge clk)
    begin
        if (rst)
            cursor <= 12'b0;
        else if (inc_cursor)
            cursor <= cursor + 1'b1;
        else if (carriage_cursor)
        begin
            if (cursor >= 12'd2320)
                cursor <= 12'b0;
            else
                cursor <= cursor + 12'd80 - (cursor%12'd80);
        end
        else if (cursor == 12'd2400)
            cursor <= 12'b0;
    end
endmodule