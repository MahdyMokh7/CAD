`define LAST_OP_WRITE 1
`define LAST_OP_READ 0

module FIFO #(    
    parameter ADDR_WIDTH,
    parameter DATA_WIDTH,
    parameter PAR_WRITE,
    parameter PAR_READ
)(
    input clk,
    input rstn,
    input clear,
    input ren,
    input wen,
    input [PAR_WRITE * DATA_WIDTH - 1 : 0] din,
    output [PAR_READ * DATA_WIDTH - 1 : 0] dout,
    output full,
    output empty,
    output ready,
    output valid
);
    reg [ADDR_WIDTH - 1 : 0] waddr; // write pointer
    reg [ADDR_WIDTH - 1 : 0] raddr; // read pointer
    reg last_op;

    wire do_w, do_r;
    wire [0 : PAR_WRITE - 1] is_any_equal_w;
    wire [0 : PAR_READ - 1] is_any_equal_r;

    assign do_w = wen & ready;
    assign do_r = ren & valid;

    genvar i, j;
    generate
        for (i = 0; i < PAR_WRITE; i = i + 1)
            assign is_any_equal_w[i] = (waddr + i) == raddr;
        for (j = 0; j < PAR_READ; j = j + 1)
            assign is_any_equal_r[j] = (raddr + j) == waddr;
    endgenerate

    assign ready = (~|is_any_equal_w) | empty;
    assign valid = (~|is_any_equal_r) | full;

    assign full = (waddr == raddr) & (last_op == `LAST_OP_WRITE);
    assign empty = (waddr == raddr) & (last_op == `LAST_OP_READ);

    Buffer #(ADDR_WIDTH, DATA_WIDTH, PAR_WRITE, PAR_READ) buffer (
        .clk(clk),
        .rstn(rstn),
        .wen(do_w),
        .waddr(waddr),
        .raddr(raddr),
        .din(din),
        .dout(dout)
    );

    always @(posedge clk, negedge rstn)
        if (!rstn | clear)
            waddr <= 0;
        else if (do_w)
            waddr = waddr + PAR_WRITE;

    always @(posedge clk, negedge rstn)
        if (!rstn | clear)
            raddr <= 0;
        else if (do_r)
            raddr = raddr + PAR_READ;

    always @(posedge clk, negedge rstn)
        if (!rstn | clear)
            last_op <= 1'b0;
        else if (do_w)
            last_op <= `LAST_OP_WRITE;
        else if (do_r)
            last_op <= `LAST_OP_READ;
endmodule