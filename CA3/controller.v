module controller(  // one hot implementation
    input clk, rst, mostA, mostB, co_A, co_B, start,

    output done, ld_a, ld_b, shift_en_a, cnt_en_a, shift_en_b, cnt_en_b, 
    ld_res, shift_en_res
);

    wire idle_not_start_out, idle_start_out;
    wire init_start_out, init_not_start_out;
    wire ZeroCntA_mostA_or_coA, ZeroCntA_not_mostA_or_coA;
    wire ZeroCntB_mostB_or_coB, ZeroCntB_not_mostB_or_coB;
    wire mult_not_shDA, mult_shDA_and_shDB, mult_shDA_and_not_shDB;
    wire addZeroA_not_coA, addZeroA_coA_and_shDB, addZeroA_coA_and_not_shDB;
    wire addZeroB_not_coB, addZeroB_coB;
    wire done_out;


    wire reg_out_Idle, reg_out_Init, reg_out_ZeroCntA, reg_out_ZeroCntB, reg_out_Mult, reg_out_addZeroA, reg_out_addZeroB, reg_out_Done;



    wire mostA_or_coA;
    my_or my_or_mostA_or_coA(.a(mostA), .b(co_A), .out(mostA_or_coA));
    wire mostB_or_coB;
    my_or my_or_mostB_or_coB(.a(mostB), .b(co_B), .out(mostB_or_coB));

    wire shDA, shDB;
    d_ff d_ff_A_instance(.clk(clk), .rst(rst), .d(1'b1), .en(co_A), .q(shDA));
    d_ff d_ff_B_instance(.clk(clk), .rst(rst), .d(1'b1), .en(co_B), .q(shDB));


    // control_block_2to2 Idle(.clk(clk), .rst(rst), .a(idle_not_start_out), .b(done_out), .signal_inp(start), .out(idle_start_out), .n_out(idle_not_start_out), .reg_out(reg_out_Idle));
    control_block_2to2 Init(.clk(clk), .rst(rst), .a(start), .b(init_start_out), .signal_inp(start), .out(init_start_out), .n_out(init_not_start_out), .reg_out(reg_out_Init));
    control_block_2to2 ZeroCntA(.clk(clk), .rst(rst), .a(init_not_start_out), .b(ZeroCntA_not_mostA_or_coA), .signal_inp(mostA_or_coA), .out(ZeroCntA_mostA_or_coA), .n_out(ZeroCntA_not_mostA_or_coA), .reg_out(reg_out_ZeroCntA));
    control_block_2to2 ZeroCntB(.clk(clk), .rst(rst), .a(ZeroCntA_mostA_or_coA), .b(ZeroCntB_not_mostB_or_coB), .signal_inp(mostB_or_coB), .out(ZeroCntB_mostB_or_coB), .n_out(ZeroCntB_not_mostB_or_coB), .reg_out(reg_out_ZeroCntB));

    control_block_1to3 Mult(.clk(clk), .rst(rst), .a(ZeroCntB_mostB_or_coB), .signal_inp1(shDA), .signal_inp2(shDB), .n_out2(mult_not_shDA), .out3(mult_shDA_and_shDB), .n_out3(mult_shDA_and_not_shDB), .reg_out(reg_out_Mult));  // سنگین

    control_block_2to3 addZeroA(.clk(clk), .rst(rst), .a(mult_not_shDA), .b(addZeroA_not_coA), .signal_inp1(co_A), .signal_inp2(shDB), .n_out2(addZeroA_not_coA), .out3(addZeroA_coA_and_shDB), .n_out3(addZeroA_coA_and_not_shDB), .reg_out(reg_out_addZeroA));

    control_block_3to2 addZeroB(.clk(clk), .rst(rst), .a(addZeroA_coA_and_not_shDB), .b(mult_shDA_and_not_shDB), .c(addZeroB_not_coB), .signal_inp(co_B), .out(addZeroB_coB), .n_out(addZeroB_not_coB), .reg_out(reg_out_addZeroB));

    control_block_3to1 Done(.clk(clk), .rst(rst), .a(addZeroB_coB), .b(addZeroA_coA_and_shDB), .c(mult_shDA_and_shDB), .out(done_out), .reg_out(reg_out_Done));


    // outputs of controller
    wire ZeroCntA_cnt_en_a, ZeroCntB_cnt_en_b;
    wire addZeroA_cnt_en_a, addZeroB_cnt_en_b;
    wire addZeroA_shift_en_res, addZeroB_shift_en_res;
    
    assign ld_a = reg_out_Init;
    assign ld_b = reg_out_Init;
    first_not_and_2bit first_not_and_2bit_zeroCountA_shift(.a(mostA), .b(reg_out_ZeroCntA), .out(shift_en_a));
    first_not_and_2bit first_not_and_2bit_zeroCountA_cnt(.a(mostA), .b(reg_out_ZeroCntA), .out(ZeroCntA_cnt_en_a));

    first_not_and_2bit first_not_and_2bit_zeroCountB_shift(.a(mostB), .b(reg_out_ZeroCntB), .out(shift_en_b));
    first_not_and_2bit first_not_and_2bit_zeroCountB_cnt(.a(mostB), .b(reg_out_ZeroCntB), .out(ZeroCntB_cnt_en_b));

    assign ld_res = reg_out_Mult;

    assign addZeroA_shift_en_res = reg_out_addZeroA;
    assign addZeroA_cnt_en_a = reg_out_addZeroA;

    assign addZeroB_shift_en_res = reg_out_addZeroB;
    assign addZeroB_cnt_en_b = reg_out_addZeroB;

    assign done = reg_out_Done;

    my_or my_or_cnt_en_a(ZeroCntA_cnt_en_a, addZeroA_cnt_en_a, cnt_en_a);
    my_or my_or_cnt_en_b(ZeroCntB_cnt_en_b, addZeroB_cnt_en_b, cnt_en_b);

    my_or my_or_shift_en_res(addZeroA_shift_en_res, addZeroB_shift_en_res, shift_en_res);
endmodule