module Reg_SPAD #(
    parameter DATA_WIDTH,
    parameter DEPTH,
    parameter ADDR_WIDTH
) (
    input clk,
    input rstn,
    input wen,
    input [ADDR_WIDTH - 1 : 0] raddr,
    input [ADDR_WIDTH - 1 : 0] waddr,
    input [DATA_WIDTH - 1 : 0] din,
    output [DATA_WIDTH - 1 : 0] dout
);
    reg [DATA_WIDTH - 1 : 0] mem [0 : DEPTH - 1];

    integer i;
    always @(posedge clk, negedge rstn) begin
        if (!rstn)
            for (i = 0; i < DEPTH; i = i + 1)
                mem[i] <= {DATA_WIDTH{1'b0}};
        else if (wen)
            mem[waddr] <= din;
    end

    assign dout = mem[raddr];

endmodule
    
module SRAM_SPAD #(
    parameter DATA_WIDTH,
    parameter DEPTH,
    parameter ADDR_WIDTH
) (
    input clk,
    input rstn,
    input chip_en,
    input ren,
    input wen,
    input [ADDR_WIDTH - 1 : 0] raddr,
    input [ADDR_WIDTH - 1 : 0] waddr,
    input [DATA_WIDTH - 1 : 0] din,
    output reg [DATA_WIDTH - 1 : 0] dout
);
    reg [DATA_WIDTH - 1 : 0] mem [0 : DEPTH - 1];

    integer i;
    always @(posedge clk, negedge rstn) begin
        if (!rstn)
            for (i = 0; i < DEPTH; i = i + 1)
                mem[i] <= {DATA_WIDTH{1'b0}};
        else if (chip_en & wen)
            mem[waddr] <= din;
    end

    always @(posedge clk, negedge rstn) begin
        if (!rstn)
            dout <= {DATA_WIDTH{1'b0}};
        else if (chip_en & ren)
            dout <= mem[raddr];
    end
        
endmodule


module tb_Reg_SPAD;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter DEPTH = 16;
    parameter ADDR_WIDTH = 4;

    // Inputs
    reg clk;
    reg rstn;
    reg wen;
    reg [ADDR_WIDTH - 1 : 0] raddr;
    reg [ADDR_WIDTH - 1 : 0] waddr;
    reg [DATA_WIDTH - 1 : 0] din;

    // Outputs
    wire [DATA_WIDTH - 1 : 0] dout;

    // Instantiate the Reg_SPAD module
    Reg_SPAD #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) uut (
        .clk(clk),
        .rstn(rstn),
        .wen(wen),
        .raddr(raddr),
        .waddr(waddr),
        .din(din),
        .dout(dout)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rstn = 0;
        wen = 0;
        raddr = 0;
        waddr = 0;
        din = 0;

        // Reset the memory
        #10 rstn = 1;

        // Write to memory
        wen = 1;
        waddr = 4'h1;
        din = 8'hA5;
        #10;

        waddr = 4'h2;
        din = 8'h3C;
        #10;

        wen = 0;

        // Read from memory
        raddr = 4'h1;
        #10;

        raddr = 4'h2;
        #10;

        // Finish the simulation
        $stop;
    end

endmodule

module tb_SRAM_SPAD;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter DEPTH = 16;
    parameter ADDR_WIDTH = 4;

    // Inputs
    reg clk;
    reg rstn;
    reg chip_en;
    reg ren;
    reg wen;
    reg [ADDR_WIDTH - 1 : 0] raddr;
    reg [ADDR_WIDTH - 1 : 0] waddr;
    reg [DATA_WIDTH - 1 : 0] din;

    // Outputs
    wire [DATA_WIDTH - 1 : 0] dout;

    // Instantiate the SRAM_SPAD module
    SRAM_SPAD #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) uut (
        .clk(clk),
        .rstn(rstn),
        .chip_en(chip_en),
        .ren(ren),
        .wen(wen),
        .raddr(raddr),
        .waddr(waddr),
        .din(din),
        .dout(dout)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rstn = 0;
        chip_en = 0;
        ren = 0;
        wen = 0;
        raddr = 0;
        waddr = 0;
        din = 0;

        // Apply Reset
        #10 rstn = 1;

        // Enable the chip
        chip_en = 1;

        // Write to memory
        wen = 1;
        waddr = 4'h1;
        din = 8'hA5;
        #10;

        waddr = 4'h2;
        din = 8'h3C;
        #10;

        wen = 0;

        // Read from memory
        ren = 1;
        raddr = 4'h1;
        #10;

        raddr = 4'h2;
        #10;

        ren = 0;

        // Finish the simulation
        $stop;
    end

endmodule