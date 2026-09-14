// Caravel user project — Icarus 16c 100MHz wrapper for precheck
// Wraps icarus_gpu_top_yosys for Efabless
`default_nettype none
module user_proj_example #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vdda1, inout vdda2, inout vssa1, inout vssa2,
    inout vccd1, inout vccd2, inout vssd1, inout vssd2,
`endif
    input wire wb_clk_i,
    input wire wb_rst_i,
    input wire wbs_stb_i,
    input wire wbs_cyc_i,
    input wire wbs_we_i,
    input wire [3:0] wbs_sel_i,
    input wire [31:0] wbs_dat_i,
    input wire [31:0] wbs_adr_i,
    output wire wbs_ack_o,
    output wire [31:0] wbs_dat_o,
    input wire [37:0] io_in,
    output wire [37:0] io_out,
    output wire [37:0] io_oeb,
    input wire user_clock2,
    output wire user_irq
);
  wire clk = wb_clk_i;
  wire rst = wb_rst_i;
  // Tie Icarus to Caravel IO: io_in[7:0] -> s_axis, io_out -> fb
  wire s_axis_tvalid = wbs_stb_i;
  wire s_axis_tready;
  wire [63:0] s_axis_tdata = {wbs_dat_i, wbs_dat_i};
  wire s_axis_tlast = 1'b0;
  wire [31:0] sensor_out;
  icarus_gpu_top_yosys u_icarus (
    .clk_sys(clk), .rst_n(~rst),
    .s_axis_tvalid(s_axis_tvalid), .s_axis_tready(s_axis_tready),
    .s_axis_tdata(s_axis_tdata), .s_axis_tlast(s_axis_tlast),
    .m_axi_araddr(), .m_axi_arvalid(), .m_axi_arready(1'b1),
    .m_axi_rdata(64'b0), .m_axi_rvalid(1'b0), .m_axi_rready(),
    .m_axi_awaddr(), .m_axi_wdata(), .m_axi_wvalid(), .m_axi_wready(1'b1),
    .m_axi_bvalid(1'b0), .m_axi_bready(),
    .fb_valid(), .fb_x(), .fb_y(), .fb_color(), .sensor_out(sensor_out)
  );
  assign wbs_ack_o = s_axis_tready;
  assign wbs_dat_o = sensor_out;
  assign io_out = 38'b0;
  assign io_oeb = 38'b0;
  assign user_irq = 1'b0;
endmodule
`default_nettype wire
