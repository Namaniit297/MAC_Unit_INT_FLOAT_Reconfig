module fp_mac_pipeline (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire        clk,
    input  wire        reset,
    output reg  [31:0] out
);

    wire [31:0] fprod;
    wire [31:0] fadd;

    // Pipeline Registers
    reg  [31:0] reg_a1, reg_b1;
    reg  [31:0] reg_mul_out;

    // Stage 1: FP Multiply
    fpmul u_mul(clk, reset, reg_a1, reg_b1, fprod);

    // Stage 2: FP Add
    fpadd u_add(clk, reset, reg_mul_out, out, fadd);

    always @(posedge clk) begin
        if (reset) begin
            reg_a1      <= 32'd0;
            reg_b1      <= 32'd0;
            reg_mul_out <= 32'd0;
            out         <= 32'd0;
        end else begin
            reg_a1      <= a;
            reg_b1      <= b;
            reg_mul_out <= fprod;
            out         <= fadd;
        end
    end
endmodule
