module mux2to1_1bit (
    input  a,     
    input  b,   
    input  sel,     
    output out 
);

    assign out = sel ? b : a;

endmodule