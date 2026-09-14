`default_nettype none
`include "defines.v"
module user_project_wrapper #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vdda1, inout vdda2, inout vssa1, inout vssa2,
    inout vccd1, inout vccd2, inout vssd1, inout vssd2,
`endif
    input wire wb_clk_i, wb_rst_i, wbs_stb_i, wbs_cyc_i, wbs_we_i,
    input wire [3:0] wbs_sel_i,
    input wire [31:0] wbs_dat_i, wbs_adr_i,
    output wire wbs_ack_o, output wire [31:0] wbs_dat_o,
    input wire [37:0] io_in, output wire [37:0] io_out, output wire [37:0] io_oeb,
    input wire user_clock2, output wire user_irq
);
  user_proj_example mprj (
`ifdef USE_POWER_PINS
    .vdda1(vdda1), .vdda2(vdda2), .vssa1(vssa1), .vssa2(vssa2),
    .vccd1(vccd1), .vccd2(vccd2), .vssd1(vssd1), .vssd2(vssd2),
`endif
    .wb_clk_i(wb_clk_i), .wb_rst_i(wb_rst_i), .wbs_stb_i(wbs_stb_i), .wbs_cyc_i(wbs_cyc_i),
    .wbs_we_i(wbs_we_i), .wbs_sel_i(wbs_sel_i), .wbs_dat_i(wbs_dat_i), .wbs_adr_i(wbs_adr_i),
    .wbs_ack_o(wbs_ack_o), .wbs_dat_o(wbs_dat_o),
    .io_in(io_in), .io_out(io_out), .io_oeb(io_oeb), .user_clock2(user_clock2), .user_irq(user_irq)
  );
endmodule
`default_nettype wire
