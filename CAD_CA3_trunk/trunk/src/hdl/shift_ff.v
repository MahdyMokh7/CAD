module shift_ff (
    input clk, rst,
    input sh_en, ld,
    input in,
    input in_shift,
    output out
);

    s2 s2_instance(.d00(out), .d01(in_shift), .d10(in), .d11(in),
    .a1(ld), .b1(ld),
    .a0(sh_en), .b0(sh_en),
    .clr(rst),
    .clk(clk),
    .out(out));

endmodule