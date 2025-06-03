module shiftReg16 (
    input wire clk,               // Clock signal
    input wire rst,               // Reset signal (active high)
    input wire shift_en,          // Shift enable signal
    input wire ld,                // Load enable signal
    input wire [15:0] parInp,     // Parallel input data
    output reg [15:0] parOut      // Parallel output data
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            parOut <= 16'b0;
        end else if (ld) begin
            parOut <= parInp;
        end else if (shift_en) begin
            parOut <= {parOut[14:0], 1'b0};
        end
    end
endmodule


module shiftReg32 (
    input wire clk,
    input wire rst,
    input wire shift_en,
    input wire ld,
    input wire [31:0] parInp,
    output reg [31:0] parOut     
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            parOut <= 32'b0;
        end else if (ld) begin
            parOut <= parInp;
        end else if (shift_en) begin
            parOut <= {parOut[30:0], 1'b0};
        end
    end
endmodule
