module register_signals (
    input clk,
    input rst,
    input en,
    input [15:0] x_in,
    input valid_in,
    input overflow_in,
    input [2:0] cnt_in,  
    input error_in,

    output reg [15:0] x_out,
    output reg valid_out,
    output reg overflow_out,
    output reg [2:0] cnt_out, 
    output reg error_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x_out <= 32'b0; 
            valid_out <= 1'b0;
            overflow_out <= 1'b0;
            cnt_out <= 3'b0;  
            error_out <= 1'b0;
        end else if (en) begin
            x_out <= x_in;
            valid_out <= valid_in;
            overflow_out <= overflow_in;
            cnt_out <= cnt_in;   
            error_out <= error_in;
        end
    end

endmodule
