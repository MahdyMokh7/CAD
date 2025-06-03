module register #(
    parameter DATA_WIDTH
) (
    input clk,
    input rstn,
    input en,
    input [DATA_WIDTH - 1 : 0] d,
    output reg [DATA_WIDTH - 1 : 0] q
);

    always @(posedge clk, negedge rstn) begin
        if (!rstn)
            q <= {DATA_WIDTH{1'b0}};
        else if (en)
            q <= d;
    end

endmodule
