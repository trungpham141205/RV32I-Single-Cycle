module program_counter(
    input wire clk, rst,
    input wire [31:0] PC_next,
    output reg [31:0] PC
);

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            PC <= 32'b0;
        end
        else begin
            PC <= PC_next;
        end
    end

endmodule