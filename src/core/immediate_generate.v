module immediate_generate(
    input wire [6:0]opcode,
    input wire [31:0]instruction,
    output reg [31:0]immediate_extend
);

    always @(*) begin
        case (opcode)
            7'b011_0111: immediate_extend = {instruction[31:12], 12'b0}; // LUI
            7'b001_0111: immediate_extend = {instruction[31:12], 12'b0}; // AUIPC

            7'b110_1111: immediate_extend = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0}; //JAL
            7'b110_0111: immediate_extend = {{20{instruction[31]}}, instruction[30:20]}; // JALR

            7'b110_0011: immediate_extend = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // BEQ, BNE

            7'b000_0011: immediate_extend = {{20{instruction[31]}}, instruction[30:20]}; // LW
            7'b010_0011: immediate_extend = {{20{instruction[31]}}, instruction[30:25], instruction[11:8], instruction[7]}; //SW

            7'b001_0011: immediate_extend = {{20{instruction[31]}}, instruction[30:20]}; // ADDI
            default: immediate_extend = 32'b0;
        endcase
    end

endmodule

// add, sub, addi
// and, or, xor
// lw, sw
// beq, bne
// slt
// jal, jalr
// auipc