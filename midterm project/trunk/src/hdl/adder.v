module adder (
    input  signed [31:0] a, 
    input  signed [31:0] b,  
    output signed [31:0] result,
    output overflow  
);

    assign result = a + b; 

    assign overflow = (a[31] == b[31]) && (result[31] != a[31]);

endmodule
