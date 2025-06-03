module counter_3bit (
    input clk,
    input rst,
    input cnt_en,
    output [2:0] count,
    output carry_out
);
    wire t0, t1;
    wire [2:0] q;

    t_ff tff0 (
        .clk(clk),
        .rst(rst),
        .t(cnt_en),
        .q(q[0])
    );

    my_and and0 (
        .a(q[0]),
        .b(cnt_en),
        .out(t0)
    );

    t_ff tff1 (
        .clk(clk),
        .rst(rst),
        .t(t0),
        .q(q[1])
    );

    my_and and1 (
        .a(q[1]),
        .b(t0),
        .out(t1)
    );

    t_ff tff2 (
        .clk(clk),
        .rst(rst),
        .t(t1), 
        .q(q[2])
    );

    my_and and2 (
        .a(q[2]),
        .b(t1), 
        .out(carry_out)
    );

    assign count = q;

endmodule
