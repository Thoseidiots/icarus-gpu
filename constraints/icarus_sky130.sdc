# Icarus-GPU Sky130 free — 100MHz (10ns) for open PDK
# Sky130 HD lib max ~100-150MHz, not 3000MHz
create_clock -name clk_sys -period 10.0 [get_ports clk_sys]
set_clock_uncertainty -setup 0.5 [get_clocks clk_sys]
# Retarget from 3000MHz 0.333ns -> 10ns for Sky130
# Power ~0.5W free version vs 7.76W 3nm 3000MHz
