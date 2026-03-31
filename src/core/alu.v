module alu(
    input wire [31:0] A, B,
    input wire [3:0] ALUControl,
    output reg [31:0] Result,
    output wire zero
);

    assign zero = (Result == 32'b0);

    always @(*) begin
        case (ALUControl)
            4'b0000: Result = A + B;
            4'b0001: Result = A - B;
            4'b0010: Result = A & B;
            4'b0011: Result = A | B;
            4'b0100: Result = A ^ B;
            4'b0101: Result = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0;
            default: Result = 32'b0;
        endcase
    end

endmodule