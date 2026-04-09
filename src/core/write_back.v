module write_back(
    input wire [1:0] ResultSrc,
    input wire [31:0] alu_result, read_data, pc_inc, immediate,
    output wire [31:0] write_data
);

    assign write_data = (ResultSrc == 2'b00) ? result : // R-type, I-type ALU, AUIPC
                        (ResultSrc == 2'b01) ? read_data : // Load
                        (ResultSrc == 2'b10) ? pc_inc : immediate;   

endmodule