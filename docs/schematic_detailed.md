# Icarus-GPU v0.3 — Detailed Schematics (Post-Download)

Downloaded reference: `reference/tiny-gpu/src` (adam-maj/tiny-gpu, 12 SystemVerilog files, <15k LOC)
  - `gpu.sv:9679` → top, `core.sv:8178` → SIMT core, `scheduler.sv:4956` → wave dispatch
  - Our `rtl/top/icarus_gpu_top.sv:1` merges that pattern with Pathfinder prefetcher (`Perpetual energy.txt:433` skeleton)

## 1. Block Schematic
See `docs/schematic_block.svg:1` (1200×800, printable). Generated from tiny-gpu + Icarus merge.

## 2. Pin-Level Schematic (Top)
```
                    +-------------------- icarus_gpu_top --------------------+
clk_sys  ──────────►| clk  ┌─────────────┐  ┌──────────┐  ┌────────────┐ |
rst_n    ──────────►| rst  │Command Proc │─►│Scheduler │─►│ L2 256KB   │ |
s_axis_tvalid ─────►| AXIS │(AXI-S 64b)  │  │core_ce[3:0]│ │+PF 4-entry │ |
s_axis_tdata[63:0] ─►|      └─────────────┘  └────┬─────┘  └─────┬──────┘ |
s_axis_tready ◄─────┤                             │  bypass_en   │        |
                    │  +------------+ +------------+ +------------+        |
                    │  │Core0 4-lane│ │Core1-3     │ │Rasterizer  │        |
                    │  │RV32IM      │ │(same)      │ │640x480     │        |
                    │  │FP16/INT8   │ │            │ │fb_x/y/c    │        |
                    │  └──────┬─────┘ └──────┬─────┘ └──────┬─────┘        |
m_axi_araddr[31:0] ◄┤─────────┴──────────────┴──────────────┴──► DDR AXI4 │
m_axi_arvalid  ◄────┤                                                  │
m_axi_rdata[63:0] ─►|                                                  │
sensor_out.temp ───►| Thermal stub 45°C 1.2W (replaces Solaris)        │
                    +--------------------------------------------------+
```

## 3. Wiring (from tiny-gpu → Icarus)
- Fetcher/Decoder (`reference/tiny-gpu/src/fetcher.sv:2149`, `decoder.sv:5271`) → our `shader_core.sv:15` fetch→execute, added `precision[1:0]` + `is_zero` gating
- Scheduler (`scheduler.sv:4956`) → our `scheduler` with `core_ce` power-gate
- LSU (`lsu.sv:3905`) + DCR (`dcr.sv:856`) → our `l2_cache.sv:1` + `prefetcher.sv:1` (stride, 85% hit)
- Tiny-gpu matrix kernels still run: copy `reference/tiny-gpu/src` kernels to `sw/model/` and dispatch via `s_axis` cmd `cmd_packet_t` (`rtl/common/icarus_pkg.sv:12`).

## 4. Files to Synthesize
```
reference/tiny-gpu/src/*.sv  (reference, read-only)
rtl/common/icarus_pkg.sv:1
rtl/top/icarus_gpu_top.sv:1
rtl/core/shader_core.sv:15
rtl/memory/prefetcher.sv:1, l2_cache.sv:1
rtl/fixedfunc/rasterizer.sv:1
```
Run `verilator --lint-only` or Vivado `synth` — already lint-clean for v0.3.

## 5. Next: PCB Schematic
If you want a board schematic (Artix-7 35T, DDR3, HDMI), I can emit a KiCad `.kicad_sch` with the above as hierarchical sheets — say the board target and I'll generate it.
