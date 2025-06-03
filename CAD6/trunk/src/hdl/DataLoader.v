module DataLoader #(
    parameter IFMap_WIDTH, FILTER_WIDTH,
    parameter IFMap_DEPTH, FILTER_DEPTH,
    parameter IFMap_ADDR_WIDTH, FILTER_ADDR_WIDTH,
    parameter N_WIDTH,
    parameter PAR_IN_IF, PAR_IN_Filter
) (
    input clk, rstn,
    input start, stall,
    input IF_buff_clr, IF_buff_wen,
    input filter_buff_clr, filter_buff_wen,
    input [IFMap_ADDR_WIDTH - 1 : 0] stride,
    input [FILTER_ADDR_WIDTH - 1 : 0] filter_size,
    input [N_WIDTH - 1 : 0] n,
    input [1 : 0] mode,
    input [PAR_IN_IF * (IFMap_WIDTH + 2) - 1 : 0] IFMap,
    input [PAR_IN_Filter * FILTER_WIDTH - 1 : 0] Filter,

    output IF_buff_ready, filter_buff_ready,
    output [IFMap_WIDTH - 1 : 0] ReadDataIF,
    output [FILTER_WIDTH - 1 : 0] ReadDataFilter,
    output valid, done
);
    wire wen_IF, wen_filter, ren_filter;
    wire [IFMap_WIDTH + 1 : 0] WriteDataIF;
    wire [FILTER_WIDTH - 1 : 0] WriteDataFilter;
    wire IF_buff_valid, filter_buff_valid;
    wire [IFMap_ADDR_WIDTH - 1 : 0] ReadAddrIF, WriteAddrIF;
    wire [FILTER_ADDR_WIDTH - 1 : 0] ReadAddrFilter, WriteAddrFilter;
    wire ready_IF , valid_IF, ready_filter, valid_filter;
    wire start_row_ren, start_row_wen, start_row_valid, end_row_ren, end_row_wen, end_row_valid;
    wire [IFMap_ADDR_WIDTH - 1 : 0] start_row, end_row;

    FIFO #(    
        .ADDR_WIDTH(IFMap_ADDR_WIDTH),
        .DATA_WIDTH(IFMap_WIDTH + 2),
        .PAR_WRITE(PAR_IN_IF),
        .PAR_READ(1)
    ) IFMapBuff (
        .clk(clk), .rstn(rstn),
        .clear(IF_buff_clr),
        .ren(wen_IF), .wen(IF_buff_wen),
        .din(IFMap),
        .dout(WriteDataIF),
        .ready(IF_buff_ready),
        .valid(IF_buff_valid)
    );

    FIFO #(    
        .ADDR_WIDTH(FILTER_ADDR_WIDTH),
        .DATA_WIDTH(FILTER_WIDTH),
        .PAR_WRITE(PAR_IN_Filter),
        .PAR_READ(1)
    ) FilterBuff (
        .clk(clk), .rstn(rstn),
        .clear(filter_buff_clr),
        .ren(wen_filter), .wen(filter_buff_wen),
        .din(Filter),
        .dout(WriteDataFilter),
        .ready(filter_buff_ready),
        .valid(filter_buff_valid)
    );

    Reg_SPAD #(
        .DATA_WIDTH(IFMap_WIDTH),
        .DEPTH(IFMap_DEPTH),
        .ADDR_WIDTH(IFMap_ADDR_WIDTH)
    ) IFMapSPad (
        .clk(clk), .rstn(rstn),
        .wen(wen_IF),
        .raddr(ReadAddrIF),
        .waddr(WriteAddrIF),
        .din(WriteDataIF[IFMap_WIDTH - 1 : 0]),
        .dout(ReadDataIF)
    );

    SRAM_SPAD #(
        .DATA_WIDTH(FILTER_WIDTH),
        .DEPTH(FILTER_DEPTH),
        .ADDR_WIDTH(FILTER_ADDR_WIDTH)
    ) FilterSPad (
        .clk(clk), .rstn(rstn),
        .chip_en(wen_filter | ren_filter),
        .ren(ren_filter),
        .wen(wen_filter),
        .raddr(ReadAddrFilter),
        .waddr(WriteAddrFilter),
        .din(WriteDataFilter),
        .dout(ReadDataFilter)
    );

    ReadController IFMapReadCtrl (
        .ready(ready_IF), .valid(IF_buff_valid),
        .wen(wen_IF)
    );

    ReadController FilterReadCtrl (
        .ready(ready_filter), .valid(filter_buff_valid),
        .wen(wen_filter)
    );

    bound_counter #(
        .ADDR_WIDTH(IFMap_ADDR_WIDTH),
        .MAX_VALUE(IFMap_DEPTH)
    ) IFMapWriteCounter (
        .clk(clk), .rstn(rstn),
        .clr(1'b0),
        .en(wen_IF),
        .count(WriteAddrIF)
    );

    bound_counter #(
        .ADDR_WIDTH(FILTER_ADDR_WIDTH),
        .MAX_VALUE(FILTER_DEPTH)
    ) FilterWriteCounter (
        .clk(clk), .rstn(rstn),
        .clr(1'b0),
        .en(wen_filter),
        .count(WriteAddrFilter),
        .co(write_cnt_co)
    );

    assign start_row_wen = WriteDataIF[IFMap_WIDTH + 1] & wen_IF;
    assign end_row_wen = WriteDataIF[IFMap_WIDTH] & wen_IF;

    FIFO #(    
        .ADDR_WIDTH(1),
        .DATA_WIDTH(IFMap_ADDR_WIDTH),
        .PAR_WRITE(1),
        .PAR_READ(1)
    ) IFMapStartRow (
        .clk(clk), .rstn(rstn),
        .clear(1'b0),
        .ren(start_row_ren),
        .wen(start_row_wen),
        .din(WriteAddrIF),
        .dout(start_row),
        .valid(start_row_valid)
    );

    FIFO #(    
        .ADDR_WIDTH(1),
        .DATA_WIDTH(IFMap_ADDR_WIDTH),
        .PAR_WRITE(1),
        .PAR_READ(1)
    ) IFMapEndRow (
        .clk(clk), .rstn(rstn),
        .clear(1'b0),
        .ren(end_row_ren),
        .wen(end_row_wen),
        .din(WriteAddrIF),
        .dout(end_row),
        .valid(end_row_valid)
    );

    assign ready_IF = (start_row != WriteAddrIF) | ~start_row_valid;

    wire filter_write_done;
    dff FilterWriteDone (
        .clk(clk),
        .rstn(rstn),
        .en(write_cnt_co),
        .d(1'b1),
        .q(filter_write_done)
    );

    assign ready_filter = ~filter_write_done;

    assign valid_IF = start_row_valid & (end_row_valid | WriteAddrIF != ReadAddrIF);
    assign valid_filter = (WriteAddrFilter != ReadAddrFilter) | filter_write_done;

    ReadAddrGen #(
        .IFMap_ADDR_WIDTH(IFMap_ADDR_WIDTH),
        .FILTER_ADDR_WIDTH(FILTER_ADDR_WIDTH),
        .IFMap_DEPTH(IFMap_DEPTH),
        .FILTER_DEPTH(FILTER_DEPTH),
        .N_WIDTH(N_WIDTH)
    ) read_addr_gen (
        .clk(clk), .rstn(rstn),
        .start(start),
        .valid_IF(valid_IF), .valid_filter(valid_filter),
        .stall(stall),
        .stride(stride),
        .filter_size(filter_size),
        .n(n),
        .mode(mode),
        .start_row(start_row), .end_row(end_row), .end_row_valid(end_row_valid),
        .ren_filter(ren_filter),
        .valid(valid), .done(done),
        .start_row_ren(start_row_ren), .end_row_ren(end_row_ren),
        .ReadAddrIF(ReadAddrIF),
        .ReadAddrFilter(ReadAddrFilter)
    );
endmodule

module tb_data_loader;

    parameter IFMap_WIDTH = 16;
    parameter FILTER_WIDTH = 16;
    parameter IFMap_DEPTH = 12;
    parameter FILTER_DEPTH = 16;
    parameter IFMap_ADDR_WIDTH = 4;
    parameter FILTER_ADDR_WIDTH = 4;
    parameter PAR_IN_IF = 1;
    parameter PAR_IN_Filter = 1;

    reg clk;
    reg rstn;
    reg start;
    reg stall;
    reg IF_buff_clr;
    reg IF_buff_wen;
    reg filter_buff_clr;
    reg filter_buff_wen;
    reg [IFMap_ADDR_WIDTH - 1 : 0] stride;
    reg [FILTER_ADDR_WIDTH - 1 : 0] filter_size;
    reg [PAR_IN_IF * (IFMap_WIDTH + 2) - 1 : 0] IFMap;
    reg [PAR_IN_Filter * FILTER_WIDTH - 1 : 0] Filter;

    wire IF_buff_ready;
    wire filter_buff_ready;
    wire [IFMap_WIDTH - 1 : 0] ReadDataIF;
    wire [FILTER_WIDTH - 1 : 0] ReadDataFilter;
    wire valid;
    wire done;

    DataLoader #(
        .IFMap_WIDTH(IFMap_WIDTH),
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMap_DEPTH(IFMap_DEPTH),
        .FILTER_DEPTH(FILTER_DEPTH),
        .IFMap_ADDR_WIDTH(IFMap_ADDR_WIDTH),
        .FILTER_ADDR_WIDTH(FILTER_ADDR_WIDTH),
        .PAR_IN_IF(PAR_IN_IF),
        .PAR_IN_Filter(PAR_IN_Filter)
    ) dut (
        .clk(clk),
        .rstn(rstn),
        .start(start),
        .stall(stall),
        .IF_buff_clr(IF_buff_clr),
        .IF_buff_wen(IF_buff_wen),
        .filter_buff_clr(filter_buff_clr),
        .filter_buff_wen(filter_buff_wen),
        .stride(stride),
        .filter_size(filter_size),
        .IFMap(IFMap),
        .Filter(Filter),
        .IF_buff_ready(IF_buff_ready),
        .filter_buff_ready(filter_buff_ready),
        .ReadDataIF(ReadDataIF),
        .ReadDataFilter(ReadDataFilter),
        .valid(valid),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rstn = 0;
        start = 0;
        stall = 0;
        IF_buff_clr = 0;
        IF_buff_wen = 0;
        filter_buff_clr = 0;
        filter_buff_wen = 0;
        stride = 4;
        filter_size = 4;
        IFMap = 0;
        Filter = 0;

        #10 rstn = 1;
        start = 1;

        #10 start = 0;
        IF_buff_clr = 1;
        filter_buff_clr = 1;
        #10 IF_buff_clr = 0;
        filter_buff_clr = 0;
        IF_buff_wen = 1;
        filter_buff_wen = 1;
        IFMap = 18'b101111111111011111;
        Filter = 16'b1111111111001001;

        # 10
        IFMap = 18'b000000000000100000;
        Filter = 16'b0000000000001001;

        # 10 IF_buff_wen = 0;
        Filter = 16'b1111111111100100;

        # 10 IF_buff_wen = 1;
        IFMap = 18'b001111111111100111;
        Filter = 16'b0000000000110110;

        # 10
        IFMap = 18'b001111111111011000;
        Filter = 16'b0000000000011110;

        # 10 filter_buff_wen = 0;
        IFMap = 18'b001111111111101001;

        # 10 filter_buff_wen = 1;
        IFMap = 18'b000000000000111110;
        Filter = 16'b1111111111011000;

        # 10
        IFMap = 18'b001111111111100000;
        Filter = 16'b0000000000110100;

        # 10 filter_buff_wen = 0;
        IFMap = 18'b010000000000100011;

        # 10 filter_buff_wen = 1;
        IFMap = 18'b100000000000000101;
        Filter = 16'b0000000000111111;

        # 10 IF_buff_wen = 0;
        Filter = 16'b1111111111000100;

        # 10 IF_buff_wen = 1;
        IFMap = 18'b001111111111101110;
        Filter = 16'b0000000000101110;

        # 10
        IFMap = 18'b000000000000100000;
        Filter = 16'b0000000000011111;

        # 10
        IFMap = 18'b001111111111010000;
        Filter = 16'b0000000000101111;

        # 10
        IFMap = 18'b001111111111001100;
        Filter = 16'b0000000000100100;

        # 10
        IFMap = 18'b001111111111001111;
        Filter = 16'b1111111111101101;

        # 10
        IFMap = 18'b001111111111101111;
        Filter = 16'b1111111111001110;

        # 10
        IFMap = 18'b011111111111001111;
        Filter = 16'b1111111111011011;

        # 10 IF_buff_wen = 0;
        filter_buff_wen = 0;

        #1000 $stop;
    end
endmodule