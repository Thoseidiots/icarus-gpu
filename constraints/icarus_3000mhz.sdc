# Icarus-GPU v0.5 3000MHz SDC — locked per icarus_pkg.sv:6
# Period 333.33ps for 3000MHz, 3nm ASIC target
create_clock -name clk_sys -period 0.333 [get_ports clk_sys]
create_clock -name clk_phy -period 0.078 [get_ports clk_phy]  # DDR10 12.8GHz half-rate 78ps
set_clock_uncertainty -setup 0.02 [get_clocks clk_sys]
set_clock_uncertainty -hold 0.01 [get_clocks clk_sys]
set_input_delay -clock clk_sys -max 0.08 [get_ports s_axis_tdata*]
set_output_delay -clock clk_sys -max 0.08 [get_ports m_axi_*]
set_false_path -from [get_ports rst_n]
# 16 cores: max fanout, derate for 3000MHz
set_max_fanout 16 [all_inputs]
set_max_capacitance 0.05 [all_outputs]
# FPGA will fault: Artix-7 min period 2ns >0.333ns
