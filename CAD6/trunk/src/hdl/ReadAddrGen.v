module ReadAddrGen #(
    parameter IFMap_ADDR_WIDTH, FILTER_ADDR_WIDTH,
    parameter IFMap_DEPTH, FILTER_DEPTH,
    parameter N_WIDTH
) (
    input clk, rstn,
    input start,
    input valid_IF, valid_filter,
    input stall,
    input [IFMap_ADDR_WIDTH - 1 : 0] stride,
    input [FILTER_ADDR_WIDTH - 1 : 0] filter_size,
    input [N_WIDTH - 1 : 0] n,
    input [1 : 0] mode,
    input [IFMap_ADDR_WIDTH - 1 : 0] start_row, end_row,
    output ren_filter,
    output valid, done,
    output start_row_ren, end_row_ren, end_row_valid,
    output [IFMap_ADDR_WIDTH - 1 : 0] ReadAddrIF,
    output [FILTER_ADDR_WIDTH - 1 : 0] ReadAddrFilter
);
    wire cnt_clr, cnt_en;
    wire start_frame_clr, start_frame_ld;
    wire start_filter_clr, start_filter_ld;
    wire frame_done, filter_done, row_done;

    ReadAddrGenDP #(
        .IFMap_ADDR_WIDTH(IFMap_ADDR_WIDTH),
        .FILTER_ADDR_WIDTH(FILTER_ADDR_WIDTH),
        .IFMap_DEPTH(IFMap_DEPTH),
        .FILTER_DEPTH(FILTER_DEPTH),
        .N_WIDTH(N_WIDTH)
    ) datapath (
        .clk(clk), .rstn(rstn),
        .cnt_clr(cnt_clr), .cnt_en(cnt_en),
        .start_frame_clr(start_frame_clr), .start_frame_ld(start_frame_ld),
        .start_filter_clr(start_filter_clr), .start_filter_ld(start_filter_ld),
        .filter_size(mode == 2'b0 ? filter_size : filter_size * n),
        .stride(stride),
        .n(n), .mode(mode),
        .start_row(start_row), .end_row(end_row), .end_row_valid(end_row_valid),
        .ReadAddrIF(ReadAddrIF), .ReadAddrFilter(ReadAddrFilter),
        .frame_done(frame_done), .filter_done(filter_done), .row_done(row_done)
    );

    ReadAddrGenCtrl ctrl (
        .clk(clk), .rstn(rstn),
        .start(start),
        .valid_IF(valid_IF), .valid_filter(valid_filter), .stall(stall),
        .frame_done(frame_done), .filter_done(filter_done), .row_done(row_done),

        .cnt_clr(cnt_clr), .cnt_en(cnt_en),
        .start_frame_clr(start_frame_clr), .start_frame_ld(start_frame_ld),
        .start_filter_clr(start_filter_clr), .start_filter_ld(start_filter_ld),
        .start_row_ren(start_row_ren), .end_row_ren(end_row_ren),
        .ren_filter(ren_filter),
        .valid(valid), .done(done)
    );
    
endmodule


module ReadAddrGenDP #(
    parameter IFMap_ADDR_WIDTH, FILTER_ADDR_WIDTH,
    parameter IFMap_DEPTH, FILTER_DEPTH,
    parameter N_WIDTH
) (
    input clk, rstn,
    input cnt_clr, cnt_en,
    input start_frame_clr, start_frame_ld,
    input start_filter_clr, start_filter_ld,
    input [IFMap_ADDR_WIDTH - 1 : 0] stride,
    input [FILTER_ADDR_WIDTH - 1 : 0] filter_size,
    input [N_WIDTH - 1 : 0] n,
    input [1 : 0] mode,
    input end_row_valid,
    input [IFMap_ADDR_WIDTH - 1 : 0] start_row, end_row,
    output [IFMap_ADDR_WIDTH - 1 : 0] ReadAddrIF,
    output [FILTER_ADDR_WIDTH - 1 : 0] ReadAddrFilter,
    output frame_done, filter_done, row_done
);
    wire [IFMap_ADDR_WIDTH - 1 : 0] start_frame;
    wire [FILTER_ADDR_WIDTH - 1 : 0] filter_entry, frame_entry, start_filter;

    counter #(
        .ADDR_WIDTH(FILTER_ADDR_WIDTH)
    ) FrameEntry (
        .clk(clk),
        .rstn(rstn),
        .clr(cnt_clr),
        .en(cnt_en),
        .count(filter_entry)
    );
    assign frame_entry = mode[0] ? filter_entry / n : filter_entry;

    step_counter #(
        .ADDR_WIDTH(IFMap_ADDR_WIDTH)
    ) StartFrame (
        .clk(clk),
        .rstn(rstn),
        .clr(start_frame_clr),
        .en(start_frame_ld),
        .step(stride),
        .count(start_frame)
    );

    step_counter #(
        .ADDR_WIDTH(FILTER_ADDR_WIDTH)
    ) StartFilter (
        .clk(clk),
        .rstn(rstn),
        .clr(start_filter_clr),
        .en(start_filter_ld),
        .step(filter_size),
        .count(start_filter)
    );

    assign ReadAddrIF = (start_row + start_frame + frame_entry) % IFMap_DEPTH;
    assign ReadAddrFilter = start_filter + filter_entry;

    assign frame_done = filter_entry == (filter_size - 1);
    assign filter_done = (ReadAddrIF == end_row) & end_row_valid;
    assign row_done = (ReadAddrFilter == (FILTER_DEPTH - 1)) & filter_done;
endmodule


module ReadAddrGenCtrl (
    input clk, rstn,
    input start,
    input valid_IF, valid_filter, stall,
    input frame_done, filter_done, row_done,

    output reg cnt_clr, cnt_en,
    output reg start_frame_clr, start_frame_ld,
    output reg start_filter_clr, start_filter_ld,
    output reg start_row_ren, end_row_ren,
    output reg ren_filter,
    output reg valid, done
);
    parameter Idle = 2'b00, Init = 2'b01, Calc = 2'b10;

    reg [1:0] ps, ns;

    always @(*) begin
        case (ps)
            Idle: ns = start ? Init : Idle;
            Init: ns = start ? Init : Calc;
            Calc: ns = Calc;
        endcase
    end

    always @(*) begin
        {cnt_clr, cnt_en, start_frame_clr, start_frame_ld, start_filter_clr, start_filter_ld, start_row_ren, end_row_ren, ren_filter, valid, done} = 11'b0;
        case (ps)
            Init: {cnt_clr, start_frame_clr, start_filter_clr} = 3'b111;
            Calc: if (valid_IF & valid_filter & ~stall) begin
                {cnt_en, ren_filter, valid} = 3'b111;
                if (frame_done) begin
                    {cnt_clr, done, start_frame_ld} = 3'b111;
                    if (filter_done) begin
                        {start_frame_clr, start_filter_ld} = 2'b11;
                        if (row_done) begin
                            {start_filter_clr, start_row_ren, end_row_ren} = 3'b111;
                        end
                    end
                end
            end
        endcase
    end

    always @(posedge clk, negedge rstn) begin
        if (!rstn)
            ps <= 2'b0;
        else
            ps <= ns;
    end
endmodule