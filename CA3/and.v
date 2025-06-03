module my_and(
    input a, b,
    output out
);
    c1 instance_and(.a0(1'b0), .a1(1'b0), .sa(a), .b0(1'b0), .b1(1'b1), .sb(a), .s0(b), .s1(b), .out(out));

endmodule


module my_and_3bit(
    input a, b, c,
    output out
);

    c1 instance_and_3bit(.a0(1'b0), .a1(1'b0), .sa(1'b0), .b0(1'b0), .b1(c), .sb(b), .s0(a), .s1(a), .out(out));
    
endmodule