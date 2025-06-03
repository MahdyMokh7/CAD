module equal (
    input [2:0] N,
    input [2:0] cnt,
    output reg valid 
);

    always @(*) begin
        if (N == cnt) begin
            valid = 1'b1;
        end else begin
            valid = 1'b0;
        end
    end
    
endmodule