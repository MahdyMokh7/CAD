module DataPath (
    input wire clk, rst, ld_a, ld_b, shift_en_a, shift_en_b, ld_res, shift_en_res,
    input wire cnt_en_a, cnt_en_b,
    input wire [15:0] A, B,
    output wire [31:0] res,
    output wire co_A, co_B, mostA, mostB
);

    wire [15:0] parOut_A, parOut_B, mult_res;
    wire [2:0] count_A, count_B;

    wire out_shiftA, out_shiftB, out_shift_res;

    shiftreg_16bit shA(.clk(clk), .rst(rst), .sh_en(shift_en_a), .ld(ld_a), .par_in(A), .out_shift(out_shiftA), .par_out(parOut_A));
    shiftreg_16bit shB(.clk(clk), .rst(rst), .sh_en(shift_en_b), .ld(ld_b), .par_in(B), .out_shift(out_shiftB), .par_out(parOut_B));

    mult8 mult(.A(parOut_A[15:8]), .B(parOut_B[15:8]), .P(mult_res));

    shiftreg_32bit shRes(.clk(clk), .rst(rst), .sh_en(shift_en_res), .ld(ld_res), .par_in({16'b0, mult_res}), .out_shift(out_shift_res), .par_out(res));

    counter_3bit counterA(.clk(clk), .rst(rst), .cnt_en(cnt_en_a), .carry_out(co_A), .count(count_A));
    counter_3bit counterB(.clk(clk), .rst(rst), .cnt_en(cnt_en_b), .carry_out(co_B), .count(count_B));

    assign mostA = parOut_A[15];
    assign mostB = parOut_B[15];

endmodule