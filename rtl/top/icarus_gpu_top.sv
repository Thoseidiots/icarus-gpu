// Icarus-GPU Top — synthesizable skeleton
// Real physics: no net-positive; uses clock gating + prefetcher for perf/W
module icarus_gpu_top #(
  parameter int CLK_MHZ = 3000 // 3000MHz locked, see icarus_pkg.sv:6 (yosys compat)
) (

  input  logic clk_sys, // must be 3000MHz (333ps) — FPGA 2000ps will fault
  input  logic rst_n,

  // Command stream (CPU -> GPU) AXI4-Stream 64-bit
  input  logic                  s_axis_tvalid,
  output logic                  s_axis_tready,
  input  logic [icarus_pkg::AXIS_DATA_W-1:0] s_axis_tdata,
  input  logic                  s_axis_tlast,

  // AXI4 to DDR (simplified)
  output logic [icarus_pkg::AXI_ADDR_W-1:0] m_axi_araddr,
  output logic                  m_axi_arvalid,
  input  logic                  m_axi_arready,
  input  logic [icarus_pkg::AXI_DATA_W-1:0] m_axi_rdata,
  input  logic                  m_axi_rvalid,
  output logic                  m_axi_rready,

  output logic [icarus_pkg::AXI_ADDR_W-1:0] m_axi_awaddr,
  output logic [icarus_pkg::AXI_DATA_W-1:0] m_axi_wdata,
  output logic                  m_axi_wvalid,
  input  logic                  m_axi_wready,
  input  logic                  m_axi_bvalid,
  output logic                  m_axi_bready,

  // Framebuffer output (for sim / HDMI)
  output logic                  fb_valid,
  output logic [15:0]           fb_x,
  output logic [15:0]           fb_y,
  output logic [31:0]           fb_color,

  // Sensors (thermal stub replaces Helios-Prime)
  output icarus_pkg::sensor_t sensor_out
);
  import icarus_pkg::*;
  logic rst_sync;
  assign rst_sync = ~rst_n;

  // Clock enables per core (Conductor-lite: real DVFS would need voltage scaling)
  logic [NUM_CORES-1:0] core_ce;

  // Interconnect wires — scheduler <> cores <> L2
  // Keep simple for v0.1: scheduler broadcasts waves, cores request via L2

  // Command processor
  cmd_packet_t cmd;
  logic cmd_valid, cmd_ready;
  command_processor u_cmd (
    .clk(clk_sys), .rst(rst_sync),
    .s_axis_tvalid(s_axis_tvalid), .s_axis_tready(s_axis_tready),
    .s_axis_tdata(s_axis_tdata), .s_axis_tlast(s_axis_tlast),
    .cmd_valid(cmd_valid), .cmd_ready(cmd_ready), .cmd(cmd)
  );

  // Scheduler
  logic sched_valid;
  scheduler u_sched (
    .clk(clk_sys), .rst(rst_sync),
    .cmd_valid(cmd_valid), .cmd_ready(cmd_ready), .cmd(cmd),
    .sched_valid(sched_valid),
    .core_ce(core_ce)
  );

  // Shader cores (4x)
  genvar i;
  generate for (i=0; i<NUM_CORES; i++) begin : g_cores
    shader_core u_core (
      .clk(clk_sys), .rst(rst_sync),
      .clk_en(core_ce[i]),
      .sched_valid(sched_valid)
      // TODO: connect to L2 via AXI
    );
  end endgenerate

  // L2 + Pathfinder-lite prefetcher
  l2_cache u_l2 (
    .clk(clk_sys), .rst(rst_sync),
    .m_axi_araddr(m_axi_araddr), .m_axi_arvalid(m_axi_arvalid), .m_axi_arready(m_axi_arready),
    .m_axi_rdata(m_axi_rdata), .m_axi_rvalid(m_axi_rvalid), .m_axi_rready(m_axi_rready),
    .m_axi_awaddr(m_axi_awaddr), .m_axi_wdata(m_axi_wdata), .m_axi_wvalid(m_axi_wvalid), .m_axi_wready(m_axi_wready),
    .m_axi_bvalid(m_axi_bvalid), .m_axi_bready(m_axi_bready)
  );

  // Rasterizer (fixed-function)
  rasterizer u_rast (
    .clk(clk_sys), .rst(rst_sync),
    .cmd_valid(cmd_valid && cmd.cmd_type==8'd1), .cmd(cmd),
    .fb_valid(fb_valid), .fb_x(fb_x), .fb_y(fb_y), .fb_color(fb_color)
  );

  // Thermal sensor stub (replaces Solaris/Librarian fiction with real sensor)
  always_ff @(posedge clk_sys) begin
    if (rst_sync) sensor_out <= '0;
    else begin
      sensor_out.temp_c_x100 <= 16'd4500; // 45C stub
      sensor_out.power_mw    <= 16'd1200; // ~1.2W FPGA stub
    end
  end

endmodule

// Stubs — replace with real RTL iteratively
module command_processor (
  input logic clk, input logic rst,
  input logic s_axis_tvalid, output logic s_axis_tready,
  input logic [63:0] s_axis_tdata, input logic s_axis_tlast,
  output logic cmd_valid, input logic cmd_ready,
  output cmd_packet_t cmd
);
  assign s_axis_tready = cmd_ready || !cmd_valid;
  always_ff @(posedge clk) begin
    if (rst) cmd_valid <= 1'b0;
    else if (s_axis_tvalid && s_axis_tready) begin
      cmd <= s_axis_tdata[63:0]; // packed struct mapping
      cmd_valid <= 1'b1;
    end else if (cmd_ready) cmd_valid <= 1'b0;
  end
endmodule

module scheduler (
  input logic clk, input logic rst,
  input logic cmd_valid, output logic cmd_ready, input cmd_packet_t cmd,
  output logic sched_valid,
  output logic [NUM_CORES-1:0] core_ce
);
  assign cmd_ready = 1'b1;
  assign sched_valid = cmd_valid;
  assign core_ce = cmd_valid ? {NUM_CORES{1'b1}} : '0; // all cores enabled when work present
endmodule
