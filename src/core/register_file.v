module register_file(
    input wire clk, reg_write,
    input wire [4:0] rs1, rs2, rd,
    input wire [31:0] write_data
);
    
    assign read_data_1 = (rs1 != 0) ? registers[rs1] : 32'b0;
    assign read_data_2 = (rs2 != 0) ? registers[rs2] : 32'b0;

    always @(posedge clk) begin
        if(reg_write != 0 && rd != 5'b0) begin
            registers[rd] <= write_data; 
        end
    end

endmodule
