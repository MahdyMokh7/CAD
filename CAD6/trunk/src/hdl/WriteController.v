module WriteController (
    input done, ready,
    output stall, wen
);
    assign stall = done & ~ready;
    assign wen = done & ready;
endmodule