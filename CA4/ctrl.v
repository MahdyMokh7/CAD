module ctrl (
    input clk, rstn,
    input start,
    input valid_IF, valid_Filter, stall,
    input frame_done, filter_done, row_done,

    output reg cnt_clr, cnt_en,
    output reg start_frame_clr, start_frame_ld,
    output reg start_filter_clr, start_filter_ld,
    output reg start_row_ren, end_row_ren,
    output reg valid, done
);
    parameter Idle = 2'b00, Init = 2'b01, Calc = 2'b10;

    reg [1:0] ps, ns;

    always @(*) begin
        case (ps)
            Idle: ns = start ? Init : Idle;
            Init: ns = start ? Init : Calc;
            Calc: ns = Calc;
        endcase
    end

    always @(*) begin
        {cnt_clr, cnt_en, start_frame_clr, start_frame_ld, start_filter_clr, start_filter_ld, start_row_ren, end_row_ren, valid, done} = 10'b0;
        case (ps)
            Init: {cnt_clr, start_frame_clr, start_filter_clr} = 3'b1;
            Calc: if (valid_IF & valid_Filter & ~stall) begin
                {cnt_en, valid} = 2'b1;
                if (frame_done) begin
                    {cnt_clr, done, start_frame_ld} = 3'b1;
                    if (filter_done) begin
                        {start_frame_clr, start_filter_ld} = 2'b1;
                        if (row_done) begin
                            {start_filter_clr, start_row_ren, end_row_ren} = 3'b1;
                        end
                    end
                end
            end
        endcase
    end

    always @(posedge clk, negedge rstn) begin
        if (!rstn)
            ps <= 2'b0;
        else
            ps <= ns;
    end
endmodule