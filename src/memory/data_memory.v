module data_memory(
    input wire clk, rst, MemWrite,
    input wire [31:0] address, write_data,
    output wire [31:0] read_data
);

    reg [31:0] data_mem [63:0];
    integer i;

    assign read_data = data_mem[address[7:2]];

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            for (i = 0; i < 64; i = i + 1) begin
                data_mem[i] <= 32'b0;
            end
        end
        else if(MemWrite) begin
            data_mem[address[7:2]] <= write_data;
        end
    end

endmodule
