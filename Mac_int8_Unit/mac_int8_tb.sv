`timescale 1ns/1ps

module tb_Best_MAC();

    // Parameters
    localparam DATA_W = 8;
    localparam ACC_W  = 2*DATA_W;
    localparam LAST_SUM_W = 0;

    // Signals
    logic clk;
    logic reset;
    logic enable;

    logic [DATA_W-1:0] weight_in;
    logic preload_weight;
    logic load_weight;

    logic [DATA_W-1:0] input_val;
    logic [LAST_SUM_W-1:0] last_sum;

    logic [ACC_W-1:0] mac_out;
    logic out_valid;

    // Instantiate DUT
    Best_MAC #(
        .DATA_W(DATA_W),
        .ACC_W(ACC_W),
        .LAST_SUM_W(LAST_SUM_W)
    ) dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .weight_in(weight_in),
        .preload_weight(preload_weight),
        .load_weight(load_weight),
        .input_val(input_val),
        .last_sum(last_sum),
        .mac_out(mac_out),
        .out_valid(out_valid)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        $display("Starting Best_MAC testbench...");
        
        // Initialize signals
        reset = 1;
        enable = 0;
        preload_weight = 0;
        load_weight = 0;
        weight_in = 0;
        input_val = 0;
        last_sum = 0;

        @(posedge clk);
        reset = 0;

       
