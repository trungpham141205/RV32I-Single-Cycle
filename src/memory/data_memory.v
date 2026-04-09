module data_memory(
    input wire clk, MemWrite,
    input wire [2:0]funct3,
    input wire [31:0] address, write_data,
    output reg [31:0] read_data
);

    reg [31:0] data_mem [63:0];
    integer i;

    wire [31:0] word = data_mem[address[7:2]];

    always @(posedge clk) begin
        if(MemWrite) begin
            case (funct3)
                3'b000: begin
                    case (address[1:0])
                        2'b00: data_mem[address[7:2]][7:0] <= write_data[7:0];
                        2'b01: data_mem[address[7:2]][15:8] <= write_data[7:0];
                        2'b10: data_mem[address[7:2]][23:16] <= write_data[7:0];
                        2'b11: data_mem[address[7:2]][31:24] <= write_data[7:0];
                    endcase  
                end

                3'b001: begin
                    case (address[1])
                        1'b0: data_mem[address[7:2]][15:0] <= write_data[15:0];
                        1'b1: data_mem[address[7:2]][31:16] <= write_data[15:0];
                    endcase
                end
                
                3'b010: begin
                    data_mem[address[7:2]] <= write_data;
                end

                default: data_mem[address[7:2]] <= data_mem[address[7:2]];
            endcase
        end
    end

    always @(*) begin
        read_data = 32'b0;
        case (funct3)
            3'b000: begin // Load Byte (LB) Load 8-bit
                case (address[1:0])
                    2'b00: read_data = {{24{word[7]}}, word[7:0]}; // Byte 0
                    2'b01: read_data = {{24{word[15]}}, word[15:8]}; // Byte 1
                    2'b10: read_data = {{24{word[23]}}, word[23:16]}; // Byte 2
                    2'b11: read_data = {{24{word[31]}}, word[31:24]}; // Byte 3
                endcase
            end
                

            3'b001: begin // Load Half Word (LH) Load 16-bit
                case (address[1])
                    1'b0: read_data = {{16{word[15]}}, word[15:0]};
                    1'b1: read_data = {{16{word[31]}}, word[31:16]};
                endcase
            end
                

            3'b010: begin // Load Word (LW) Load 32-bit
                read_data = word;
            end
                 
            
            3'b100: begin // Load Byte Unsigned (LB) Load 8-bit Unsigned
                case (address[1:0])
                    2'b00: read_data = {24'b0, word[7:0]}; // Byte 0
                    2'b01: read_data = {24'b0, word[15:8]}; // Byte 1
                    2'b10: read_data = {24'b0, word[23:16]}; // Byte 2
                    2'b11: read_data = {24'b0, word[31:24]}; // Byte 3
                endcase
            end
                
            3'b101: begin // Load Half Word Unsigned (LH) Load 16-bit Unsigned
                case (address[1])
                    1'b0: read_data = {16'b0, word[15:0]};
                    1'b1: read_data = {16'b0, word[31:16]};
                endcase
            end
                
        endcase
    end

endmodule
