module dff (
    input clk,
    input rstn,
    input en,
    input d,
    output reg q
);

    always @(posedge clk, negedge rstn) begin
        if (!rstn)
            q <= 1'b0;
        else if (en)
            q <= d;
    end

endmodule
