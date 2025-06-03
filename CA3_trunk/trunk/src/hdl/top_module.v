module TopModule(
    input clk, rst, start,
    input [15:0] A, B,
    output done,
    output [31:0] res
);
    wire ld_a, ld_b, 
        shift_en_a, shift_en_b, ld_res, shift_en_res,
        cnt_en_a, cnt_en_b,
        co_A, co_B, 
        mostA, mostB;
    

    DataPath dp(.clk(clk), .rst(rst), .ld_a(ld_a), .ld_b(ld_b), .shift_en_a(shift_en_a), .shift_en_b(shift_en_b), .ld_res(ld_res), .shift_en_res(shift_en_res),
        .cnt_en_a(cnt_en_a), .cnt_en_b(cnt_en_b), 
        .A(A), .B(B), .res(res), .co_A(co_A), .co_B(co_B), .mostA(mostA), .mostB(mostB)
    );

    controller ctrl(.clk(clk), .rst(rst), .mostA(mostA), .mostB(mostB), .co_A(co_A), .co_B(co_B), .start(start), 
        .done(done), .ld_a(ld_a), .ld_b(ld_b), 
        .shift_en_a(shift_en_a), .cnt_en_a(cnt_en_a), .shift_en_b(shift_en_b), .cnt_en_b(cnt_en_b), 
        .ld_res(ld_res), .shift_en_res(shift_en_res)
    );

endmodule