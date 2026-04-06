module register_file(
    input wire clk, rst, reg_write,
    input wire [4:0] rs1, rs2, rd,
    input wire [31:0] write_data,
    output wire [31:0] read_data_1, read_data_2
);

    reg [31:0] registers[31:0];
    integer i;
    
    assign read_data_1 = (rs1 != 0) ? registers[rs1] : 32'b0;
    assign read_data_2 = (rs2 != 0) ? registers[rs2] : 32'b0;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            for(i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end
        else if(reg_write != 0 && rd != 5'b0) begin
            registers[rd] <= write_data; 
        end
    end

endmodule