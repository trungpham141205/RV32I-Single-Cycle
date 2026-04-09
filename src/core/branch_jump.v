module branch_jump(
    input wire JumpReg,
    input wire [31:0] pc, rs1, immediate,
    output wire [31:0] pc_branch_jump
);

    assign pc_branch_jump = (JumpReg ? rs1 : pc) + immediate;

endmodule