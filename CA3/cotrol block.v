module control_block_2to2 (
    input clk, rst, 
    input a, b,
    input signal_inp,
    output out, n_out,
    output reg_out
);

    s2 s2_control_block_2to2_instance(.d00(1'b0), .d01(1'bx), .d10(1'b1), .d11(1'bx), .a1(a), .b1(b), .a0(1'b0), .b0(1'b0), .clr(rst), .clk(clk), .out(reg_out));

    my_and my_and_control_block_2to2_instance(.a(signal_inp), .b(reg_out), .out(out));
    first_not_and_2bit first_not_and_control_block_2to2_instance(.a(signal_inp), .b(reg_out), .out(n_out));

    
endmodule


// module control_block_1to3 (
//     input clk, rst, 
//     input a,
//     input signal_inp1, // rzA
//     input signal_inp2,  // rzB
//     output out, n_out, nn_out, 
//     output reg_out
// );

//     s2 s2_control_block_1to3_instance(.d00(1'b0), .d01(1'bx), .d10(1'b1), .d11(1'bx), .a1(a), .b1(a), .a0(1'b0), .b0(1'b0), .clr(rst), .clk(clk), .out(reg_out));

//     my_and my_and_control_block_1to3_instance(.a(signal_inp1), .b(reg_out), .out(out));
//     first_not_and_3bit first_not_and_3bit_control_block_1to3_instance(.a(signal_inp1), .b(signal_inp2), .c(reg_out), .out(n_out));
//     first_two_not_and_3bit first_two_not_and_3bit_control_block_1to3_instance(.a(signal_inp1), .b(signal_inp2), .c(reg_out), .out(nn_out));
    
// endmodule

module control_block_1to3 (
    input clk, rst, 
    input a,
    input signal_inp1, // shDA
    input signal_inp2,  // shDB
    output n_out2, out3, n_out3 ,
    output reg_out
);

    s2 s2_control_block_1to3_instance(.d00(1'b0), .d01(1'bx), .d10(1'b1), .d11(1'bx), .a1(a), .b1(a), .a0(1'b0), .b0(1'b0), .clr(rst), .clk(clk), .out(reg_out));

    first_not_and_2bit first_not_and_2bit_control_block_2to3_instance(.a(signal_inp1), .b(reg_out), .out(n_out2));
    my_and_3bit my_and_3bit_control_block_1to3_instance(.a(signal_inp1), .b(signal_inp2), .c(reg_out), .out(out3));
    first_not_and_3bit first_not_and_3bit_control_block_1to3_instance(.a(signal_inp2), .b(signal_inp1), .c(reg_out), .out(n_out3));
    
endmodule


module control_block_2to3 (
    input clk, rst, 
    input a, b,
    input signal_inp1, // coA
    input signal_inp2,  // rzB
    output n_out2, out3, n_out3 ,
    output reg_out
);

    s2 s2_control_block_1to3_instance(.d00(1'b0), .d01(1'bx), .d10(1'b1), .d11(1'bx), .a1(a), .b1(b), .a0(1'b0), .b0(1'b0), .clr(rst), .clk(clk), .out(reg_out));

    first_not_and_2bit first_not_and_2bit_control_block_2to3_instance(.a(signal_inp1), .b(reg_out), .out(n_out2));
    my_and_3bit my_and_3bit_control_block_1to3_instance(.a(signal_inp1), .b(signal_inp2), .c(reg_out), .out(out3));
    first_not_and_3bit first_not_and_3bit_control_block_1to3_instance(.a(signal_inp2), .b(signal_inp1), .c(reg_out), .out(n_out3));
    
endmodule

module control_block_3to2(
    input clk, rst, 
    input a, b, c,
    input signal_inp,
    output out, n_out, 
    output reg_out
);

    s2 s2_control_block_2to2_instance(.d00(1'b0), .d01(1'b1), .d10(1'b1), .d11(1'b1), .a1(a), .b1(b), .a0(c), .b0(c), .clr(rst), .clk(clk), .out(reg_out));

    my_and my_and_control_block_2to2_instance(.a(signal_inp), .b(reg_out), .out(out));
    first_not_and_2bit first_not_and_control_block_2to2_instance(.a(signal_inp), .b(reg_out), .out(n_out));


endmodule


module control_block_3to1(
    input clk, rst, 
    input a, b, c,
    output out,
    output reg_out
);

    s2 s2_control_block_2to2_instance(.d00(1'b0), .d01(1'b1), .d10(1'b1), .d11(1'b1), .a1(a), .b1(b), .a0(c), .b0(c), .clr(rst), .clk(clk), .out(reg_out));
    assign out = reg_out;


endmodule