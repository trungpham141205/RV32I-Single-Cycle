module branch_jump(
    input wire [31:0] pc, rs1, immediate,
    input wire jump_reg,
    output wire [31:0] pc_branch_jump
);

    assign pc_branch_jump = (jump_reg ? rs1 : pc) + immediate;

endmodule