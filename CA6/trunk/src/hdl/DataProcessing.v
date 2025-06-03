module DataProcessing #(
    parameter IFMap_WIDTH, FILTER_WIDTH,
    parameter N_WIDTH
) (
    input clk, rstn,
    input valid, done,
    input stall,
    input [IFMap_WIDTH - 1 : 0] InputFeature,
    input [FILTER_WIDTH - 1 : 0] Filter,
    input [N_WIDTH - 1 : 0] n,
    output valid_mult, done_final,
    output [IFMap_WIDTH - 1 : 0] MultOutReg
);
    wire done_reg, valid_reg;
    wire [IFMap_WIDTH - 1 : 0] InputFeatureReg;

    register #(
        .DATA_WIDTH(IFMap_WIDTH + 2)
    ) input_feature_reg (
        .clk(clk), .rstn(rstn),
        .en(~stall),
        .d({done, valid, InputFeature}),
        .q({done_reg, valid_reg, InputFeatureReg})
    );

    wire overflow;
    wire [IFMap_WIDTH - 1 : 0] MultOut;
    wire [FILTER_WIDTH - 1 : 0] mult_tmp;
    assign {mult_tmp, MultOut} = InputFeatureReg * Filter;
    assign overflow = (|mult_tmp) &
        (mult_tmp[FILTER_WIDTH - 1] != InputFeatureReg[IFMap_WIDTH - 1] ^ Filter[FILTER_WIDTH - 1]); 

    register #(
        .DATA_WIDTH(IFMap_WIDTH + 2)
    ) mult_reg (
        .clk(clk), .rstn(rstn),
        .en(~stall),
        .d({done_reg, valid_reg, MultOut}),
        .q({done_final, valid_mult, MultOutReg})
    );
endmodule