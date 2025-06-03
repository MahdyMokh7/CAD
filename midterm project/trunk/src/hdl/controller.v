module controller (
    input clk,
    input rst,
    input [2:0] N,  // 3-bit input N
    input start,     // Start signal to transition states
    // input wire [3:0] cnt_counter_main, // Input counter

    output reg valid,     // Output valid signal
    output reg ready,     // Ready signal
    output reg init_counter_main, // Init counter main signal
    output reg en_counter_main,    // Enable counter main signal

    // MUX selection outputs
    output reg sel_mux0_1_0,
    output reg sel_mux0_2_0,
    output reg sel_mux0_3_0,
    output reg sel_mux0_4_0,
    output reg sel_mux0_5_0,
    output reg sel_mux0_6_0,
    output reg sel_mux1_1_1,
    output reg sel_mux2_1_2,
    output reg sel_mux3_1_3,

    // Enable outputs for registers
    // output reg en_reg0_xn,
    // output reg en_reg0_tillnow,
    // output reg en_reg0_total,
    // output reg en_reg1_xn,
    // output reg en_reg1_tillnow,
    // output reg en_reg1_total,
    // output reg en_reg2_xn,
    // output reg en_reg2_tillnow,
    // output reg en_reg2_total,
    // output reg en_reg3_xn,
    // output reg en_reg3_tillnow,
    // output reg en_reg3_total

    output reg en_all
);

    // State definitions using parameters
    parameter IDLE = 4'b0000,
            INIT = 4'b0001,
            N_LESS_THAN_4_DONE = 4'b0011,
            N_MORE_THAN_4_1 = 4'b0100,
            N_MORE_THAN_4_2 = 4'b0101,
            N_MORE_THAN_4_3 = 4'b0110,
            N_MORE_THAN_4_4 = 4'b0111,
            N_MORE_THAN_4_5 = 4'b1000,
            N_MORE_THAN_4_6 = 4'b1001,
            N_MORE_THAN_4_7 = 4'b1010,
            N_MORE_THAN_4_8 = 4'b1011;

    reg [3:0] ps, ns; // Present state and next state

    // State Transition: ps <= ns
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ps <= IDLE; // Reset to IDLE state
        end else begin
            ps <= ns; // Update present state to next state
        end
    end

    // Next State Logic
    always @(*) begin
        case (ps)
            IDLE: begin
                if (start) begin
                    ns = INIT; // Transition to INIT state
                end else begin
                    ns = IDLE; // Stay in IDLE
                end
            end
            
            INIT: begin
                if (!start) begin
                    if (N < 4) begin
                        ns = N_LESS_THAN_4_DONE;
                    end else begin
                        ns = N_MORE_THAN_4_1;
                    end
                end else begin
                    ns = INIT; // Stay in INIT
                end
            end
            
            N_LESS_THAN_4_DONE: begin
                ns = N_LESS_THAN_4_DONE; // Return to IDLE after DONE
            end

            N_MORE_THAN_4_1: begin
                ns = N_MORE_THAN_4_2; // Transition to N_MORE_THAN_4_2
            end

            N_MORE_THAN_4_2: begin
                ns = N_MORE_THAN_4_3; // Transition to N_MORE_THAN_4_3
            end

            N_MORE_THAN_4_3: begin
                ns = N_MORE_THAN_4_4; // Transition to N_MORE_THAN_4_4
            end

            N_MORE_THAN_4_4: begin
                ns = N_MORE_THAN_4_5; // Transition to N_MORE_THAN_4_5
            end

            N_MORE_THAN_4_5: begin
                ns = N_MORE_THAN_4_6; // Transition to N_MORE_THAN_4_6
            end

            N_MORE_THAN_4_6: begin
                ns = N_MORE_THAN_4_7; // Transition to N_MORE_THAN_4_7
            end

            N_MORE_THAN_4_7: begin
                ns = N_MORE_THAN_4_8;
            end

            N_MORE_THAN_4_8: begin
                ns = N_MORE_THAN_4_1; 
            end

            default: ns = IDLE; // Default case
        endcase
    end

    // Output Logic based on State
    always @(*) begin
        // Reset outputs
        valid = 1'b0;
        ready = 1'b0;
        init_counter_main = 1'b0;
        en_counter_main = 1'b0;

        // Reset MUX and register enable signals
        sel_mux0_1_0 = 1'b0;
        sel_mux0_2_0 = 1'b0;
        sel_mux0_3_0 = 1'b0;
        sel_mux0_4_0 = 1'b0;
        sel_mux0_5_0 = 1'b0;
        sel_mux0_6_0 = 1'b0;
        sel_mux1_1_1 = 1'b0;
        sel_mux2_1_2 = 1'b0;
        sel_mux3_1_3 = 1'b0;

        // en_reg0_xn = 1'b0;
        // en_reg0_tillnow = 1'b0;
        // en_reg0_total = 1'b0;
        // en_reg1_xn = 1'b0;
        // en_reg1_tillnow = 1'b0;
        // en_reg1_total = 1'b0;
        // en_reg2_xn = 1'b0;
        // en_reg2_tillnow = 1'b0;
        // en_reg2_total = 1'b0;
        // en_reg3_xn = 1'b0;
        // en_reg3_tillnow = 1'b0;
        // en_reg3_total = 1'b0;

        en_all = 1'b0;

            case (ps)
                IDLE: begin
                    valid <= 1'b0;
                    ready <= 1'b0;
                    init_counter_main <= 1'b0;
                    en_counter_main <= 1'b0;
                end

                INIT: begin
                    valid <= 1'b0; // Valid is not set during INIT
                    ready <= 1'b0; // Ready is not set during INIT
                    init_counter_main <= 1'b1; // Init counter main set

                end

                N_LESS_THAN_4_DONE: begin
                    valid <= 1'b1; // Valid is set during done state
                    ready <= 1'b1; // Ready is not set during done
                    init_counter_main <= 1'b0; // Clear init counter main
                    en_counter_main <= 1'b1;

                    // Set enable signals for registers
                    // en_reg0_xn <= 1'b1;
                    // en_reg0_tillnow <= 1'b1;
                    // en_reg0_total <= 1'b1;
                    // en_reg1_xn <= 1'b1;
                    // en_reg1_tillnow <= 1'b1;
                    // en_reg1_total <= 1'b1;
                    // en_reg2_xn <= 1'b1;
                    // en_reg2_tillnow <= 1'b1;
                    // en_reg2_total <= 1'b1;
                    // en_reg3_xn <= 1'b1;
                    // en_reg3_tillnow <= 1'b1;
                    // en_reg3_total <= 1'b1;
                    en_all <= 1'b1;

                    // Set all MUX select signals and register enable signals
                    sel_mux0_1_0 <= 1'b0;
                    sel_mux0_2_0 <= 1'b0;
                    sel_mux0_3_0 <= 1'b0;
                    sel_mux0_4_0 <= 1'b0;
                    sel_mux0_5_0 <= 1'b0;
                    sel_mux0_6_0 <= 1'b0;
                    sel_mux1_1_1 <= 1'b0;
                    sel_mux2_1_2 <= 1'b0;
                    sel_mux3_1_3 <= 1'b0;
                end

                N_MORE_THAN_4_1: begin
                    ready <= 1'b1; // Set ready during operations

                    en_counter_main <= 1'b1; // Enable counter main

                    // Set all MUX select signals and register enable signals
                    sel_mux0_1_0 <= 1'b0;
                    sel_mux0_2_0 <= 1'b0;
                    sel_mux0_3_0 <= 1'b0;
                    sel_mux0_4_0 <= 1'b0;
                    sel_mux0_5_0 <= 1'b0;
                    sel_mux0_6_0 <= 1'b0;
                    sel_mux1_1_1 <= 1'b1;
                    sel_mux2_1_2 <= 1'b1;
                    sel_mux3_1_3 <= 1'b1;

                    // Set enable signals for registers
                    // en_reg0_xn <= 1'b1;
                    // en_reg0_tillnow <= 1'b1;
                    // en_reg0_total <= 1'b1;
                    // en_reg1_xn <= 1'b1;
                    // en_reg1_tillnow <= 1'b1;
                    // en_reg1_total <= 1'b1;
                    // en_reg2_xn <= 1'b1;
                    // en_reg2_tillnow <= 1'b1;
                    // en_reg2_total <= 1'b1;
                    // en_reg3_xn <= 1'b1;
                    // en_reg3_tillnow <= 1'b1;
                    // en_reg3_total <= 1'b1;
                    en_all <= 1'b1;
                end

                N_MORE_THAN_4_2: begin
                    ready <= 1'b1; // Set ready during operations

                    en_counter_main <= 1'b1; // Enable counter main

                    // Set all MUX select signals and register enable signals
                    sel_mux0_1_0 <= 1'b0;
                    sel_mux0_2_0 <= 1'b0;
                    sel_mux0_3_0 <= 1'b0;
                    sel_mux0_4_0 <= 1'b0;
                    sel_mux0_5_0 <= 1'b0;
                    sel_mux0_6_0 <= 1'b0;
                    sel_mux1_1_1 <= 1'b0;
                    sel_mux2_1_2 <= 1'b1;
                    sel_mux3_1_3 <= 1'b1;

                    // Set enable signals for registers
                    // en_reg0_xn <= 1'b1;
                    // en_reg0_tillnow <= 1'b1;
                    // en_reg0_total <= 1'b1;
                    // en_reg1_xn <= 1'b1;
                    // en_reg1_tillnow <= 1'b1;
                    // en_reg1_total <= 1'b1;
                    // en_reg2_xn <= 1'b1;
                    // en_reg2_tillnow <= 1'b1;
                    // en_reg2_total <= 1'b1;
                    // en_reg3_xn <= 1'b1;
                    // en_reg3_tillnow <= 1'b1;
                    // en_reg3_total <= 1'b1;
                    en_all <= 1'b1;
                end

                N_MORE_THAN_4_2: begin
                    ready <= 1'b1; // Set ready during operations

                    en_counter_main <= 1'b1; // Enable counter main

                    // Set all MUX select signals and register enable signals
                    sel_mux0_1_0 <= 1'b0;
                    sel_mux0_2_0 <= 1'b0;
                    sel_mux0_3_0 <= 1'b0;
                    sel_mux0_4_0 <= 1'b0;
                    sel_mux0_5_0 <= 1'b0;
                    sel_mux0_6_0 <= 1'b0;
                    sel_mux1_1_1 <= 1'b0;
                    sel_mux2_1_2 <= 1'b0;
                    sel_mux3_1_3 <= 1'b1;

                    // Set enable signals for registers
                    // en_reg0_xn <= 1'b1;
                    // en_reg0_tillnow <= 1'b1;
                    // en_reg0_total <= 1'b1;
                    // en_reg1_xn <= 1'b1;
                    // en_reg1_tillnow <= 1'b1;
                    // en_reg1_total <= 1'b1;
                    // en_reg2_xn <= 1'b1;
                    // en_reg2_tillnow <= 1'b1;
                    // en_reg2_total <= 1'b1;
                    // en_reg3_xn <= 1'b1;
                    // en_reg3_tillnow <= 1'b1;
                    // en_reg3_total <= 1'b1;

                    en_all <= 1'b1;
                end

                N_MORE_THAN_4_3: begin
                    ready <= 1'b1; // Set ready during operations

                    en_counter_main <= 1'b1; // Enable counter main

                    // Set all MUX select signals and register enable signals
                    sel_mux0_1_0 <= 1'b0;
                    sel_mux0_2_0 <= 1'b0;
                    sel_mux0_3_0 <= 1'b0;
                    sel_mux0_4_0 <= 1'b0;
                    sel_mux0_5_0 <= 1'b0;
                    sel_mux0_6_0 <= 1'b0;
                    sel_mux1_1_1 <= 1'b0;
                    sel_mux2_1_2 <= 1'b0;
                    sel_mux3_1_3 <= 1'b0;

                    // Set enable signals for registers
                    // en_reg0_xn <= 1'b1;
                    // en_reg0_tillnow <= 1'b1;
                    // en_reg0_total <= 1'b1;
                    // en_reg1_xn <= 1'b1;
                    // en_reg1_tillnow <= 1'b1;
                    // en_reg1_total <= 1'b1;
                    // en_reg2_xn <= 1'b1;
                    // en_reg2_tillnow <= 1'b1;
                    // en_reg2_total <= 1'b1;
                    // en_reg3_xn <= 1'b1;
                    // en_reg3_tillnow <= 1'b1;
                    // en_reg3_total <= 1'b1;
                    en_all <= 1'b1;
                end

                N_MORE_THAN_4_5: begin
                    ready <= 1'b0; // Set ready during operations

                    en_counter_main <= 1'b1; // Enable counter main

                    // Set all MUX select signals and register enable signals
                    sel_mux0_1_0 <= 1'b1;
                    sel_mux0_2_0 <= 1'b1;
                    sel_mux0_3_0 <= 1'b1;
                    sel_mux0_4_0 <= 1'b1;
                    sel_mux0_5_0 <= 1'b1;
                    sel_mux0_6_0 <= 1'b1;
                    sel_mux1_1_1 <= 1'b0;
                    sel_mux2_1_2 <= 1'b0;
                    sel_mux3_1_3 <= 1'b0;

                    // Set enable signals for registers
                    // en_reg0_xn <= 1'b1;
                    // en_reg0_tillnow <= 1'b1;
                    // en_reg0_total <= 1'b1;
                    // en_reg1_xn <= 1'b1;
                    // en_reg1_tillnow <= 1'b1;
                    // en_reg1_total <= 1'b1;
                    // en_reg2_xn <= 1'b1;
                    // en_reg2_tillnow <= 1'b1;
                    // en_reg2_total <= 1'b1;
                    // en_reg3_xn <= 1'b1;
                    // en_reg3_tillnow <= 1'b1;
                    // en_reg3_total <= 1'b1;
                    en_all <= 1'b1;
                end

                N_MORE_THAN_4_6: begin
                    ready <= 1'b0; // Set ready during operations

                    en_counter_main <= 1'b1; // Enable counter main

                    // Set all MUX select signals and register enable signals
                    sel_mux0_1_0 <= 1'b1;
                    sel_mux0_2_0 <= 1'b1;
                    sel_mux0_3_0 <= 1'b1;
                    sel_mux0_4_0 <= 1'b1;
                    sel_mux0_5_0 <= 1'b1;
                    sel_mux0_6_0 <= 1'b1;
                    sel_mux1_1_1 <= 1'b1;
                    sel_mux2_1_2 <= 1'b0;
                    sel_mux3_1_3 <= 1'b0;

                    // Set enable signals for registers
                    // en_reg0_xn <= 1'b1;
                    // en_reg0_tillnow <= 1'b1;
                    // en_reg0_total <= 1'b1;
                    // en_reg1_xn <= 1'b1;
                    // en_reg1_tillnow <= 1'b1;
                    // en_reg1_total <= 1'b1;
                    // en_reg2_xn <= 1'b1;
                    // en_reg2_tillnow <= 1'b1;
                    // en_reg2_total <= 1'b1;
                    // en_reg3_xn <= 1'b1;
                    // en_reg3_tillnow <= 1'b1;
                    // en_reg3_total <= 1'b1;
                    en_all <= 1'b1;
                end

                N_MORE_THAN_4_7: begin
                    ready <= 1'b1; // Set ready during operations

                    en_counter_main <= 1'b1; // Enable counter main

                    // Set all MUX select signals and register enable signals
                    sel_mux0_1_0 <= 1'b1;
                    sel_mux0_2_0 <= 1'b1;
                    sel_mux0_3_0 <= 1'b1;
                    sel_mux0_4_0 <= 1'b1;
                    sel_mux0_5_0 <= 1'b1;
                    sel_mux0_6_0 <= 1'b1;
                    sel_mux1_1_1 <= 1'b1;
                    sel_mux2_1_2 <= 1'b1;
                    sel_mux3_1_3 <= 1'b0;

                    // Set enable signals for registers
                    // en_reg0_xn <= 1'b1;
                    // en_reg0_tillnow <= 1'b1;
                    // en_reg0_total <= 1'b1;
                    // en_reg1_xn <= 1'b1;
                    // en_reg1_tillnow <= 1'b1;
                    // en_reg1_total <= 1'b1;
                    // en_reg2_xn <= 1'b1;
                    // en_reg2_tillnow <= 1'b1;
                    // en_reg2_total <= 1'b1;
                    // en_reg3_xn <= 1'b1;
                    // en_reg3_tillnow <= 1'b1;
                    // en_reg3_total <= 1'b1;
                    en_all <= 1'b1;
                end

                N_MORE_THAN_4_8: begin
                    ready <= 1'b1; // Set ready during operations

                    en_counter_main <= 1'b1; // Enable counter main

                    // Set all MUX select signals and register enable signals
                    sel_mux0_1_0 <= 1'b1;
                    sel_mux0_2_0 <= 1'b1;
                    sel_mux0_3_0 <= 1'b1;
                    sel_mux0_4_0 <= 1'b1;
                    sel_mux0_5_0 <= 1'b1;
                    sel_mux0_6_0 <= 1'b1;
                    sel_mux1_1_1 <= 1'b1;
                    sel_mux2_1_2 <= 1'b1;
                    sel_mux3_1_3 <= 1'b1;

                    // Set enable signals for registers
                    // en_reg0_xn <= 1'b1;
                    // en_reg0_tillnow <= 1'b1;
                    // en_reg0_total <= 1'b1;
                    // en_reg1_xn <= 1'b1;
                    // en_reg1_tillnow <= 1'b1;
                    // en_reg1_total <= 1'b1;
                    // en_reg2_xn <= 1'b1;
                    // en_reg2_tillnow <= 1'b1;
                    // en_reg2_total <= 1'b1;
                    // en_reg3_xn <= 1'b1;
                    // en_reg3_tillnow <= 1'b1;
                    // en_reg3_total <= 1'b1;
                    en_all <= 1'b1;
                end


                default: begin
                    valid <= 1'b0; // Default valid
                    ready <= 1'b0; // Default ready
                end
            endcase
    end

endmodule
