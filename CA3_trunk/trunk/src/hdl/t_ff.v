module t_ff(
    input clk, rst,
    input t, 
    output q
);

    s2 s2_t_ff_instance(.d00(q), .d01(1'b1), .d10(q), .d11(1'b0), .a1(q), .b1(q), .a0(t), .b0(t), .clr(rst), .clk(clk), .out(q));

endmodule