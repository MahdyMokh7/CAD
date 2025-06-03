module DataStorer #(
    parameter IFMap_WIDTH,
    parameter IFMap_DEPTH, FILTER_DEPTH,
    parameter IFMap_ADDR_WIDTH, FILTER_ADDR_WIDTH,
    parameter N_WIDTH,
    parameter PAR_IN_PSUM, PAR_OUT
) (
    input clk, rstn,
    input v, done,
    input [IFMap_WIDTH - 1 : 0] Mult,
    input in_Psum_buf_clear, in_Psum_buff_wen, out_Psum_buff_ren,
    input [IFMap_WIDTH - 1 : 0] InPsum,
    input acc_in_psum,
    input [1:0] mode,
    input [N_WIDTH - 1 : 0] n,
    output stall,
    output [IFMap_WIDTH - 1 : 0] OutPsum,
    output in_Psum_buff_ready, out_Psum_buff_valid
);
    wire [IFMap_WIDTH - 1 : 0] Psum, Psum_reg, InPsumBuff, InSumNew, InSumLoop;
    wire [IFMap_ADDR_WIDTH + FILTER_ADDR_WIDTH - 1 : 0] AddrPsum;
    wire PsumSpad_wen, InPsumBuff_ren, OutPsumBuff_wen;
    wire in_Psum_buf_valid, out_Psum_buff_ready;
    wire in_sum_new_sel, in_sum_loop_sel;
    wire co, ov;

    Reg_SPAD #(
        .DATA_WIDTH(IFMap_WIDTH),
        .DEPTH(IFMap_DEPTH * FILTER_DEPTH),
        .ADDR_WIDTH(IFMap_ADDR_WIDTH + FILTER_ADDR_WIDTH)
    ) PsumSPAD (
        .clk(clk),
        .rstn(rstn),
        .wen(PsumSpad_wen),
        .raddr(AddrPsum),
        .waddr(AddrPsum),
        .din(Psum),
        .dout(Psum_reg)
    );

    FIFO #(    
        .ADDR_WIDTH(IFMap_ADDR_WIDTH + FILTER_ADDR_WIDTH),
        .DATA_WIDTH(IFMap_WIDTH),
        .PAR_WRITE(PAR_IN_PSUM),
        .PAR_READ(1)
    ) InputPsumBuff (
        .clk(clk),
        .rstn(rstn),
        .clear(in_Psum_buf_clear),
        .ren(InPsumBuff_ren),
        .wen(in_Psum_buff_wen),
        .din(InPsum),
        .dout(InPsumBuff),
        .ready(in_Psum_buff_ready),
        .valid(in_Psum_buf_valid)
    );

    FIFO #(    
        .ADDR_WIDTH(IFMap_ADDR_WIDTH + FILTER_ADDR_WIDTH),
        .DATA_WIDTH(IFMap_WIDTH),
        .PAR_WRITE(1),
        .PAR_READ(PAR_OUT)
    ) OutputPsumBuff (
        .clk(clk),
        .rstn(rstn),
        .clear(1'b0),
        .ren(out_Psum_buff_ren),
        .wen(OutPsumBuff_wen),
        .din(Psum),
        .dout(OutPsum),
        .ready(out_Psum_buff_ready),
        .valid(out_Psum_buff_valid)
    );

    WriteAddrGen #(
        .PSUM_ADDR_WIDTH(IFMap_ADDR_WIDTH + FILTER_ADDR_WIDTH),
        .N_WIDTH(N_WIDTH)
    ) PsumAddrGen (
        .clk(clk), .rstn(rstn),
        .v(v), .done(done),
        .in_Psum_buf_valid(in_Psum_buf_valid),
        .out_Psum_buff_ready(out_Psum_buff_ready),
        .acc_in_psum(acc_in_psum),
        .mode(mode),
        .n(n),
        .acc_in_psum_reg(in_sum_new_sel),
        .stall(stall),
        .rst_acc(in_sum_loop_sel),
        .PsumSpad_wen(PsumSpad_wen),
        .InPsumBuff_ren(InPsumBuff_ren),
        .OutPsumBuff_wen(OutPsumBuff_wen),
        .AddrPsum(AddrPsum)
    );

    assign InSumNew = in_sum_new_sel ? InPsumBuff : Mult;
    assign InSumLoop = in_sum_loop_sel ? {IFMap_WIDTH{1'b0}} : Psum_reg;
    assign {co, Psum} = InSumNew + InSumLoop;
    assign ov = (InSumNew[IFMap_WIDTH - 1] & InSumLoop[IFMap_WIDTH - 1] & ~co) |
                (~InSumNew[IFMap_WIDTH - 1] & ~InSumLoop[IFMap_WIDTH - 1] & co);
endmodule

module WriteAddrGen #(
    parameter PSUM_ADDR_WIDTH,
    parameter N_WIDTH
) (
    input clk, rstn,
    input v, done,
    input in_Psum_buf_valid, out_Psum_buff_ready,
    input acc_in_psum,
    input [1 : 0] mode,
    input [N_WIDTH - 1 : 0] n,
    output acc_in_psum_reg,
    output stall,
    output rst_acc,
    output PsumSpad_wen, InPsumBuff_ren, OutPsumBuff_wen,
    output [PSUM_ADDR_WIDTH - 1 : 0] AddrPsum
);
    wire valid, done_reg, co_reg, psum_done, done_cnt_en, acc_cnt_en;

    dff DoneReg (
        .clk(clk),
        .rstn(rstn),
        .en(1'b1),
        .d(done),
        .q(done_reg)
    );

    dff AccInPsumReg (
        .clk(clk),
        .rstn(rstn),
        .en(1'b1),
        .d(acc_in_psum),
        .q(acc_in_psum_reg)
    );

    assign rst_acc = done_reg & ~acc_in_psum_reg;

    wire cnt_clr, cnt_en, cnt_co, cnt_ld;
    counter #(
        .ADDR_WIDTH(PSUM_ADDR_WIDTH)
    ) PsumCounter (
        .clk(clk),
        .rstn(rstn),
        .clr(cnt_clr),
        .ld(cnt_ld),
        .en(cnt_en),
        .par_in(AddrPsum - n + 1),
        .count(AddrPsum),
        .co(cnt_co)
    );

    dff CoReg (
        .clk(clk),
        .rstn(rstn),
        .en(cnt_co),
        .d(1'b1),
        .q(co_reg)
    );

    assign stall = (co_reg & done_reg) | acc_in_psum_reg;
    assign valid = v & ~stall & ~acc_in_psum_reg;
    assign psum_done = done & ~stall & ~acc_in_psum_reg;
    assign done_cnt_en = mode[0] ? valid : psum_done;
    assign acc_cnt_en = in_Psum_buf_valid & out_Psum_buff_ready & acc_in_psum_reg;
    assign cnt_en = done_cnt_en | acc_cnt_en;
    assign cnt_clr = acc_in_psum ^ acc_in_psum_reg;

    assign PsumSpad_wen = valid;
    assign InPsumBuff_ren = acc_cnt_en;
    assign OutPsumBuff_wen = acc_cnt_en;

    wire channel_done;
    wire [N_WIDTH - 1 : 0] channel_cnt;
    counter #(
        .ADDR_WIDTH(N_WIDTH)
    ) ChannelCounter (
        .clk(clk),
        .rstn(rstn),
        .clr(channel_done),
        .en(valid),
        .count(channel_cnt)
    );
    assign channel_done = channel_cnt == (n - 1);
    assign cnt_ld = channel_done & mode[0] & ~done & valid;
endmodule

module tb_data_storer;
    parameter IFMap_WIDTH = 8;
    parameter IFMap_ADDR_WIDTH = 1;
    parameter FILTER_ADDR_WIDTH = 1;
    parameter PAR_OUT = 1;

    reg clk;
    reg rstn;
    reg done;
    reg [IFMap_WIDTH - 1 : 0] Psum;
    reg Psum_buff_ren;

    wire stall;
    wire [PAR_OUT * IFMap_WIDTH - 1 : 0] OutputPsum;
    wire Psum_buff_valid;

    DataStorer #(
        .IFMap_WIDTH(IFMap_WIDTH),
        .IFMap_ADDR_WIDTH(IFMap_ADDR_WIDTH),
        .FILTER_ADDR_WIDTH(FILTER_ADDR_WIDTH),
        .PAR_OUT(PAR_OUT)
    ) dut (
        .clk(clk),
        .rstn(rstn),
        .done(done),
        .Psum(Psum),
        .Psum_buff_ren(Psum_buff_ren),
        .stall(stall),
        .OutputPsum(OutputPsum),
        .Psum_buff_valid(Psum_buff_valid)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rstn = 0;
        done = 0;
        Psum = 0;
        Psum_buff_ren = 0;

        #10 rstn = 1;

        #10 done = 1;
        Psum = 8'hAA;
        #10
        Psum = 8'hBB;

        #10
        Psum = 8'hCC;

        #10
        Psum = 8'hDD;

        #10
        Psum = 8'hEE;

        #10
        Psum = 8'hFF;

        #10 done = 0;
        Psum_buff_ren = 1;

        #50 $stop;
    end
endmodule

