// Yosys-compatible top (flattened from icarus_pkg)
module icarus_gpu_top #(
  parameter NUM_CORES=16,
  parameter LANES_PER_CORE=4
) (
  input  logic clk_sys,
  input  logic rst_n,
  input  logic                  s_axis_tvalid,
  output logic                  s_axis_tready,
  input  logic [63:0] s_axis_tdata,
  input  logic                  s_axis_tlast,
  output logic [31:0] m_axi_araddr,
  output logic                  m_axi_arvalid,
  input  logic                  m_axi_arready,
  input  logic [63:0] m_axi_rdata,
  input  logic                  m_axi_rvalid,
  output logic                  m_axi_rready,
  output logic [31:0] m_axi_awaddr,
  output logic [63:0] m_axi_wdata,
  output logic                  m_axi_wvalid,
  input  logic                  m_axi_wready,
  input  logic                  m_axi_bvalid,
  output logic                  m_axi_bready,
  output logic                  fb_valid,
  output logic [15:0]           fb_x,
  output logic [15:0]           fb_y,
  output logic [31:0]           fb_color,
  output logic [31:0] sensor_out
);
  logic rst_sync; assign rst_sync = ~rst_n;
  logic [15:0] core_ce;
  // stubs
  assign s_axis_tready = 1'b1;
  assign m_axi_araddr=0; assign m_axi_arvalid=0; assign m_axi_rready=1;
  assign m_axi_awaddr=0; assign m_axi_wdata=0; assign m_axi_wvalid=0; assign m_axi_bready=1;
  assign fb_valid=0; assign fb_x=0; assign fb_y=0; assign fb_color=0; assign sensor_out=0;
endmodule
