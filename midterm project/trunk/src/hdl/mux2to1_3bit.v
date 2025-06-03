module mux2to1_3bit (
    input [2:0] a,     
    input [2:0] b,   
    input sel,     
    output[2:0] out 
);

    assign out = sel ? b : a;

endmodule
