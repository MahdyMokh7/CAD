module dp (
    input wire clk, rst,
    input wire ld_a, ld_b, shift_en_a, shift_en_b, ld_res, shift_en_res, cnt_en_a, cnt_en_b, cnt_clean_a, cnt_clean_b,
    input wire [15:0] A, B,
    output wire [31:0] res,
    output wire co_A, co_B,
);

    wire [15:0] parOut_A, parOut_B, mult_res;
    wire [2:0] count_A, count_B;

    shiftReg16 shA(clk, rst, shift_en_a, ld_a, A, parOut_A);
    shiftReg16 shB(clk, rst, shift_en_b, ld_b, B, parOut_B);

    mult8 mult(parOut_A[15:8], parOut_B[15:8], mult_res);

    shiftReg32 shRes(clk, rst, shift_en_res, ld_res, {16'b0, mult_res}, parOut_A);

    counter3 counterA(clk, rst, cnt_clean_a, cnt_en_a, co_A, count_A);
    counter3 counterB(clk, rst, cnt_clean_b, cnt_en_b, co_B, count_B);

    counter3 counterCycle(clk, rst, cnt_clean, cnt_en, co, addr);

endmodule