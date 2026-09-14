# Design Compiler 3nm synthesis — Icarus 3000MHz
set TOP icarus_gpu_top
set CLK_PERIOD 0.333
read_sverilog -I ../rtl/common {../rtl/common/icarus_pkg.sv ../rtl/top/icarus_gpu_top.sv ../rtl/core/shader_core.sv ../rtl/memory/prefetcher.sv ../rtl/memory/l2_cache.sv ../rtl/memory/ddr10_controller.sv ../rtl/fixedfunc/rasterizer.sv ../rtl/debug/capture.sv}
current_design $TOP
link
read_sdc ../constraints/icarus_3000mhz.sdc
compile_ultra -timing_high_effort
report_timing -max_paths 10 > ../synth/timing_3000mhz.rpt
report_area > ../synth/area_3000mhz.rpt
report_power > ../synth/power_3000mhz.rpt
write -format verilog -hierarchy -output ../synth/${TOP}_3000mhz_netlist.v
# 3nm: expect ~4.2ns slack negative on FPGA, ~+0.02ns on 3nm with proper PDK
