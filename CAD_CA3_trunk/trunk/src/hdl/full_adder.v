module full_adder (
    input a, b, cin,
    output sum, cout
);
    wire out_first_xor;

    c1 c1_instance_cout(.a0(1'b0), .a1(cin), .sa(a), .b0(cin), .b1(1'b1), .sb(a), .s0(b), .s1(b), .out(cout));
    my_xor xor_instance_sum_part1( .a(a), .b(b), .out(out_first_xor));
    my_xor xor_instance_sum_part2(.a(out_first_xor), .b(cin), .out(sum));

    
endmodule