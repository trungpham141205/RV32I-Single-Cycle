module riscv_top(
    input wire clk, rst
);
    //────────────────────────────────────\\
    //─────────────── Wire ───────────────\\
    //────────────────────────────────────\\
    //  PC
    wire [31:0] pc, pc_next, pc_inc, pc_branch_jump;

    //  Instruction
    wire [31:0] instruction;
    wire [6:0]  opcode;
    wire [4:0]  rs1_add, rs2_add, rd_add;
    wire [2:0]  funct3;
    wire        funct7;

    //  Control signals
    wire        RegWrite, ALUSrc, AUIPC, MemWrite;
    wire        Branch, Jump, JumpReg;
    wire [1:0]  ResultSrc, ALUOp;
    wire [2:0]  ImmSel;

    //  Register File
    wire [31:0] read_data_1, read_data_2;

    //  Immediate
    wire [31:0] immediate;

    //  ALU
    wire [3:0]  ALUControl;
    wire [31:0] A, B;
    wire [31:0] result;
    wire        zero;

    //  Memory
    wire [31:0] read_data;

    //  Write Back
    wire [31:0] write_data; 

    //──────────────────────────────────────────────────\\
    //─────────────── Instruction Fields ───────────────\\
    //──────────────────────────────────────────────────\\
    assign      opcode  = instruction[6:0];
    assign      rd_add  = instruction[11:7];
    assign      funct3  = instruction[14:12];
    assign      rs1_add = instruction[19:15];
    assign      rs2_add = instruction[24:20];
    assign      funct7  = instruction[30];

    program_counter dut_pc(
        .clk                (clk),
        .rst                (rst),
        .pc_next            (pc_next),
        .pc                 (pc)
    );

    pc_increment dut_increment(
        .pc                 (pc),
        .pc_inc             (pc_inc)
    );

    branch_unit dut_branch_unit(
        .Branch             (Branch),
        .Jump               (Jump),
        .JumpReg            (JumpReg),
        .zero               (zero),
        .alu_result         (result),
        .funct3             (funct3),
        .pc_branch_jump     (pc_branch_jump),
        .pc_inc             (pc_inc),
        .pc_next            (pc_next)
    );

    branch_jump dut_branch_jump(
        .JumpReg           (JumpReg),
        .pc                 (pc),
        .rs1                (read_data_1),
        .immediate          (immediate),
        .pc_branch_jump     (pc_branch_jump)
    );

    //──────────────────────────────────────────────────\\
    //─────────────── Instruction Memory ───────────────\\
    //──────────────────────────────────────────────────\\
    instruction_memory dut_instruction_memory(
        .read_address       (pc),
        .instruction        (instruction)
    );

    //────────────────────────────────────────────\\
    //─────────────── Control Unit ───────────────\\
    //────────────────────────────────────────────\\
    control_unit dut_control_unit(
        .opcode             (opcode),
        .funct3             (funct3),
        .RegWrite           (RegWrite),
        .ALUSrc             (ALUSrc),
        .AUIPC              (AUIPC),
        .MemWrite           (MemWrite),
        .Branch             (Branch),
        .Jump               (Jump),
        .JumpReg            (JumpReg),
        .ImmSel             (ImmSel),
        .ResultSrc          (ResultSrc),
        .ALUOp              (ALUOp)
    );

    //───────────────────────────────────────────────────\\
    //─────────────── Immediate Generator ───────────────\\
    //───────────────────────────────────────────────────\\
    immediate_generate dut_immediate_generate(
        .ImmSel             (ImmSel),
        .instruction        (instruction),
        .immediate_extend   (immediate)
    );

    //─────────────────────────────────────────────\\
    //─────────────── Register File ───────────────\\
    //─────────────────────────────────────────────\\
    register_file dut_register_file(
        .clk                (clk),
        .reg_write          (RegWrite),
        .rs1                (rs1_add),
        .rs2                (rs2_add),
        .rd                 (rd_add),
        .write_data         (write_data),
        .read_data_1        (read_data_1),
        .read_data_2        (read_data_2)
    );

    //─────────────────────────────────────────────────────────\\
    //──────────────── ALU input A mux (AUIPC) ────────────────\\
    //──────────────── ALU input B mux (ALUSrc) ───────────────\\
    //─────────────────────────────────────────────────────────\\
    mux dut_mux_1(
        .sel                (AUIPC),
        .A                  (read_data_1),
        .B                  (pc),
        .mux_out            (A)
    );

    mux dut_mux_2(
        .sel                (ALUSrc),
        .A                  (read_data_2),
        .B                  (immediate),
        .mux_out            (B)
    );

    //─────────────────────────────────────────\\
    //───────────── ALU Control ───────────────\\
    //─────────────────────────────────────────\\
    alu_control dut_alu_control(
        .ALUOp              (ALUOp),
        .funct7             (funct7),
        .funct3             (funct3),
        .ALUControl         (ALUControl)
    );

    //─────────────────────────────────\\
    //───────────── ALU ───────────────\\
    //─────────────────────────────────\\
    alu dut_alu(
        .A                  (A),
        .B                  (B),
        .ALUControl         (ALUControl),
        .result             (result),
        .zero               (zero)
    );

    //─────────────────────────────────────────\\
    //───────────── Data Memory ───────────────\\
    //─────────────────────────────────────────\\
    data_memory dut_data_memory(
        .clk                (clk),
        .MemWrite           (MemWrite),
        .funct3             (funct3),
        .address            (result),
        .write_data         (read_data_2),
        .read_data          (read_data)
    );

    //────────────────────────────────────────────────────\\
    //───────────── Write Back (ResultSrc) ───────────────\\
    //────────────────────────────────────────────────────\\
    write_back dut_write_back(
        .ResultSrc          (ResultSrc),
        .alu_result         (result),
        .read_data          (read_data),
        .pc_inc             (pc_inc),
        .immediate          (immediate),
        .write_data         (write_data)   
    );

endmodule