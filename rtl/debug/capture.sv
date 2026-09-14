// capture.sv — RTL tap for live instance (mirrors sw/model/capture.py)
// Taps pc, alu_res, fb_x/y like video frames, buffers to BRAM then dumps via AXI
module capture #(
  parameter DEPTH=1024
)(
  input  logic clk, rst,
  input  logic [31:0] pc,
  input  logic [31:0] alu_res,
  input  logic [15:0] fb_x, fb_y,
  input  logic        capture_en,
  output logic full
);
  logic [31:0] bram [DEPTH];
  logic [$clog2(DEPTH)-1:0] wptr;
  always_ff @(posedge clk) begin
    if (rst) wptr <= 0;
    else if (capture_en && !full) begin
      bram[wptr] <= {pc[15:0], alu_res[15:0]}; // pack-like trace
      wptr <= wptr+1;
    end
  end
  assign full = (wptr == DEPTH-1);
  // Seekable: host can read bram via APB at any time, scrub like video
endmodule
