module c1 (
    input a0, a1,
    input sa, 
    input b0, b1,
    input sb,
    input s0, s1,

    output out
);

    wire f1, f2, s2;

    assign f1 = sa ? a1 : a0;
    assign f2 = sb ? b1 : b0;
    assign out = s2 ? f2 : f1;    

    or or_s2(s2, s0, s1);
    
endmodule