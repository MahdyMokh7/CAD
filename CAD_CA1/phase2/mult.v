module mult8 (
    input wire [7:0] A,
    input wire [7:0] B,  
    output wire [15:0] result  
);
    assign result = A * B;  

endmodule
