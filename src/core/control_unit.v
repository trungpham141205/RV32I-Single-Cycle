module control_unit(
    input wire [6:0] opcode,
    output reg RegWrite, ALUSrc, MemWrite, Branch, Jump,
    output reg[1:0] ResultSrc, ALUOp
);

    always @(*) begin
        case (opcode)
            7'b011_0111: {RegWrite, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump} = 9'b1x0110xx0; // LUI
            7'b001_0111: {RegWrite, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump} = 9'b110110000; // AUIPC

            7'b110_1111: {RegWrite, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump} = 9'b1x0100xx1; // JAL
            7'b110_0111: {RegWrite, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump} = 9'b110100000; // JALR

            7'b110_0011: {RegWrite, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump} = 9'b000xx1010; // Branch

            7'b000_0011: {RegWrite, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump} = 9'b110010000; // LW
            7'b010_0011: {RegWrite, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump} = 9'b011xx0000; // SW

            7'b011_0011: {RegWrite, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump} = 9'b100000100; // R type
            7'b001_0011: {RegWrite, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump} = 9'b110000100; // I-type ALU

            default: {RegWrite, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump} = 9'b0;
        endcase
    end

endmodule