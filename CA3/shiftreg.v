module shiftreg_16bit (
    input clk, rst,
    input sh_en, ld,
    input [15:0] par_in,
    output out_shift,
    output [15:0] par_out 
);

    shift_ff shift_ff_instance15(.clk(clk), .rst(rst), .sh_en(sh_en), .ld(ld), .in(par_in[0]), .in_shift(1'b0), .out(par_out[0]));          
    genvar i;
    generate
        for(i = 1; i < 16; i = i + 1) begin
            shift_ff shift_ff_instance(.clk(clk), .rst(rst), .sh_en(sh_en), .ld(ld), .in(par_in[i]), .in_shift(par_out[i-1]), .out(par_out[i]));          
        end 
    endgenerate

    assign out_shift = par_out[15];
    
endmodule

module shiftreg_32bit (
    input clk, rst,
    input sh_en, ld,
    input [31:0] par_in,
    output out_shift,
    output [31:0] par_out 
);

    shift_ff shift_ff_instance15(.clk(clk), .rst(rst), .sh_en(sh_en), .ld(ld), .in(par_in[0]), .in_shift(1'b0), .out(par_out[0]));          
    genvar i;
    generate
        for(i = 1; i < 32; i = i + 1) begin
            shift_ff shift_ff_instance(.clk(clk), .rst(rst), .sh_en(sh_en), .ld(ld), .in(par_in[i]), .in_shift(par_out[i-1]), .out(par_out[i]));          
        end 
    endgenerate

    assign out_shift = par_out[31];

    
endmodule