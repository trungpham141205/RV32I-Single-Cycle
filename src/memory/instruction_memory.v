module instruction_memory(
    input wire clk, rst,
    input wire [31:0] read_address,
    output wire [31:0] instruction
);

    reg [31:0] memory [0:63];

    assign instruction = memory[read_address >> 2];

endmodule