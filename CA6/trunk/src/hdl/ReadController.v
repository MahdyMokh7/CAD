module ReadController (
    input ready, valid,
    output wen
);
    assign wen = ready & valid;
endmodule