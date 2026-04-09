module branch_unit(
    input wire Branch, Jump, JumpReg,
    input wire zero,
    input [31:0] alu_result,
    input wire [2:0] funct3,
    input wire [31:0] pc_branch_jump, pc_inc,
    output reg [31:0] pc_next
);
    wire pc_sel;
    reg branch_sel;

    assign pc_sel = branch_sel | Jump | JumpReg;
    assign pc_next = pc_sel ? pc_branch_jump : pc_inc;

    always @(*) begin
        branch_sel = 1'b0;
        if(Branch) begin
            case (funct3)
                3'b000: branch_sel = zero;
                3'b001: branch_sel = ~zero;
                3'b100,
                3'b110: branch_sel = alu_result[0];
                3'b101,
                3'b111: branch_sel = ~alu_result[0];
                default: branch_sel = 1'b0;
            endcase
        end
    end

endmodule