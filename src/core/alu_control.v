module alu_control(
    input wire [1:0] ALUOp,
    input wire funct7,
    input wire [2:0] funct3,
    output reg [3:0] ALUControl
);

    always @(*) begin
        casez ({ALUOp, funct3, funct7})
            6'b00????: ALUControl = 4'b0000; // LW, SW, JALR, AUIPC
            6'b01????: ALUControl = 4'b0001; // Branch
            6'b100000: ALUControl = 4'b0000; // ADD, ADDI
            6'b100001: ALUControl = 4'b0001; // SUB
            6'b100010: ALUControl = 4'b0010; // SLL, SLLI
            6'b100100: ALUControl = 4'b0011; // SLT, SLTI
            6'b100110: ALUControl = 4'b0100; // SLTU, SLTIU
            6'b101000: ALUControl = 4'b0101; // XOR, XORI
            6'b101010: ALUControl = 4'b0110; // SRL, SRLI
            6'b101011: ALUControl = 4'b0111; // SRA, SRAI
            6'b101100: ALUControl = 4'b1000; // OR, ORI
            6'b101110: ALUControl = 4'b1001; // AND, ANDI
            
            default: ALUControl = 4'b0;
        endcase
    end

endmodule
