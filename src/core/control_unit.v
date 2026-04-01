module control_unit(
    input wire [6:0] opcode,
    output reg RegWrite, ALUSrc, AUIPC, MemWrite, Branch, Jump, JumpReg, 
    output reg[1:0] ResultSrc, ALUOp
);

    always @(*) begin
        case (opcode)
            7'b011_0111: {RegWrite, AUIPC, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, JumpReg} = 11'b10x0110xx00; // LUI
            7'b001_0111: {RegWrite, AUIPC, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, JumpReg} = 11'b11100000000; // AUIPC

            7'b110_1111: {RegWrite, AUIPC, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, JumpReg} = 11'b10x0100xx10; // JAL
            7'b110_0111: {RegWrite, AUIPC, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, JumpReg} = 11'b10101000001; // JALR

            7'b110_0011: {RegWrite, AUIPC, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, JumpReg} = 11'b0000xx10100; // Branch

            7'b000_0011: {RegWrite, AUIPC, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, JumpReg} = 11'b10100100000; // LW
            7'b010_0011: {RegWrite, AUIPC, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, JumpReg} = 11'b0011xx00000; // SW

            7'b011_0011: {RegWrite, AUIPC, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, JumpReg} = 11'b10000001000; // R type
            7'b001_0011: {RegWrite, AUIPC, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, JumpReg} = 11'b10100001000; // I-type ALU

            default: {RegWrite, AUIPC, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, JumpReg} = 11'b0;
        endcase
    end

endmodule