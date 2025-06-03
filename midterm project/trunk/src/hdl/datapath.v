module datapath (
    input [7:0] X,
    input clk,
    input rst,
    input [2:0] N,

    input sel_mux0_1_0,
    input sel_mux0_2_0,
    input sel_mux0_3_0,
    input sel_mux0_4_0,
    input sel_mux0_5_0,
    input sel_mux0_6_0,
    // input sel_mux0_7_0,   ////////////////// add in controller top
    input sel_mux1_1_1,
    input sel_mux2_1_2,
    input sel_mux3_1_3,

    input en_all,

    // input wire en_counter_main,
    // input wire init_counter_main,
    // output wire [2:0] out_counter_main;

    output [31:0] Y,
    output valid_ans,
    output ov_ans
    // output error

);

    // one en for all the enables
    wire en_reg0_xn, en_reg0_tillnow, en_reg0_total, en_reg1_xn, en_reg1_tillnow, en_reg1_total, en_reg2_xn, en_reg2_tillnow, en_reg2_total, en_reg3_xn, en_reg3_tillnow, en_reg3_total;

    assign en_reg0_xn = en_all;
    assign en_reg0_tillnow = en_all;
    assign en_reg0_total = en_all;
    assign en_reg1_xn = en_all;
    assign en_reg1_tillnow = en_all;
    assign en_reg1_total = en_all;
    assign en_reg2_xn = en_all;
    assign en_reg2_tillnow = en_all;
    assign en_reg2_total = en_all;
    assign en_reg3_xn = en_all;
    assign en_reg3_tillnow = en_all;
    assign en_reg3_total = en_all;

    // ovs
    wire ov_in_0;
    wire ov1_0;
    wire ov2_0;
    wire ov3_0;
    wire ov_out_reg_0;

    wire ov_in_1;
    wire ov1_1;
    wire ov2_1;
    wire ov3_1;
    wire ov_out_reg_1;

    wire ov_in_2;
    wire ov1_2;
    wire ov2_2;
    wire ov3_2;
    wire ov_out_reg_2;

    wire ov_in_3;
    wire ov1_3;
    wire ov2_3;
    wire ov3_3;
    wire ov_out_reg_3;

    // cnts
    wire cnt_out_0;
    wire cnt_out_1;
    wire cnt_out_2;
    wire cnt_out_3;

    // valids
    wire valid_out_reg_0, valid_out_reg_1, valid_out_reg_2, valid_out_reg_3;
    wire valid_in_reg_0, valid_in_reg_1, valid_in_reg_2, valid_in_reg_3;

    // errors 
    wire error_out_reg_0, error_out_reg_1, error_out_reg_2, error_out_reg_3;

    // 32-bit wires for register 0
    wire [15:0] out_mux0_1_0;
    wire [15:0] out_mux0_2_0;
    wire [15:0] out_mux0_3_0;
    wire [31:0] out_mux0_4_0;
    wire [2:0] out_mux0_5_0;
    wire out_mux0_6_0;  // ov 
    wire out_mux0_7_0;  // error 

    wire [31:0] out_mult1_0;
    wire [31:0] out_mult2_0;
    wire [31:0] out_add_0;

    wire [15:0] out_reg_untilnow_0;
    wire [15:0] out_reg_total_0;
    wire [31:0] out_reg_xn_0;
    
    // 32-bit wires for register 1
    wire [31:0] out_mux1_1_1;

    wire [31:0] out_mult1_1;
    wire [31:0] out_mult2_1;
    wire [31:0] out_add_1;

    wire [15:0] out_reg_untilnow_1;
    wire [15:0] out_reg_total_1;
    wire [31:0] out_reg_xn_1;
    
    // 32-bit wires for register 2
    wire [31:0] out_mux2_1_2;

    wire [31:0] out_mult1_2;
    wire [31:0] out_mult2_2;
    wire [31:0] out_add_2;

    wire [15:0] out_reg_untilnow_2;
    wire [15:0] out_reg_total_2;
    wire [31:0] out_reg_xn_2;
    
    // 32-bit wires for register 3
    wire [31:0] out_mux3_1_3;

    wire [31:0] out_mult1_3;
    wire [31:0] out_mult2_3;
    wire [31:0] out_add_3;

    wire [15:0] out_reg_untilnow_3;
    wire [15:0] out_reg_total_3;
    wire [31:0] out_reg_xn_3;

    wire N_mod4_out;
    wire X_16bit;

    wire [31:0] out_rom [0:7];

    rom my_rom0 (.addr(3'b000), .data(out_rom[0]));
    rom my_rom1 (.addr(3'b001), .data(out_rom[1]));
    rom my_rom2 (.addr(3'b010), .data(out_rom[2]));
    rom my_rom3 (.addr(3'b011), .data(out_rom[3]));
    rom my_rom4 (.addr(3'b100), .data(out_rom[4]));
    rom my_rom5 (.addr(3'b101), .data(out_rom[5]));
    rom my_rom6 (.addr(3'b110), .data(out_rom[6]));
    rom my_rom7 (.addr(3'b111), .data(out_rom[7]));

    // valids (equals)
    equal eq0(.N(N), .cnt(out_mux0_5_0), .valid(valid_in_reg_0));
    equal eq1(.N(N), .cnt(cnt_out_0), .valid(valid_in_reg_1));
    equal eq2(.N(N), .cnt(cnt_out_1), .valid(valid_in_reg_2));
    equal eq3(.N(N), .cnt(cnt_out_2), .valid(valid_in_reg_3));


    assign ov_in_0 = ov1_0 | ov2_0 | ov3_0 | out_mux0_6_0;  // for each one i should add a ""ov prev"" step as well
    assign ov_in_1 = ov1_1 | ov2_1 | ov3_1 | ov_out_reg_0;  // for each one i should add a ""ov prev"" step as well
    assign ov_in_2 = ov1_2 | ov2_2 | ov3_2 | ov_out_reg_1;  // for each one i should add a ""ov prev"" step as well
    assign ov_in_3 = ov1_3 | ov2_3 | ov3_3 | ov_out_reg_2;  // for each one i should add a ""ov prev"" step as well

    assign X_16bit = {X, 8'b0};

    // 1st unit
    mux2to1_16bit mux0_1(.a(16'b1), .b(out_reg_xn_3/*ازونور*/), .sel(sel_mux0_1_0), .out(out_mux0_1_0));
    mux2to1_16bit mux0_2(.a(X_16bit), .b(out_reg_total_3/*ازونور*/), .sel(sel_mux0_2_0), .out(out_mux0_2_0));
    mux2to1_16bit mux0_3(.a(out_rom[0]), .b(out_rom[4]), .sel(sel_mux0_3_0), .out(out_mux0_3_0));
    mux2to1 mux0_4(.a(32'b0), .b(out_reg_untilnow_3/*ازونور*/), .sel(sel_mux0_4_0), .out(out_mux0_4_0));
    mux2to1_3bit mux0_5(.a(3'b0), .b(cnt_out_3 + 3'b1/*ازونور*/), .sel(sel_mux0_5_0), .out(out_mux0_5_0));
    mux2to1_1bit mux0_6(.a(1'b0), .b(ov_out_reg_3), .sel(sel_mux0_6_0), .out(out_mux0_6_0));
    // mux2to1_1bit mux0_7(.a(), .b(error_out_reg_3), .sel(sel_mux0_6_0), .out(out_mux0_6_0));


    mult mult1_0(.a(out_mux0_1_0), .b(out_mux0_2_0), .result(out_mult1_0), .overflow(ov1_0));
    mult mult2_0(.a(out_mult1_0[31:16]), .b(out_mux0_3_0), .result(out_mult2_0), .overflow(ov2_0));
    adder add_0(.a(out_mux0_4_0), .b(out_mult2_0), .result(out_add_0), .overflow(ov3_0));

    register reg_xn_0(.clk(clk), .rst(rst), .data_in(out_mult1_0[31:16]), .en(en_reg0_xn), .data_out(out_reg_xn_0));
    register reg_untilnow_0(.clk(clk), .rst(rst), .data_in(out_add_0), .en(en_reg0_tillnow), .data_out(out_reg_untilnow_0));
    register_signals reg_total_0(.clk(clk), .rst(rst), .en(en_reg0_xn), .x_in(out_mux0_2_0), .valid_in(valid_in_reg_0), .overflow_in(ov_in_0), .cnt_in(out_mux0_5_0), .x_out(out_reg_total_0), .valid_out(valid_out_reg_0), .overflow_out(ov_out_reg_0), .cnt_out(cnt_out_0));  // all the controller signals should get added

    // 2nd unit
    mux2to1_16bit mux1_1(.a(out_rom[1]), .b(out_rom[5]), .sel(sel_mux1_1_1), .out(out_mux1_1_1));

    mult mult1_1(.a(out_reg_xn_0), .b(out_reg_total_0), .result(out_mult1_1), .overflow(ov1_1));
    mult mult2_1(.a(out_mult1_1), .b(out_mux1_1_1), .result(out_mult2_1), .overflow(ov2_1));
    adder add_1(.a(out_reg_untilnow_0), .b(out_mult2_1), .result(out_add_1), .overflow(ov3_1));

    register reg_xn_1(.clk(clk), .rst(rst), .data_in(out_mult1_1[31:16]), .en(en_reg1_xn), .data_out(out_reg_xn_1));
    register reg_untilnow_1(.clk(clk), .rst(rst), .data_in(out_add_1), .en(en_reg1_tillnow), .data_out(out_reg_untilnow_1));
    register_signals reg_total_1(.clk(clk), .rst(rst), .en(en_reg1_xn), .x_in(out_reg_total_0), .valid_in(valid_in_reg_1), .overflow_in(ov_in_1), .cnt_in(cnt_out_0 + 3'b1), .x_out(out_reg_total_1), .valid_out(valid_out_reg_1), .overflow_out(ov_out_reg_1), .cnt_out(cnt_out_1));  // all the controller signals should get added

    // 3rd unit
    mux2to1_16bit mux2_1(.a(out_rom[2]), .b(out_rom[6]), .sel(sel_mux2_1_2), .out(out_mux2_1_2));

    mult mult1_2(.a(out_reg_xn_1), .b(out_reg_total_1), .result(out_mult1_2[31:16]), .overflow(ov1_2));
    mult mult2_2(.a(out_mult1_2), .b(out_mux2_1_2), .result(out_mult2_2), .overflow(ov2_2));
    adder add_2(.a(out_reg_untilnow_1), .b(out_mult2_2), .result(out_add_2), .overflow(ov3_2));

    register reg_xn_2(.clk(clk), .rst(rst), .data_in(out_mult1_2), .en(en_reg2_xn), .data_out(out_reg_xn_2));
    register reg_untilnow_2(.clk(clk), .rst(rst), .data_in(out_add_2), .en(en_reg2_tillnow), .data_out(out_reg_untilnow_2));
    register_signals reg_total_2(.clk(clk), .rst(rst), .en(en_reg2_xn), .x_in(out_reg_total_1), .valid_in(valid_in_reg_2), .overflow_in(ov_in_2), .cnt_in(cnt_out_1 + 3'b1), .x_out(out_reg_total_2), .valid_out(valid_out_reg_2), .overflow_out(ov_out_reg_2), .cnt_out(cnt_out_2));  // all the controller signals should get added

    // 4th unit
    mux2to1 mux3_1(.a(out_rom[3]), .b(out_rom[7]), .sel(sel_mux3_1_3), .out(out_mux3_1_3));

    mult mult1_3(.a(out_reg_xn_2), .b(out_reg_total_2), .result(out_mult1_3[31:16]), .overflow(ov1_3));
    mult mult2_3(.a(out_mult1_3), .b(out_mux3_1_3), .result(out_mult2_3), .overflow(ov2_3));
    adder add_3(.a(out_reg_untilnow_2), .b(out_mult2_3), .result(out_add_3), .overflow(ov3_3));

    register reg_xn_3(.clk(clk), .rst(rst), .data_in(out_mult1_3), .en(en_reg3_xn), .data_out(out_reg_xn_3));
    register reg_untilnow_3(.clk(clk), .rst(rst), .data_in(out_add_3), .en(en_reg3_tillnow), .data_out(out_reg_untilnow_3));
    register_signals reg_total_3(.clk(clk), .rst(rst), .en(en_reg3_xn), .x_in(out_reg_total_2), .valid_in(valid_in_reg_3), .overflow_in(ov_in_3), .cnt_in(cnt_out_2 + 3'b1), .x_out(out_reg_total_3), .valid_out(valid_out_reg_3), .overflow_out(ov_out_reg_3), .cnt_out(cnt_out_3));  // all the controller signals should get added


    mod4_calculator mod(.in(N), .out(N_mod4_out));
    mux4to1 ans(.in0(out_reg_total_0), .in1(out_reg_total_1), .in2(out_reg_total_2), .in3(out_reg_total_3), .sel(N_mod4_out), .out(Y));
    mux4to1_1bit ans_of_valid(.in0(valid_out_reg_0), .in1(valid_out_reg_1), .in2(valid_out_reg_2), .in3(valid_out_reg_3), .sel(N_mod4_out), .out(valid_ans));
    mux4to1_1bit ans_of_ov(.in0(ov_out_reg_0), .in1(ov_out_reg_1), .in2(ov_out_reg_2), .in3(ov_out_reg_3), .sel(N_mod4_out), .out(ov_ans));
    // mux4to1_1bit ans_of_error(.in0(error_out_reg_0), .in1(error_out_reg_1), .in2(error_out_reg_2), .in3(error_out_reg_3), .sel(N_mod4_out), .out(ov_ans));


endmodule
