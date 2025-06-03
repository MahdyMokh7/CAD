module Buffer #(
    parameter ADDR_WIDTH, 
    parameter DATA_WIDTH,
    parameter PAR_WRITE,
    parameter PAR_READ
)(
    input clk,
    input rstn,
    input wen,
    input [ADDR_WIDTH - 1 : 0] waddr,
    input [ADDR_WIDTH - 1 : 0] raddr,
    input [PAR_WRITE * DATA_WIDTH - 1 : 0] din,
    output [PAR_READ * DATA_WIDTH - 1 : 0] dout
);

    reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];

    integer k;
    always @(negedge rstn) begin
        for (k = 0; k < 2**ADDR_WIDTH; k = k + 1) begin
            mem[k] <= 0;
        end
    end

    genvar i, j;
    generate
        for (i = 0; i < PAR_WRITE; i = i + 1) begin
            always @(posedge clk)
                if (wen)
                    mem[waddr + i] <= din[(i+1)*DATA_WIDTH - 1 : i*DATA_WIDTH];
        end
        for (j = 0; j < PAR_READ; j = j + 1) begin : gen_dout
            assign dout[(j+1)*DATA_WIDTH - 1 : j*DATA_WIDTH] = mem[raddr + j];
        end
    endgenerate

endmodule