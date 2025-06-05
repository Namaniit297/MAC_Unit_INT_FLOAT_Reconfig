`timescale 1ns/1ps

module Best_MAC #(
    parameter int DATA_W      = 8,   // input and weight width (signed)
    parameter int ACC_W       = 2*DATA_W, // accumulator width
    parameter int LAST_SUM_W  = 0    // width of LAST_SUM input, 0 = no external accumulation
)(
    input  logic                  clk,
    input  logic                  reset,
    input  logic                  enable,

    // Weight interface with double buffering
    input  logic [DATA_W-1:0]     weight_in,
    input  logic                  preload_weight,  // load into preweight buffer
    input  logic                  load_weight,     // move preweight to weight buffer

    // MAC inputs
    input  logic [DATA_W-1:0]     input_val,
    input  logic [LAST_SUM_W-1:0] last_sum,        // optional external accumulation

    // Outputs
    output logic [ACC_W-1:0]      mac_out,
    output logic                  out_valid
);

    // Derived parameters
    localparam int MUL_W = 2*DATA_W;

    // Double-buffered weights
    logic [DATA_W-1:0] preweight_cs, preweight_ns;
    logic [DATA_W-1:0] weight_cs, weight_ns;

    // Pipeline registers stage 1 (input registers)
    logic signed [DATA_W-1:0] input_stage1;
    logic signed [DATA_W-1:0] weight_stage1;
    logic zero_skip_stage1;

    // Pipeline registers stage 2 (multiply)
    logic signed [MUL_W-1:0] mult_stage2;

    // Pipeline registers stage 3 (accumulate)
    logic signed [ACC_W-1:0] acc_stage3;

    // Output valid pipeline
    logic valid_stage1, valid_stage2, valid_stage3;

    // ------------------------------------------------------------
    // Combinational next state logic for weight buffers
    always_comb begin
        preweight_ns = preweight_cs;
        weight_ns    = weight_cs;

        if (preload_weight)
            preweight_ns = weight_in;
        if (load_weight)
            weight_ns = preweight_cs;
    end

    // ------------------------------------------------------------
    // Pipeline stage 1: Register inputs and weights + zero skip
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            preweight_cs <= '0;
            weight_cs    <= '0;
            input_stage1 <= '0;
            weight_stage1 <= '0;
            zero_skip_stage1 <= 1'b1;
            valid_stage1 <= 1'b0;
        end else begin
            preweight_cs <= preweight_ns;
            weight_cs    <= weight_ns;
            if (enable) begin
                input_stage1 <= input_val;
                weight_stage1 <= weight_cs;
                zero_skip_stage1 <= (input_val == 0) || (weight_cs == 0);
                valid_stage1 <= 1'b1;
            end else begin
                valid_stage1 <= 1'b0;
            end
        end
    end

    // ------------------------------------------------------------
    // Pipeline stage 2: Multiply (skip if zero)
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            mult_stage2 <= '0;
            valid_stage2 <= 1'b0;
        end else begin
            if (valid_stage1) begin
                mult_stage2 <= zero_skip_stage1 ? '0 : $signed(input_stage1) * $signed(weight_stage1);
                valid_stage2 <= 1'b1;
            end else begin
                valid_stage2 <= 1'b0;
            end
        end
    end

    // ------------------------------------------------------------
    // Pipeline stage 3: Accumulate with optional last_sum
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            acc_stage3 <= '0;
            valid_stage3 <= 1'b0;
        end else begin
            if (valid_stage2) begin
                // sign extend last_sum if enabled
                if (LAST_SUM_W > 0) begin
                    logic signed [ACC_W-1:0] ext_last_sum;
                    ext_last_sum = $signed({{(ACC_W-LAST_SUM_W){last_sum[LAST_SUM_W-1]}}, last_sum});
                    acc_stage3 <= mult_stage2 + ext_last_sum;
                end else begin
                    acc_stage3 <= mult_stage2;
                end
                valid_stage3 <= 1'b1;
            end else begin
                valid_stage3 <= 1'b0;
            end
        end
    end

    // ------------------------------------------------------------
    // Output assignments
    assign mac_out   = acc_stage3;
    assign out_valid = valid_stage3;

endmodule
