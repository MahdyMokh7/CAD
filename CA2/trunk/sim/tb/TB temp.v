module TB;

    parameter ADDR_WIDTH = 3;
    parameter DATA_WIDTH = 8;
    parameter PAR_WRITE = 4;
    parameter PAR_READ = 2;

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

    initial begin        // PAR_WRITE > PAR_READ
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

        @(posedge clk);
        wen = 1;
        din = {8'hA2, 8'h34, 8'h98, 8'hAC};
        @(posedge clk);
        wen = 0;

        // valid

        @(posedge clk);
        ren = 1;
        @(posedge clk);
        ren = 0;

        @(posedge clk);
        wen = 1;
        din = {8'h23, 8'h89, 8'hAB, 8'h1D};
        @(posedge clk);
        wen = 0;

        // not ready

        @(posedge clk); // must not write
        wen = 1;
        din = {8'hab, 8'hfc, 8'hc4, 8'h0e};
        @(posedge clk);
        wen = 0;

        @(posedge clk);
        ren = 1;
        @(posedge clk);
        ren = 0;

        // ready

        @(posedge clk); // must write
        wen = 1;
        din = {8'h87, 8'h12, 8'h92, 8'hCF};
        @(posedge clk);
        wen = 0;

        // full

        @(posedge clk); // must not write
        wen = 1;
        din = {8'h19, 8'ha3, 8'hb3, 8'h1f};
        @(posedge clk);
        wen = 0;

        @(posedge clk);
        ren = 1;
        @(posedge clk);
        ren = 0;

        // not full

        @(posedge clk);
        ren = 1;
        @(posedge clk);
        ren = 0;

        // ready

        @(posedge clk); // must write
        wen = 1;
        din = {8'h87, 8'h12, 8'h92, 8'hCF};
        @(posedge clk);
        wen = 0;

        // full

        @(posedge clk);
        ren = 1;
        @(posedge clk);
        ren = 0;

        @(posedge clk);
        ren = 1;
        @(posedge clk);
        ren = 0;

        @(posedge clk);
        ren = 1;
        @(posedge clk);
        ren = 0;

        @(posedge clk);
        ren = 1;
        @(posedge clk);
        ren = 0;

        // empty

        #20;
        $stop;
    end

    // initial begin       // PAR_WRITE < PAR_READ
    //     rstn = 0;
    //     clear = 0;
    //     ren = 0;
    //     wen = 0;
    //     din = 0;

    //     #20;
    //     rstn = 1;
    //     clear = 1;
    //     #10;
    //     clear = 0;

    //     // empty and not valid

    //     @(posedge clk); // must not read
    //     ren = 1;
    //     @(posedge clk);
    //     ren = 0;

    //     @(posedge clk);
    //     wen = 1;
    //     din = {8'h92, 8'hCF};
    //     @(posedge clk);
    //     wen = 0;

    //     @(posedge clk);
    //     wen = 1;
    //     din = {8'hb3, 8'h1f};
    //     @(posedge clk);
    //     wen = 0;

    //     // valid

    //     @(posedge clk);
    //     ren = 1;
    //     @(posedge clk);
    //     ren = 0;

    //     // empty

    //     @(posedge clk); // must not read
    //     ren = 1;
    //     @(posedge clk);
    //     ren = 0;

    //     @(posedge clk);
    //     wen = 1;
    //     din = {8'h92, 8'hCF};
    //     @(posedge clk);
    //     wen = 0;

    //     @(posedge clk);
    //     wen = 1;
    //     din = {8'hc4, 8'h0e};
    //     @(posedge clk);
    //     wen = 0;

    //     // valid

    //     @(posedge clk);
    //     wen = 1;
    //     din = {8'hAB, 8'h1D};
    //     @(posedge clk);
    //     wen = 0;

    //     @(posedge clk);
    //     wen = 1;
    //     din = {8'h98, 8'hAC};
    //     @(posedge clk);
    //     wen = 0;

    //     // full

    //     @(posedge clk);
    //     ren = 1;
    //     @(posedge clk);
    //     ren = 0;

    //     // ready

    //     @(posedge clk);
    //     ren = 1;
    //     @(posedge clk);
    //     ren = 0;

    //     // empty

    //     #20;
    //     $stop;
    // end

endmodule
