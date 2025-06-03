`timescale 1ns / 1ps

module tb_TopModule;

    // Inputs
    reg clk;
    reg rst;
    reg start;
    reg [15:0] A;
    reg [15:0] B;

    // Outputs
    wire done;
    wire [31:0] res;

    // Instantiate the TopModule
    TopModule uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .A(A),
        .B(B),
        .done(done),
        .res(res)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test vector generation
    initial begin
        // Initialize inputs
        clk = 0;
        rst = 0;
        start = 0;
        A = 16'b0;
        B = 16'b0;

        // Apply reset
        #10 rst = 1;
        #10 rst = 0;

        // Start the multiplication process with first pair of numbers
        #10 start = 1; A = 16'b1001110011100011; B = 16'b1101100100111010;
        #10 start = 0;

        // Wait for done signal
        wait (done);
        #10;

        // Apply reset
        #10 rst = 1;
        #10 rst = 0;

        // Start the multiplication process with second pair of numbers
        #10 start = 1; A = 16'b1000101111100110; B = 16'b0101111110000001;
        #10 start = 0;

        // Wait for done signal
        wait (done);
        #10;

        // Apply reset
        #10 rst = 1;
        #10 rst = 0;

        // Start the multiplication process with third pair of numbers
        #10 start = 1; A = 16'b0110101010011101; B = 16'b1010111010000011;
        #10 start = 0;

        // Wait for done signal
        wait (done);
        #10;

        // Apply reset
        #10 rst = 1;
        #10 rst = 0;

        // Start the multiplication process with third pair of numbers
        #10 start = 1; A = 16'b0100101101110011; B = 16'b1110000011000011;
        #10 start = 0;

        // Wait for done signal
        wait (done);
        #10;

        // Apply reset
        #10 rst = 1;
        #10 rst = 0;

        // Start the multiplication process with third pair of numbers
        #10 start = 1; A = 16'b0000100111100000; B = 16'b1110001111001000;
        #10 start = 0;

        // Wait for done signal
        wait (done);
        #10;

        // Apply reset
        #10 rst = 1;
        #10 rst = 0;

        // Start the multiplication process with third pair of numbers
        #10 start = 1; A = 16'b0110011101101110; B = 16'b0101111010101111;
        #10 start = 0;

        // Wait for done signal
        wait (done);
        #10;

        // Apply reset
        #10 rst = 1;
        #10 rst = 0;

        // Start the multiplication process with third pair of numbers
        #10 start = 1; A = 16'b1000101101001110; B = 16'b1101101000011100;
        #10 start = 0;

        // Wait for done signal
        wait (done);
        #10;

        // Apply reset
        #10 rst = 1;
        #10 rst = 0;

        // Start the multiplication process with third pair of numbers
        #10 start = 1; A = 16'b0110110011110011; B = 16'b1101011100000111;
        #10 start = 0;

        // Wait for done signal
        wait (done);
        #10;

        // End simulation
        $stop;
    end

    // Monitor the inputs and outputs
    initial begin
        $monitor("Time: %0d\tclk: %b\trst: %b\tstart: %b\tA: %h\tB: %h\tdone: %b\tres: %h", 
                 $time, clk, rst, start, A, B, done, res);
    end

endmodule
