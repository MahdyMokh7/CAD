module Conv #(
    parameter IFMap_WIDTH, FILTER_WIDTH,
    parameter IFMap_DEPTH, FILTER_DEPTH,
    parameter IFMap_ADDR_WIDTH, FILTER_ADDR_WIDTH,
    parameter N_WIDTH,
    parameter PAR_IN_IF, PAR_IN_Filter, PAR_IN_PSUM,
    parameter PAR_OUT
) (
    input clk, rstn,
    input start,
    input IF_buff_clr, IF_buff_wen,
    input filter_buff_clr, filter_buff_wen,
    input in_Psum_buf_clear, in_Psum_buff_wen,
    input Psum_buff_ren,
    input acc_in_psum,
    input [1 : 0] mode,
    input [N_WIDTH - 1 : 0] n,
    input [IFMap_ADDR_WIDTH - 1 : 0] stride,
    input [FILTER_ADDR_WIDTH - 1 : 0] filter_size,
    input [PAR_IN_IF * (IFMap_WIDTH + 2) - 1 : 0] IFMap,
    input [PAR_IN_Filter * FILTER_WIDTH - 1 : 0] Filter,
    input [PAR_IN_PSUM * IFMap_WIDTH - 1 : 0] InPsum,
    output IF_buff_ready, filter_buff_ready,
    output [PAR_OUT * IFMap_WIDTH - 1 : 0] OutPsum,
    output Psum_buff_valid,
    output in_Psum_buff_ready
);

    wire stall, valid, valid_mult, done, done_final;
    wire [IFMap_WIDTH - 1 : 0] ReadDataIF, Mult;
    wire [FILTER_WIDTH - 1 : 0] ReadDataFilter;

    DataLoader #(
        .IFMap_WIDTH(IFMap_WIDTH), .FILTER_WIDTH(FILTER_WIDTH),
        .IFMap_DEPTH(IFMap_DEPTH), .FILTER_DEPTH(FILTER_DEPTH),
        .IFMap_ADDR_WIDTH(IFMap_ADDR_WIDTH), .FILTER_ADDR_WIDTH(FILTER_ADDR_WIDTH),
        .N_WIDTH(N_WIDTH),
        .PAR_IN_IF(PAR_IN_IF), .PAR_IN_Filter(PAR_IN_Filter)
    ) data_loader (
        .clk(clk), .rstn(rstn),
        .start(start), .stall(stall),
        .IF_buff_clr(IF_buff_clr), .IF_buff_wen(IF_buff_wen),
        .filter_buff_clr(filter_buff_clr), .filter_buff_wen(filter_buff_wen),
        .stride(stride),
        .filter_size(filter_size),
        .n(n),
        .mode(mode),
        .IFMap(IFMap),
        .Filter(Filter),
        .IF_buff_ready(IF_buff_ready), .filter_buff_ready(filter_buff_ready),
        .ReadDataIF(ReadDataIF),
        .ReadDataFilter(ReadDataFilter),
        .valid(valid), .done(done)
    );

    DataProcessing #(
        .IFMap_WIDTH(IFMap_WIDTH), .FILTER_WIDTH(FILTER_WIDTH),
        .N_WIDTH(N_WIDTH)
    ) data_processor (
        .clk(clk), .rstn(rstn),
        .valid(valid), .done(done),
        .stall(stall),
        .InputFeature(ReadDataIF),
        .Filter(ReadDataFilter),
        .n(n),
        .valid_mult(valid_mult), .done_final(done_final),
        .MultOutReg(Mult)
    );

    DataStorer #(
        .IFMap_WIDTH(IFMap_WIDTH),
        .IFMap_DEPTH(IFMap_DEPTH), .FILTER_DEPTH(FILTER_DEPTH),
        .IFMap_ADDR_WIDTH(IFMap_ADDR_WIDTH), .FILTER_ADDR_WIDTH(FILTER_ADDR_WIDTH),
        .N_WIDTH(N_WIDTH),
        .PAR_IN_PSUM(PAR_IN_PSUM), .PAR_OUT(PAR_OUT)
    ) data_storer (
        .clk(clk), .rstn(rstn),
        .v(valid_mult), .done(done_final),
        .Mult(Mult),
        .in_Psum_buf_clear(in_Psum_buf_clear),
        .in_Psum_buff_wen(in_Psum_buff_wen),
        .out_Psum_buff_ren(Psum_buff_ren),
        .InPsum(InPsum),
        .acc_in_psum(acc_in_psum),
        .mode(mode),
        .n(n),
        .stall(stall),
        .OutPsum(OutPsum),
        .in_Psum_buff_ready(in_Psum_buff_ready),
        .out_Psum_buff_valid(Psum_buff_valid)
    );
endmodule