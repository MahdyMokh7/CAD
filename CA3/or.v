module my_or (
    input a, b,
    output out
);
    c1 c1_my_or_instance(.a0(1'b0), .a1(1'b1), .sa(a), .b0(1'b1), .b1(1'b1), .sb(a), .s0(b), .s1(b), .out(out));
    
endmodule