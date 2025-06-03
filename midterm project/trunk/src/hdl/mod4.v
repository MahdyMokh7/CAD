module mod4_calculator (
    input [2:0] in, 
    output reg [1:0] out 
);

    always @(*) begin
        out = in % 4;    
    end

endmodule
