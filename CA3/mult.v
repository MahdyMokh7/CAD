module mult8 #(parameter N = 8) (
    input wire [N-1:0] A,  // 8-bit input A
    input wire [N-1:0] B,  // 8-bit input B
    output wire [2*N-1:0] P // 16-bit output product
);

    genvar i, j;

    wire [N-1:0] partial [N-1:0];
    generate
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1) begin
                // assign partial[i][j] = A[i] & B[j];
                my_and my_and_instance(.a(A[i]), .b(B[j]), .out(partial[i][j]));
            end
        end
    endgenerate


    wire [N-1:0] sum [0:N];
    generate
        for (j = 0; j < N; j = j + 1) begin
            assign sum[0][j] = partial[0][j];
        end
    endgenerate

    generate
        for (i = 0; i < N; i = i + 1) begin
            assign sum[i][N-1] = partial[i][N-1];
        end
    endgenerate

    wire [N-2:0] carry [0:N];
    generate
        for (j = 0; j < N-1; j = j + 1) begin
            assign carry[0][j] = 1'b0;
        end
    endgenerate

    generate
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N-1; j = j + 1) begin
                if (i < N-1)
                    full_adder fa1(
                        sum[i][j + 1],
                        partial[i + 1][j],
                        carry[i][j],

                        sum[i + 1][j],
                        carry[i + 1][j]
                    );
                else begin
                    if (j > 0)
                        full_adder fa2(
                            .a(sum[i][j + 1]),
                            .b(carry[i+1][j-1]),
                            .cin(carry[i][j]),

                            .sum(sum[i + 1][j]),
                            .cout(carry[i + 1][j])
                        );
                    else
                        full_adder fa3(
                            sum[i][j + 1],
                            1'b0,
                            carry[i][j],

                            sum[i + 1][j],
                            carry[i + 1][j]
                        );
                end
            end
        end
    endgenerate

    generate
        for (i = 0; i < N; i = i + 1) begin
            assign P[i] = sum[i][0];
        end
    endgenerate

    assign P[2*N-1: N] = {carry[N][N-2], sum[N][N-2 : 0]};

endmodule
