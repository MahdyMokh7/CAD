module c1(input a0 , a1 , sa , b0 , b1 ,sb , s0 , s1,output out) ;
 initial begin 
      $system("c1.exe ");
    end
wire f1 , f2 , s2; 
assign f1 = (sa)? a1:a0;
assign f2 = (sb)? b1:b0;
assign s2 = s0|s1;
assign out=(s2)?f2:f1;
endmodule
module c2 (input d00 , d01 ,d10 , d11 , a1 , b1 , a0 , b0 , output reg out);
    integer fd ;
   initial begin 
      $system("c2.exe ");
    end
    wire s0 , s1; 
    assign s1 = a1 | b1 ;
    assign s0 = a0 & b0 ;
    always @(*)
    begin 
      if (s1 == 1 && s0 == 1)
      begin
        out = d11;
      end
      if (s1 == 1 && s0 == 0)
      begin
        out = d10;
      end
      if (s1 == 0 && s0 == 1)
      begin
        out = d01;
      end
      if (s1 == 0 && s0 == 0)
      begin
        out = d00;
      end
    end
endmodule
module FDCP(
  input clk , CLR, D, 
  output reg Q);

  always @(posedge clk or posedge CLR)
    if(CLR)
      Q <= 0;
    else
      Q <= D;
endmodule
module s1(input d00 , d01 ,d10 , d11 , a1 , b1 , a0 , clr , clk , output out);
 initial begin 
      $system("s2-s1.exe ");
    end
    wire s0 , s1 ,d; 
    assign s1 = a1 | b1 ;
    assign s0 = a0 & clr ;
    assign d= ({s1,s0}== 2'd0)? d00: 
              ({s1,s0}==2'd1)? d01: 
              ({s1,s0}==2'd2)? d10: 
              ({s1,s0}==2'd3)? d11 :
                    2'bz;
    FDCP ff(clk , clr , d, out) ;

endmodule
module s2(input d00 , d01 ,d10 , d11 , a1 , b1 , a0,b0 , clr , clk , output out);
 initial begin 
      $system("s2-s1.exe ");
    end
     wire s0 , s1 ,d; 
    assign s1 = a1 | b1 ;
    assign s0 = a0 & b0;
    assign d= ({s1,s0}== 2'd0)? d00: 
              ({s1,s0}==2'd1)? d01: 
              ({s1,s0}==2'd2)? d10: 
              ({s1,s0}==2'd3)? d11 :
                    2'bz;
    FDCP ff (clk , clr , d, out) ;     
endmodule
