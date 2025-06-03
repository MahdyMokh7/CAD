module counter #(
    parameter ADDR_WIDTH
) (
    input clk,
    input rstn,
    input clr,
    input ld,
    input en,
    input [ADDR_WIDTH-1:0] par_in,
    output reg [ADDR_WIDTH-1:0] count,
    output co
);
    always @(posedge clk, negedge rstn) begin
        if (!rstn | clr)
            count <= {ADDR_WIDTH{1'b0}};
        else if (ld)
            count <= par_in;
        else if (en)
            count <= count + 1;
    end

    assign co = &count;
endmodule

module bound_counter #(
    parameter ADDR_WIDTH,
    parameter MAX_VALUE
) (
    input clk,
    input rstn,
    input clr,
    input en,
    output reg [ADDR_WIDTH-1:0] count,
    output co
);
    always @(posedge clk, negedge rstn) begin
        if (!rstn | clr)
            count <= {ADDR_WIDTH{1'b0}};
        else if (en) begin
            if (co)
                count <= {ADDR_WIDTH{1'b0}};
            else
                count <= count + 1;
        end
    end

    assign co = (count + 1) == MAX_VALUE;
endmodule

module step_counter #(
    parameter ADDR_WIDTH
) (
    input clk,
    input rstn,
    input clr,
    inout en,
    input [ADDR_WIDTH - 1 : 0] step,
    output reg [ADDR_WIDTH - 1 : 0] count
);

    always @(posedge clk, negedge rstn) begin
        if (!rstn | clr)
            count <= {ADDR_WIDTH{1'b0}};
        else if (en)
            count <= count + step;
    end

endmodule

