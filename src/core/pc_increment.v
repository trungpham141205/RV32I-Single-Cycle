module pc_increment(
    input wire [31:0] pc,
    output wire [31:0] pc_inc
);

    assign pc_inc = pc + 4;

endmodule