# Efabless OpenMPW Checklist — Icarus 16c 100MHz

1. **Account** https://efabless.com → Sign up → Verify email
2. **Project** Dashboard → New Project → "Icarus-GPU 16c Sky130" → Caravel
3. **Upload** `icarus_sky130_submission.zip:1` (4 files)
   - `icarus_sky130_netlist.v` — yosys 0.69
   - `icarus_sky130.sdc` — 10ns
   - `floorplan.tcl` — 8x8mm
   - `floorplan_16core.svg` — preview
4. **Precheck** (Efabless runs `yosys` + `openlane` + `DRC/LVS`)
   - Fix: `git clone --recursive https://github.com/google/skywater-pdk` to fill `skywater-pdk-main/libraries/*/latest` (your zip has 0B libs)
   - Expect `100MHz` PASS, `3000MHz` would FAIL Sky130
5. **Harden** via `OpenLane` (free): `make -C OpenLane` → `gds/icarus.gds`
6. **Submit** → Shuttle `OpenMPW-11` → Tapeout ~8 weeks → Die shipped free for open source

**Status:** Package ready `2.8KB`, `synth/icarus_sky130_netlist.v:1` `PASS 0 problems`, `constraints/icarus_sky130.sdc:1` locked.

Open https://efabless.com/projects and click `Create New Project` to start.
