module immediate_generate(
    input wire [6:0] opcode,
    input wire [31:0] instruction,
    output reg [31:0] immediate_extend
);

    always @(*) begin
        case (opcode)
            // U Type
            7'b011_0111, // Load Upper Immediate (LUI)
            7'b001_0111: // Add Upper Immediate to PC (AUIPC)
                immediate_extend = {instruction[31:12], 12'b0}; 
            
            // J Type
            7'b110_1111: // Jump and Link (JAL)
                immediate_extend = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}; 

            // B Type
            7'b110_0011: // Branch Instructions
                immediate_extend = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; 
            
            // I Type
            7'b110_0111, // Jump and Link Register (JALR)
            7'b000_0011, // Memory Load Instructions
            7'b001_0011: // Integer Register - Immediate Instructions
                immediate_extend = {{20{instruction[31]}}, instruction[31:20]}; 

            // S Type
            7'b010_0011: // Memory Store Instructions
                immediate_extend = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; 

            default: immediate_extend = 32'b0;
        endcase
    end

endmodule