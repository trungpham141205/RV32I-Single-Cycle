module mux(
    input wire sel,
    input wire [31:0] A, B,
    output wire [31:0] mux_out
);

    assign mux_out = (sel == 1'b0) ? A : B;

endmodule