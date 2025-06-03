module register(
    input clk,
    input rst,
    input [31:0] data_in,
    input en,
    output reg [31:0] data_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 32'b0; 
        end else if (en) begin
            data_out <= data_in;
        end
    end

endmodule
