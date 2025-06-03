module controller (
    input clk, rst, mostA, mostB, co_A, co_B, start, 

    output reg done, clean, ld_a, ld_b, cnt_clean_a, 
    cnt_clean_b, shift_en_a, cnt_en_a, shift_en_a, cnt_en_b, 
    ld_res, shift_en_res, cnt_en;
);


    wire sh_doneA, rzA;
    wire sh_doneB, rzB;

    register1 regA(clk, rst, co_A, 1'b1, sh_doneA);
    register1 regB(clk, rst, co_B, 1'b1, sh_doneB);

    assign rzA = ~sh_doneA;
    assign rzB = ~sh_doneB;

    reg [3:0] ns, ps;

    parameter Idle = 4'b0000, Init = 4'b0001, ZeroCountA = 4'b0010, 
    ZeroCountB = 4'b0011, Mult = 4'b0100, addZeroA = 4'b0101, 
    addZeroB = 4'b0110, DoneInput = 4'b0111, Done = 4'b1000;

    always @(*) begin
        case (ps)
            Idle: ns = start ? Init : Idle;
            Init: ns = start ? Init : ZeroCountA;
            ZeroCountA: ns = mostA | co_A ? ZeroCountB : ZeroCountA;
            ZeroCountB: ns = mostB | co_B ? Mult : ZeroCountB;
            Mult: ns = rzA ? addZeroA : 
                       rzB ? addZeroB : 
                             DoneInput;

            addZeroA: ns = ~co_A ? addZeroA:
                           rzB ? addZeroB:
                                   DoneInput;

            addZeroB: ns = ~co_B ? addZeroB: DoneInput;
            DoneInput: ns = co ? Done: Init; 
            Done: ns = Idle;
            default: 
        endcase
    end

    always @(*) begin
        {done, clean, ld_a, ld_b, cnt_clean_a, cnt_clean_b, shift_en_a, cnt_en_a, shift_en_a, cnt_en_b, ld_res, shift_en_res, cnt_en} = 13'b0;
        case (ps)
            Idle: begin
                clean = 1'b1;
            end
            Init: begin
                ld_a = 1'b1;
                ld_b = 1'b1;
                cnt_clean_a = 1'b1;
                cnt_clean_b = 1'b1;
            end
            ZeroCountA: begin
                shift_en_a = ~mostA;
                cnt_en_a = ~mostA;
            end
            ZeroCountB:  begin
                shift_en_b = ~mostB;
                cnt_en_b = ~mostB;             
            end
            Mult: begin
                ld_res = 1'b1;
            end

            addZeroA: begin
                shift_en_res = 1'b1;
                cnt_en_a = 1'b1;
            end

            addZeroB: begin
                shift_en_res = 1'b1;
                cnt_en_b = 1'b1;
            end
            DoneInput: begin
                cnt_en = 1'b1;
            end
            Done: begin
                done = 1'b1;
            end

            default: 
        endcase
    end

    always @(posedge clk, posedge rst) begin
        if (rst):
            ps <= 4'b0;
        else
            ps <= ns;
    end
    
endmodule