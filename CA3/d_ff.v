module d_ff (
    input clk, rst, 
    input d, en,
    output q 
);
    
    s2 s2_d_ff_not_instance(.d00(q), .d01(1'b0), .d10(q), .d11(1'b1), .a1(d), .b1(d), .a0(en), .b0(en), .clr(rst), .clk(clk), .out(q));

endmodule
