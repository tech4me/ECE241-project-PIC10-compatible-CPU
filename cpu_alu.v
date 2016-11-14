// This is part of the ECE241 final project
// Date created: November 10 2016
// This file contains the ALU(Arithmetic logic Unit) of The CPU

module cpu_alu(alu_op_in, alu_in_w, alu_in_mux, status_carry_in, alu_out, status_c_load, status_dc_load, status_z_load, alu_status_out);
    `include "definition.vh"
    input [11:0]alu_op_in;
    input [7:0]alu_in_w;
    input [7:0]alu_in_mux;
    input status_carry_in;
    output reg [7:0]alu_out;
    output reg status_c_load, status_dc_load, status_z_load;
    output reg [2:0]alu_status_out;

    reg [3:0]dump; //In some operation some values are not useful
    reg [2:0]b; //b represent the position in f
    reg [7:0]mask; //Mask to clear and set

    //The always block for the ALU
    always @ (*)
    begin
        //The default control signals and status output is set to 0
        status_c_load = 1'b0;
        status_dc_load = 1'b0;
        status_z_load = 1'b0;
        alu_status_out = 3'b0;

        //Default output for ALU
        alu_out = 8'b0;

        //Default for local things
        dump = 4'b0;
        b = 3'b0;
        mask = 8'b0;

        casex(alu_op_in)
            12'b000111xxxxxx: //ADDWF status register C,DC,Z
            begin
                {alu_status_out[`STATUS_C], alu_out} = alu_in_w + alu_in_mux;
                {alu_status_out[`STATUS_DC], dump} = alu_in_w[3:0] + alu_in_mux[3:0];
                alu_status_out[`STATUS_Z] = (alu_out == 12'b0);
                status_c_load = 1'b1;
                status_dc_load = 1'b1;
                status_z_load = 1'b1;
            end
            12'b000101xxxxxx: //ANDWF status register Z
            begin
                alu_out = alu_in_w & alu_in_mux;
                alu_status_out[`STATUS_Z] = (alu_out == 12'b0);
                status_z_load = 1'b1;
            end
            12'b0000011xxxxx: //CLRF status register Z
            begin
                alu_out = 8'b0;
                alu_status_out[`STATUS_Z] = 1'b1;
                status_z_load = 1'b1;
            end
            12'b000001000000: //CRLW status register Z
            begin
                alu_out = 8'b0;
                alu_status_out[`STATUS_Z] = 1'b1;
                status_z_load = 1'b1;
            end
            12'b001001xxxxxx: //COMF status resigter Z
            begin
                alu_out = ~alu_in_mux;
                alu_status_out[`STATUS_Z] = (alu_out == 12'b0);
                status_z_load = 1'b1;
            end
            12'b000011xxxxxx: //DECF status register Z
            begin
                alu_out = alu_in_mux - 1'b1;
                alu_status_out[`STATUS_Z] = (alu_out == 12'b0);
                status_z_load = 1'b1;
            end
            12'b001011xxxxxx: //DECFSZ status none
            begin
                alu_out = alu_in_mux - 1'b1;
                alu_status_out[`STATUS_Z] = (alu_out == 12'b0);
            end
            12'b001010xxxxxx: //INCF status register Z
            begin
                alu_out = alu_in_mux + 1'b1;
                alu_status_out[`STATUS_Z] = (alu_out == 12'b0);
                status_z_load = 1'b1;
            end
            12'b001111xxxxxx: //INCFSZ status none
            begin
                alu_out = alu_in_mux - 1'b1;
                alu_status_out[`STATUS_Z] = (alu_out == 12'b0);
            end
            12'b000100xxxxxx: //IORWF status Z
            begin
                alu_out = alu_in_w | alu_in_mux;
                alu_status_out[`STATUS_Z] = (alu_out == 12'b0);
                status_z_load = 1'b1;
            end
            12'b001000xxxxxx: //MOVF status Z
            begin
                alu_out = alu_in_mux;
                alu_status_out[`STATUS_Z] = (alu_out == 12'b0);
                status_z_load = 1'b1;
            end
            12'b0000001xxxxx: //MOVWF status none
            begin
                alu_out = alu_in_w;
            end
            12'b000000000000: //NOP status none
            begin
                alu_out = 8'b0;
            end
            12'b001101xxxxxx: //RLF status C
            begin
                {alu_status_out[`STATUS_C], alu_out} = {alu_in_mux, status_carry_in};
                status_c_load = 1'b1;
            end
            12'b001100xxxxxx: //RRF status C
            begin
                {alu_out, alu_status_out[`STATUS_C]} = {status_carry_in, alu_in_mux};
                status_c_load = 1'b1;
            end
            12'b000010xxxxxx: //SUBWF status register C,DC,Z
            begin
                alu_out = alu_in_mux - alu_in_w;
                alu_status_out[`STATUS_C] = alu_in_mux >= alu_in_w;
                alu_status_out[`STATUS_DC] = alu_in_mux[3:0] >= alu_in_w[3:0];
                alu_status_out[`STATUS_Z] = (alu_out == 12'b0);
                status_c_load = 1'b1;
                status_dc_load = 1'b1;
                status_z_load = 1'b1;
            end
            12'b001110xxxxxx: //SWAPF status none
            begin
                alu_out[3:0] = alu_in_mux[7:4];
                alu_out[7:4] = alu_in_mux[3:0];
            end
            12'b000110xxxxxx: //XORWF status register Z
            begin
                alu_out = alu_in_w ^ alu_in_mux;
                alu_status_out[`STATUS_Z] = (alu_out == 12'b0);
                status_z_load = 1'b1;
            end
            12'b0100xxxxxxxx: //BCF status none
            begin
                b = alu_op_in[7:5];
                mask = ~(1<<b);
                alu_out = alu_in_mux & mask;
            end
            12'b0101xxxxxxxx: //BSF status none
            begin
                b = alu_op_in[7:5];
                mask = (1<<b);
                alu_out = alu_in_mux | mask;
            end
            12'b0110xxxxxxxx: //BTFSC status none
            begin
                b = alu_op_in[7:5];
                mask = (1<<b);
                alu_status_out[`STATUS_Z] = ((alu_in_mux & mask) != mask);
            end
            12'b0111xxxxxxxx: //BTFSS status none
            begin
                b = alu_op_in[7:5];
                mask = (1<<b);
                alu_status_out[`STATUS_Z] = ((alu_in_mux & mask) != mask);
            end
            12'b1110xxxxxxxx: //ANDLW status Z
            begin
                alu_out = alu_in_w & alu_op_in[7:0];
                alu_status_out[`STATUS_Z] = (alu_out == 12'b0);
                status_z_load = 1'b1;
            end
            12'b1001xxxxxxxx: //CALL status none
            begin
                alu_out = alu_op_in[7:0];
            end
            12'b000000000100: //CLRWDT status TO,PD
            begin
                //WDT not implemented in this design
            end
            12'b101xxxxxxxxx: //GOTO status none
            begin
                //No operation, loaded outside already
            end
            12'b1101xxxxxxxx: //IORLW status Z
            begin
                alu_out = alu_in_w | alu_op_in[7:0];
                alu_status_out[`STATUS_Z] = (alu_out == 12'b0);
                status_z_load = 1'b1;
            end
            12'b1100xxxxxxxx: //MOVLW status none
            begin
                alu_out = alu_op_in[7:0];
            end
            12'b000000000010: //OPTION status none
            begin
                alu_out = alu_in_w;
            end
            12'b1000xxxxxxxx: //RETLW status none
            begin
                alu_out = alu_op_in[7:0];
            end
            12'b000000000011: //SLEEP status TO,PD
            begin
                //SLEEP not implemented in this design
            end
            12'b000000000xxx: //TRIS status none
            begin
                alu_out = alu_in_w;
            end
            12'b1111xxxxxxxx: //XORLW status Z
            begin
                alu_out = alu_in_w ^ alu_op_in[7:0];
                alu_status_out[`STATUS_Z] = (alu_out == 12'b0);
                status_z_load = 1'b1;
            end
        endcase
    end
endmodule