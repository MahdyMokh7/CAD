module top_module (
    input [7:0] X,
    input [2:0] N,
    input clk,
    input rst,
    input start,

    output [31:0] Y,
    output valid,
    output ready,
    output overflow,
    output error
);  

    wire sel_mux0_1_0;
    wire sel_mux0_2_0;
    wire sel_mux0_3_0;
    wire sel_mux0_4_0;
    wire sel_mux0_5_0;
    wire sel_mux0_6_0;
    wire sel_mux1_1_1;
    wire sel_mux2_1_2;
    wire sel_mux3_1_3;

    wire en_all;


    datapath dp(.X(X), .clk(clk), .rst(rst), .N(N), 
    .sel_mux0_1_0(sel_mux0_1_0), .sel_mux0_2_0(sel_mux0_2_0), .sel_mux0_3_0(sel_mux0_3_0), .sel_mux0_4_0(sel_mux0_4_0), 
    .sel_mux0_5_0(sel_mux0_5_0), .sel_mux0_6_0(sel_mux0_6_0), .sel_mux1_1_1(sel_mux1_1_1), .sel_mux2_1_2(sel_mux2_1_2), 
    .sel_mux3_1_3(sel_mux3_1_3), .en_all(en_all), .Y(Y), .valid_ans(valid), .ov_ans(overflow));


    controller ct(.clk(clk), .rst(rst), .N(N), .start(start), .ready(ready), 
    .sel_mux0_1_0(sel_mux0_1_0), .sel_mux0_2_0(sel_mux0_2_0), .sel_mux0_3_0(sel_mux0_3_0), 
    .sel_mux0_4_0(sel_mux0_4_0), .sel_mux0_5_0(sel_mux0_5_0),  .sel_mux0_6_0(sel_mux0_6_0), 
    .sel_mux1_1_1(sel_mux1_1_1), .sel_mux2_1_2(sel_mux2_1_2), .sel_mux3_1_3(sel_mux3_1_3), 
    .en_all(en_all));


endmodule
