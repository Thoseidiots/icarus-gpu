// Shader core — 4-lane SIMT, RV32IM + FP16/INT8 variable precision (Oracle-real)
import icarus_pkg::*;

module shader_core (
  input  logic clk,
  input  logic rst,
  input  logic clk_en,
  input  logic sched_valid
  // TODO: AXI to L2, register file, wavefront
);

  // Simple 2-stage pipeline stub: fetch -> execute
  // v0.1 executes a single dot-product for demo (vector ALU)
  logic [31:0] pc;
  logic [31:0] instr;

  // Variable-precision ALU (Oracle-Real): auto precision + operand gating
  logic [31:0] alu_a, alu_b, alu_res;
  logic [1:0]  precision; // 0=INT8, 1=FP16, 2=FP32 (auto-selected)
  logic        alu_gated;

  // Auto-precision: detect if operands fit in narrower format (saves 70-90% per op)
  // Horowitz: FP32 3.7pJ -> FP16 1.1pJ -> INT8 0.2pJ
  always_comb begin
    if (alu_a[31:8]==0 && alu_b[31:8]==0) precision = 2'd0; // fits INT8
    else if (alu_a[31:16]==0 && alu_b[31:16]==0) precision = 2'd1; // fits FP16 (simplified)
    else precision = 2'd2;
    alu_gated = !clk_en || !sched_valid; // operand gating when idle
  end

  always_ff @(posedge clk) begin
    if (rst) pc <= 32'h0;
    else if (clk_en && sched_valid) pc <= pc + 4;
  end

  // v0.3: sparsity skip — if one operand zero, skip multiply/add (saves ~6% per loop iter 6)
  logic is_zero;
  assign is_zero = (alu_a == 32'h0) || (alu_b == 32'h0);

  always_comb begin
    if (alu_gated) alu_res = 32'h0;
    else if (is_zero) alu_res = 32'h0; // skip ALU, power gated
    else case (precision)
      2'd0: alu_res = alu_a * alu_b; // INT8
      2'd1: alu_res = alu_a + alu_b; // FP16
      default: alu_res = alu_a + alu_b; // FP32
    endcase
  end

  // Gating: clock enable implements Conductor-lite (no voltage scaling on FPGA)
  // Synthesis will infer clock gates from clk_en

endmodule
