module counter3 (
    input wire clk,  
    input wire rst,        
    input wire clean,      
    input wire en,     
    output wire co,    
    output reg [2:0] count
);
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            count <= 3'b000;
        end else if (clean) begin
            count <= 3'b000;
        end else if (en) begin
            count <= count + 1;
        end
    end

    assign co = &count;

endmodule
