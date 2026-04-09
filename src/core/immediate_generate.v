    module immediate_generate(
    input wire [2:0] ImmSel,
    input wire [31:0] instruction,
    output reg [31:0] immediate_extend
);

    always @(*) begin
        case (ImmSel)
            //──────────────────────────────────────\\
            //─────────────── U Type ───────────────\\
            //──────────────────────────────────────\\
            // Load Upper Immediate (LUI)
            // Add Upper Immediate to PC (AUIPC)
            3'b000:
                immediate_extend = {instruction[31:12], 12'b0}; 
            
            //──────────────────────────────────────\\
            //─────────────── J Type ───────────────\\
            //──────────────────────────────────────\\
            //  Jump and Link (JAL)
            3'b001:
                immediate_extend = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}; 

            //──────────────────────────────────────\\
            //─────────────── B Type ───────────────\\
            //──────────────────────────────────────\\
            // Branch Instructions
            3'b010: 
                immediate_extend = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; 
            
            //──────────────────────────────────────\\
            //─────────────── I Type ───────────────\\
            //──────────────────────────────────────\\
            // Jump and Link Register (JALR)
            // Memory Load Instructions
            // Integer Register - Immediate Instructions
            3'b011: 
                immediate_extend = {{20{instruction[31]}}, instruction[31:20]}; 

            //──────────────────────────────────────\\
            //─────────────── S Type ───────────────\\
            //──────────────────────────────────────\\
            // Memory Store Instructions
            3'b100: 
                immediate_extend = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; 

            //───────────────────────────────────────\\
            //─────────────── Shift I ───────────────\\
            //───────────────────────────────────────\\
            3'b101:
                immediate_extend = {27'b0, instruction[24:20]}; 

            default: immediate_extend = 32'hz;
        endcase
    end

endmodule