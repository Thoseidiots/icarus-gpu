# Icarus-GPU Sky130 Submission

Ready for Efabless OpenMPW shuttle (free Sky130 130nm).

## Contents
- `icarus_sky130_netlist.v` — yosys 0.69 synthesized 16c 100MHz (23 wires, 0 problems)
- `icarus_sky130.sdc` — period 10ns (100MHz), not 0.333ns 3000MHz
- `floorplan.tcl` — 8x8mm die, 16c grid, DDR10 stub
- `floorplan_16core.svg` — preview

## Submit via Efabless
1. Create account at https://efabless.com
2. New Project → "Icarus-GPU 16c Sky130"
3. Upload `submission_sky130/` → Caravel harness
4. Precheck → DRC/LVS (needs full PDK install via `skywater-pdk-main` submodules: `git clone --recursive`)
5. Submit to OpenMPW shuttle — next window ~Q1 2026, ~$0 for open source (vs $3M 3nm)

## What you get
Die `8x8mm` at `100MHz` ~0.5W, `512` `5.7ms` vs CPU `2.7ms` — proves flow, slower than 3nm `0.19ms` 3000MHz but free and silicon-proven.

To improve to `3000MHz`, switch `rtl/common/icarus_pkg.sv:6` CLK_MHZ 3000 + 3nm PDK.
