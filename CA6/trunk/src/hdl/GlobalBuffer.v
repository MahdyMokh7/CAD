module Global_Buffer #(
    parameter DATA_WIDTH = 32,    
    parameter BUFFER_SIZE = 32 * 1024, // Default size: 32KB
    parameter ADDR_WIDTH = $clog2(BUFFER_SIZE / (DATA_WIDTH / 8)),
    parameter INIT_FILE = "memory_init.txt"
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

    localparam DEPTH = BUFFER_SIZE / (DATA_WIDTH / 8);
    reg [DATA_WIDTH - 1 : 0] mem [0 : DEPTH - 1];

    integer i;
    
    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = {DATA_WIDTH{1'b0}};
        $readmemh(INIT_FILE, mem, 0, (16 * 1024 / (DATA_WIDTH / 8)) - 1);
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            for (i = 0; i < DEPTH; i = i + 1)
                mem[i] <= {DATA_WIDTH{1'b0}};
        end
        else if (chip_en & wen) begin
            mem[waddr] <= din;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            dout <= {DATA_WIDTH{1'b0}};
        else if (chip_en & ren)
            dout <= mem[raddr];
    end

endmodule
