module TB;
    parameter IFMap_WIDTH = 16;
    parameter FILTER_WIDTH = 16;
    parameter IFMap_DEPTH = 5;
    parameter FILTER_DEPTH = 6; /////////
    parameter IFMap_ADDR_WIDTH = 3;
    parameter FILTER_ADDR_WIDTH = 3;
    parameter PAR_IN_IF = 1;
    parameter PAR_IN_Filter = 1;
    parameter PAR_IN_PSUM = 1;
    parameter PAR_OUT = 1;
    parameter N_WIDTH = 2;

    reg clk;
    reg rstn;
    reg start;
    reg IF_buff_clr;
    reg IF_buff_wen;
    reg filter_buff_clr;
    reg filter_buff_wen;
    reg in_Psum_buff_wen;
    reg Psum_buff_ren;
    reg acc_in_psum;
    reg [1 : 0] mode;
    reg [N_WIDTH - 1 : 0] n;
    reg [IFMap_ADDR_WIDTH - 1 : 0] stride;
    reg [FILTER_ADDR_WIDTH - 1 : 0] filter_size;
    reg [PAR_IN_IF * (IFMap_WIDTH + 2) - 1 : 0] IFMap;
    reg [PAR_IN_Filter * FILTER_WIDTH - 1 : 0] Filter;
    reg [PAR_IN_PSUM * IFMap_WIDTH - 1 : 0] InPsum;

    wire IF_buff_ready;
    wire filter_buff_ready;
    wire [PAR_OUT * IFMap_WIDTH - 1 : 0] OutPsum;
    wire Psum_buff_valid, in_Psum_buff_ready;

    Conv #(
        .IFMap_WIDTH(IFMap_WIDTH),
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMap_DEPTH(IFMap_DEPTH),
        .FILTER_DEPTH(FILTER_DEPTH),
        .IFMap_ADDR_WIDTH(IFMap_ADDR_WIDTH),
        .FILTER_ADDR_WIDTH(FILTER_ADDR_WIDTH),
        .N_WIDTH(N_WIDTH),
        .PAR_IN_IF(PAR_IN_IF),
        .PAR_IN_Filter(PAR_IN_Filter),
        .PAR_IN_PSUM(PAR_IN_PSUM),
        .PAR_OUT(PAR_OUT)
    ) dut (
        .clk(clk),
        .rstn(rstn),
        .start(start),
        .IF_buff_clr(IF_buff_clr),
        .IF_buff_wen(IF_buff_wen),
        .filter_buff_clr(filter_buff_clr),
        .filter_buff_wen(filter_buff_wen),
        .in_Psum_buf_clear(1'b0),
        .in_Psum_buff_wen(in_Psum_buff_wen),
        .Psum_buff_ren(Psum_buff_ren),
        .acc_in_psum(acc_in_psum),
        .mode(mode - 1),
        .n(n),
        .stride(stride),
        .filter_size(filter_size),
        .IFMap(IFMap),
        .Filter(Filter),
        .InPsum(InPsum),
        .IF_buff_ready(IF_buff_ready),
        .filter_buff_ready(filter_buff_ready),
        .OutPsum(OutPsum),
        .Psum_buff_valid(Psum_buff_valid),
        .in_Psum_buff_ready(in_Psum_buff_ready)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rstn = 0;
        start = 0;
        IF_buff_clr = 0;
        IF_buff_wen = 0;
        filter_buff_clr = 0;
        filter_buff_wen = 0;
        Psum_buff_ren = 0;
        stride = 1;
        filter_size = 3; /////
        acc_in_psum = 0;
        mode = 2; //////
        n = 2; //////
        IFMap = 0;
        Filter = 0;

        #10 rstn = 1;
        start = 1;
        Psum_buff_ren = 1;

        #10 start = 0;
        IF_buff_clr = 1;
        filter_buff_clr = 1;
        #10 IF_buff_clr = 0; filter_buff_clr = 0; filter_buff_wen = 1;
        Filter = -16'd43;

        # 10
        Filter = 16'd3;

        # 10
        Filter = 16'd18;

        # 10
        Filter = -16'd30;

        # 10
        Filter = -16'd41;

        # 10
        Filter = -16'd34;

        # 10 filter_buff_wen = 0; IF_buff_wen = 1;
        IFMap = {2'b10, 16'd161};

        # 10
        IFMap = {2'b00, 16'd190};

        # 10
        IFMap = {2'b00, -16'd161};

        # 10
        IFMap = {2'b00, -16'd81};

        # 10
        IFMap = {2'b01, 16'd50};

        # 10 IF_buff_wen = 0;
        
        #1000 $stop;
    end
endmodule
