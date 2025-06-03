module first_not_and_2bit (
    input a, b,
    output out
);
    
    c1 c1_first_not_and_instance(.a0(1'b0), .a1(1'b0), .sa(a), .b0(1'b1), .b1(1'b0), .sb(a), .s0(b), .s1(b), .out(out));

endmodule


module first_not_and_3bit (
    input a, b, c,
    output out
);
    c1 c1_first_not_and_3bit_instance(.a0(1'b0), .a1(c), .sa(b), .b0(1'b0), .b1(1'b0), .sb(1'b0), .s0(a), .s1(a), .out(out));
    
endmodule


module first_two_not_and_3bit (
    input a, b, c, 
    output out
);

    c1 c1_first_not_and_3bit_instance(.a0(c), .a1(1'b0), .sa(b), .b0(1'b0), .b1(1'b0), .sb(1'b0), .s0(a), .s1(a), .out(out));

endmodule