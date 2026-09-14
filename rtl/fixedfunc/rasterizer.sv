// Simple edge-function rasterizer — draws one triangle for v0.1
import icarus_pkg::*;
module rasterizer (
  input logic clk, input logic rst,
  input logic cmd_valid, input cmd_packet_t cmd,
  output logic fb_valid,
  output logic [15:0] fb_x, fb_y,
  output logic [31:0] fb_color
);
  // Hardcoded triangle for bring-up: (100,100), (500,100), (300,400)
  logic active;
  logic [15:0] x, y;

  always_ff @(posedge clk) begin
    if (rst) begin active <= 1'b0; x <= 0; y <= 0; fb_valid <= 1'b0; end
    else if (cmd_valid && cmd.cmd_type==8'd1) begin active <= 1'b1; x<=0; y<=0; end
    else if (active) begin
      // Edge function test (barycentric) — simplified bounding box scan
      // Real: evaluate 3 edge equations; here stub to emit pixels inside triangle
      fb_valid <= 1'b1;
      fb_x <= x; fb_y <= y; fb_color <= 32'hFF00_00FF; // magenta
      if (x == FB_WIDTH-1) begin x<=0; y<= y+1; end else x<= x+1;
      if (y == FB_HEIGHT-1) active <= 1'b0;
      // Simple inside test: y > 100 && y < 400 && x between edges
      // For demo we emit all pixels — driver will mask
    end else fb_valid <= 1'b0;
  end
endmodule
