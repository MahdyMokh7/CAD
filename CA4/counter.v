module counter #(
    parameter ADDR_WIDTH
) (
    input clk,
    input rstn,
    input clr,
    input en,
    output reg [ADDR_WIDTH-1:0] count
);
    always @(posedge clk, negedge rstn) begin
        if (!rstn | clr)
            count <= 0;
        else if (en)
            count <= count + 1;
    end
endmodule
