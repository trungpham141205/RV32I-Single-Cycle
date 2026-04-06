module control_unit(
    input wire [6:0] opcode,
    output reg RegWrite, ALUSrc, AUIPC, MemWrite, Branch, Jump, JumpReg, 
    output reg [2:0] ImmSel,
    output reg [1:0] ResultSrc, ALUOp
);

    always @(*) begin
        case (opcode)

            //──────────────────────────────────────\\
            //─────────────── U Type ───────────────\\
            //──────────────────────────────────────\\
            // Load Upper Immediate (LUI)
            7'b011_0111: {ImmSel, RegWrite, AUIPC, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, JumpReg} = 14'b000_1_0_0_0_11_0_00_0_0;
            // Add Upper Immediate to PC (AUIPC)
            7'b001_0111: {ImmSel, RegWrite, AUIPC, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, JumpReg} = 14'b000_1_1_1_0_00_0_00_0_0; 

            //──────────────────────────────────────\\
            //─────────────── J Type ───────────────\\
            //──────────────────────────────────────\\
            //  Jump and Link (JAL)
            7'b110_1111: {ImmSel, RegWrite, AUIPC, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, JumpReg} = 14'b001_1_0_0_0_10_0_00_1_0; 

            //──────────────────────────────────────\\
            //─────────────── B Type ───────────────\\
            //──────────────────────────────────────\\
            // Branch Instructions
            7'b110_0011: {ImmSel, RegWrite, AUIPC, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, JumpReg} = 14'b010_0_0_0_0_00_1_01_0_0; 

            //──────────────────────────────────────\\
            //─────────────── I Type ───────────────\\
            //──────────────────────────────────────\\
            // Jump and Link Register (JALR)
            7'b110_0111: {ImmSel, RegWrite, AUIPC, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, JumpReg} = 14'b011_1_0_1_0_10_0_00_0_1; 
            // Memory Load Instructions
            7'b000_0011: {ImmSel, RegWrite, AUIPC, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, JumpReg} = 14'b011_1_0_1_0_01_0_00_0_0; 
            // Integer Register - Immediate Instructions
            7'b001_0011: {ImmSel, RegWrite, AUIPC, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, JumpReg} = 14'b011_1_0_1_0_00_0_10_0_0; 

            //──────────────────────────────────────\\
            //─────────────── S Type ───────────────\\
            //──────────────────────────────────────\\
            // Memory Store Instructions
            7'b010_0011: {ImmSel, RegWrite, AUIPC, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, JumpReg} = 14'b100_0_0_1_1_00_0_00_0_0; // SW

            //──────────────────────────────────────\\
            //─────────────── R Type ───────────────\\
            //──────────────────────────────────────\\
            // Integer Register - Register Instructions 
            7'b011_0011: {ImmSel, RegWrite, AUIPC, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, JumpReg} = 14'b111_1_0_0_0_00_0_10_0_0; // R type

            default: {ImmSel, RegWrite, AUIPC, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, JumpReg} = 14'b0;
        endcase
    end

endmodule