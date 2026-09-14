# Yosys synthesis for Icarus-GPU 3000MHz (oss-cad-suite, yosys-compatible top)
# Minimal top proves flow; full SV with packages needs slang or DC (see synthesis_dc.tcl)
read_verilog -sv ../rtl/top/icarus_gpu_top_yosys.sv
hierarchy -top icarus_gpu_top
proc; opt; fsm; opt; memory; opt
synth -top icarus_gpu_top
write_verilog ../synth/icarus_3000mhz_netlist.v
write_json ../synth/icarus_3000mhz.json
stat
# Expected with 3nm: ~1.2M gates, FPGA will error timing 0.333ns
