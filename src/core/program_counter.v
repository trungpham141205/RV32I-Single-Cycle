module program_counter(
    input wire clk, rst,
    input wire [31:0] pc_next,
    output reg [31:0] pc
);

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            pc <= 32'b0;
        end
        else begin
            pc <= pc_next;
        end
    end

endmodule