module rom (
    input [2:0] addr, 
    output reg [15:0] data 
);
    // Declare ROM
    reg [15:0] romm [0:7];

    // Initialize ROM contents using an initial block
    initial begin
        romm[0] = 16'b0111111111111111; // Address 0
        romm[1] = 16'b1100000000000000; // Address 1
        romm[2] = 16'b0010101010101010; // Address 2
        romm[3] = 16'b1010000000000000; // Address 3
        romm[4] = 16'b0001100110011001; // Address 4
        romm[5] = 16'b0001010101010101; // Address 5
        romm[6] = 16'b0001001001001001; // Address 6
        romm[7] = 16'b0001000000000000; // Address 7
    end

    // Assign the value from the ROM to the output based on the address
    always @(*) begin
        data = romm[addr]; 
    end
endmodule
