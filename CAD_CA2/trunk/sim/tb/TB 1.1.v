module TB;

    parameter ADDR_WIDTH = 2;
    parameter DATA_WIDTH = 8;
    parameter PAR_WRITE = 1;
    parameter PAR_READ = 1;

    reg clk;
    reg rstn;
    reg clear;
    reg ren;
    reg wen;
    reg [PAR_WRITE * DATA_WIDTH - 1 : 0] din;

    wire [PAR_READ * DATA_WIDTH - 1 : 0] dout;
    wire full;
    wire empty;
    wire ready;
    wire valid;

    FIFO #(ADDR_WIDTH, DATA_WIDTH, PAR_WRITE, PAR_READ) uut (
        .clk(clk),
        .rstn(rstn),
        .clear(clear),
        .ren(ren),
        .wen(wen),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty),
        .ready(ready),
        .valid(valid)
    );

    initial begin
        clk = 1;
        forever #5 clk = ~clk;
    end

    initial begin
        rstn = 0;
        clear = 0;
        ren = 0;
        wen = 0;
        din = 0;

        #20;
        rstn = 1;
        clear = 1;
        #10;
        clear = 0;

        @(posedge clk); //1
        wen = 1;
        ren = 0;
        din = 8'd8;

        @(posedge clk); //2
        wen = 0;
        ren = 1;
        din = 8'd8;

        @(posedge clk); //3
        wen = 0;
        ren = 1;
        din = 8'd8;

        @(posedge clk); //4
        wen = 1;
        ren = 1;
        din = 8'd12;

        @(posedge clk); //5
        wen = 1;
        ren = 1;
        din = 8'd5;

        @(posedge clk); //6
        wen = 1;
        ren = 1;
        din = 8'd7;

        @(posedge clk); //7
        wen = 0;
        ren = 1;
        din = 8'd7;

        @(posedge clk); //8
        wen = 0;
        ren = 1;
        din = 8'd7;

        @(posedge clk); //9
        wen = 0;
        ren = 1;
        din = 8'd7;

        #20;
        $stop;
    end

endmodule
