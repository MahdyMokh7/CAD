module mult (
    input  signed [15:0] a, 
    input  signed [15:0] b,  
    output signed [31:0] result,
    output reg overflow 
);

    assign result = a * b;

    always @(*) begin
        if ((a[31] == 1'b1 && b[31] == 1'b1 && result[31] == 1'b1) || 
        (a[31] == 1'b0 && b[31] == 1'b1 && result[31] == 1'b0) ||
        (a[31] == 1'b1 && b[31] == 1'b0 && result[31] == 1'b0) || 
        (a[31] == 1'b0 && b[31] == 1'b0 && result[31] == 1'b1)) begin
            overflow = 1'b1;
        end else begin
            overflow = 1'b0; 
        end
    end

endmodule
