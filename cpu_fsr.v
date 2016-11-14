// This is part of the ECE241 final project
// Date created: November 14 2016
// This file contains the FSR(File Select Register) which can provide inderect access to register locations

module cpu_fsr(clk, rst, alu_to_fsr, load_sfr, sfr_out);
    input clk;
    input rst;
    input [7:0]alu_to_fsr;
    input load_sfr;
    output reg sfr_out;

    always @ (posedge clk)
    begin
        if (rst)
            sfr_out <= 8'b0;
        else if (load_sfr)
            sfr_out <= alu_to_fsr;
    end
endmodule