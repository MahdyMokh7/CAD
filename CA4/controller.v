// module controller (
//     input clk, rst
//     start, 
//     validIF, validFilter, stall, 
//     frame_done, filter_done, row_done,
//     output cnt_clr, short_filter_clr, start_frame_clr,
//     cnt_en, 
//     start_frame_ld, cnt_clr, done, valid, 
//     start_filter_ld, 
//     start_row_ren, end_row_ren, start_filter_clr 
// );

//     parameter Idle = 2'b00, Init = 2'b01, Calc = 2'b10;
//     reg[1:0] ps, ns;

//     always @(*) begin
//         case (ps)
//             Idle: ns = start ? Init : Idle;
//             Init: ns = start ? Init : Calc;
//             Calc: ns = Calc;

//             default: 
//         endcase
//     end

//     always @(*) begin
//         initial begin
//             cnt_clr = 0;
//             short_filter_clr = 0;
//             start_frame_clr = 0;
//             cnt_en = 0;
//             start_frame_ld = 0;
//             done = 0;
//             valid = 0;
//             start_filter_ld = 0;
//             start_row_ren = 0;
//             end_row_ren = 0;
//             start_filter_clr = 0;
//         end
//         case (ps)
//             Idle: begin

//             end
//             Init: begin
//                 cnt_clr = 1'b1;
//                 start_filter_clr = 1'b1;
//                 start_frame_clr = 1'b1;
//             end
//             Calc: begin  ////////////////////////////////
//                 if (~(validIF & validFilter & ~stall)) begin
                    
//                 end
//                 else if (frame_done) begin
//                     start_frame_ld = 1'b1;
//                     cnt_clr = 1'b1;
//                     done = 1'b1;
//                     valid = 1'b1;
//                 end
//                 else if(filter_done) begin
//                     start_filter_ld = 1'b1;
//                     cnt_clr = 1'b1;
//                     valid = 1'b1;
//                     done = 1'b1;
//                     start_frame_clr = 1'b1;
//                 end
//                 else if(row_done) begin
//                     start_frame_clr = 1'b1;
//                     start_row_ren = 1'b1;
//                     end_row_ren = 1'b1;
//                     cnt_clr = 1'b1;
//                     valid = 1'b1;
//                     done = 1'b1;
//                     start_filter_clr = 1'b1;
//                 end
//                 else begin
//                     cnt_en = 1'b1;
//                     valid = 1'b1;
//                 end
//             end
//             default: 
//         endcase
//     end

//     always @(posedge clk) begin
//         if (rst):
//             ps <= 4'b0;
//         else
//             ps <= ns;
//     end
    
// endmodule