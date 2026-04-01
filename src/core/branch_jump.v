module branch_jump(
    input wire [31:0] pc, rs1, immediate,
    input wire jump,
    output wire [31:0] pc_branch_jump
);

    assign pc_branch_jump = pc + (jump ? rs1 : immediate);

endmodule