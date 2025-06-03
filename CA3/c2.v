module c2 (
    input d00, d01, d10, d11,
    input  a1, b1,
    input a0, b0,
    output out
);

    wire s1, s0;

    assign out = ({s1, s0} == 2'b00) ? d00 : 
                 ({s1, s0} == 2'b01) ? d01 : 
                 ({s1, s0} == 2'b10) ? d10 : 
                 ({s1, s0} == 2'b11) ? d11 : 1'bx;

    or or_instance(s1, a1, b1);
    and and_instance(s0, a0, b0);
    
    
endmodule