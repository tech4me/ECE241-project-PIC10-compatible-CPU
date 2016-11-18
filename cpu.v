    // The program_memory module
    cpu_program_memory program_memory
    (
        .address(wire_program_address),
        .clock(clk),
        .data(12'b0), // To be changed later, only one program for now
        .wren(1'b0),
        .q(wire_program_bus)
    );