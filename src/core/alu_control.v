module alu_control(
    input wire [1:0] ALUOp,
    input wire funct7,
    input wire [2:0] funct3,
    output reg [3:0] ALUControl
);

    always @(*) begin
        casez ({ALUOp, funct3, funct7})
            6'b00????: ALUControl = 4'b0000; // ADD (LW, SW, JALR, AUIPC)

            // Branch Instructions
            6'b01000?,
            6'b01001?: ALUControl = 4'b0001;  // SUB (BEQ, BNE)
            6'b01100?,
            6'b01101?: ALUControl = 4'b0011; // BLT, BGE
            6'b01110?,
            6'b01111?: ALUControl = 4'b0100; // BLTU, BGEU

            //──────────────────────────────────────\\
            //─────────────── R Type ───────────────\\
            //──────────────────────────────────────\\  
            6'b100000: ALUControl = 4'b0000; // ADD
            6'b100001: ALUControl = 4'b0001; // SUB
            6'b10001?: ALUControl = 4'b0010; // SLL
            6'b10010?: ALUControl = 4'b0011; // SLT
            6'b10011?: ALUControl = 4'b0100; // SLTU
            6'b10100?: ALUControl = 4'b0101; // XOR
            6'b101010: ALUControl = 4'b0110; // SRL
            6'b101011: ALUControl = 4'b0111; // SRA
            6'b10110?: ALUControl = 4'b1000; // OR
            6'b10111?: ALUControl = 4'b1001; // AND

            //──────────────────────────────────────\\
            //─────────────── I Type ───────────────\\
            //──────────────────────────────────────\\
            6'b11000?: ALUControl = 4'b0000; // ADDI
            6'b110010: ALUControl = 4'b0010; // SLLI
            6'b11010?: ALUControl = 4'b0011; // SLTI
            6'b11011?: ALUControl = 4'b0100; // SLTIU
            6'b11100?: ALUControl = 4'b0101; // XORI
            6'b111010: ALUControl = 4'b0110; // SRLI
            6'b111011: ALUControl = 4'b0111; // SRAI
            6'b11110?: ALUControl = 4'b1000; // ORI
            6'b11111?: ALUControl = 4'b1001; // ANDI

            default: ALUControl = 4'b00;
        endcase
    end

endmodule
