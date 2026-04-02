module riscv_top(
    input wire clk, rst
);
    //────────────────────────────────────
    //─────────────── Wire ───────────────
    //────────────────────────────────────
    //  PC
    wire [31:0] pc, pc_next, pc_inc, pc_branch_jump;
    wire        pc_sel;

    //  Instruction
    wire [31:0] instruction;
    wire [6:0]  opcode;
    wire [4:0]  rs1, rs2, rd;
    wire [2:0]  fucnt3;
    wire        fucnt7;

    //  Control signals
    wire        RegWrite, ALUSrc, AUIPC, MemWrite;
    wire        Branch, Jump, JumpReg;
    wire [1:0]  ResultSrc, ALUOp;

    //  Register File
    wire [31:0] read_data_1, read_data_2;

    //  Immediate
    wire [31:0] immediate;

    //  ALU
    wire [3:0]  ALUControl;
    wire [31:0] A, B, Result;
    wire        zero;

    //  Memory
    wire        mem_read_data;

    //  Write Back
    wire        write_data;

    //──────────────────────────────────────────────────
    //─────────────── Instruction Fields ───────────────
    //──────────────────────────────────────────────────
    assign      opcode  = instruction[6:0];
    assign      rd      = instruction[11:7];
    assign      fucnt3  = instruction[14:12]
    assign      rs1     = instruction[19:15];
    assign      rs2     = instruction[24:20];
    assign      funct7  = instruction[30];

    //────────────────────────────────────────
    //─────────────── PC logic ───────────────
    //────────────────────────────────────────
    assign      pc_sel  = (Branch & zero) | Jump | JumpReg;
    assign      pc_next = pc_sel ? pc_branch_jump : pc_inc;

    program_counter dut_pc(
        .clk            (clk),
        .rst            (rst),
        .pc_next        (pc_next),
        .pc             (pc)
    );

    pc_increment dut_increment(
        .pc             (pc),
        .pc_inc         (pc_inc)
    );

    branch_jump dut_branch_jump(
        .pc             (pc),
        .rs1            (read_data_1),
        .immediate      (immediate),
        .jump_reg       (JumpReg),
        .pc_branch_jump (pc_branch_jump)
    );

    //──────────────────────────────────────────────────
    //─────────────── Instruction Memory ───────────────
    //──────────────────────────────────────────────────
    instruction_memory dut_instruction_memory(
        .read_address   (pc),
        .instruction    (instruction)
    );

    //────────────────────────────────────────────
    //─────────────── Control Unit ───────────────
    //────────────────────────────────────────────
    


endmodule