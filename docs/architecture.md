# Icarus-GPU v0.1 — Realistic Architecture
Derived from Prometheus ideas, grounded in real physics.

## 1. What we keep vs. discard from Perpetual energy.txt
| Prometheus Idea | Verdict | Real Implementation |
|---|---|---|
| Pathfinder (AI prefetch) | VIABLE | Stride + correlation prefetcher into L2; optional tiny MLP predictor in FPGA LUTs |
| Conductor (per-core DVFS) | VIABLE | Clock-gating + FPGA clock enables; DVFS controller stub (voltage fixed on FPGA) |
| Oracle (variable precision) | VIABLE | Shader ALU supports FP32/FP16/INT8 — saves power, realistic |
| Synapse (reversible logic) | NOT VIABLE as claimed | Use normal adiabatic *clock gating* — true reversible logic needs cryogenic/quantum, not net-positive |
| Metronome (async clocking) | PARTIAL | GALS + clock gating, not fully asynchronous (timing closure too hard for v0.1) |
| Diamond Soul (CNFET) | FUTURE | Map to FPGA LUTs / standard 28nm for now; CNFET is lab-stage |
| Nexus Bridge (wireless power) | NOT VIABLE on-chip | Use low-impedance PDN + decoupling caps |
| Helios-Prime (QW thermoelectric) | LAB ONLY | Replace with thermal sensors + throttling; TE efficiency ~5-8%, not 15W |
| AERC ambient harvest | NEGLIGIBLE | Drop — RF/vibration harvesting = microwatts, not watts |
| Maxwell Demon / Librarian IEC | VIOLATES 2nd LAW | Sorting random data *costs* kT*ln2 per bit (Landauer limit) — cannot generate power |

**Power reality:** 200W workload → ~200W wall power. Our goal is perf/W, not 0W.

## 2. Icarus-GPU v0.1 Block Diagram
```
PCIe/AXI Cmd ─> Command Processor ─> Scheduler ─> 4x Shader Cores (SIMT x4 lanes)
                    │                    │              │
                    └──> Rasterizer ──> Texture Unit ──> L2 Cache (256KB) ──> DDR Controller (AXI4)
                                      └─> ROP / Framebuffer
```

## 3. Specs v0.1
- **Shader Cores:** 4 cores × 4 lanes = 16 threads per wave. RV32IM base + vector extensions (vadd, vmul, vdot for FP32/FP16).
- **Frontend:** Command Processor accepts draw/dispatch packets via AXI4-Stream (1024-bit, reused from Pathfinder spec).
- **Fixed Function:** Simple triangle rasterizer (edge-function), no texture sampling yet (stub), ROP does depth test + blend.
- **Memory:** L1 per-core 16KB, shared L2 256KB, AXI4 64-bit to DDR. Stride prefetcher (Pathfinder-lite) between L2 and DDR.
- **Clock/Power:** Single clk_sys + per-core clock enables (Conductor-lite). Thermal sensor stub.
- **Target:** FPGA (Lattice ECP5 / Xilinx Artix-7) or simulation with Verilator. ~50-100 MHz, ~10k LUTs.

## 4. File Map
- `rtl/common/icarus_pkg.sv` — params, ISA defines
- `rtl/common/axis_if.sv`, `axi_if.sv` — reused bus interfaces
- `rtl/core/shader_core.sv` — single SIMT core
- `rtl/core/scheduler.sv` — wave scheduler
- `rtl/fixedfunc/rasterizer.sv` — edge-function rasterizer
- `rtl/memory/l2_cache.sv`, `prefetcher.sv` — cache + Pathfinder-lite
- `rtl/top/icarus_gpu_top.sv` — top level
- `sim/` — Verilator/Cocotb testbench
- `sw/model/gpu_model.py` — Python reference model

## 5. Roadmap
v0.1: Shader cores execute compute kernels, rasterizer draws single triangle to framebuffer (simulation).
v0.2: Texture stub + variable precision (FP16).
v0.3: Multi-wave scheduler + prefetcher tuning.
v0.4: FPGA synthesis + HDMI out.

## 6. Prometheus → Icarus Mapping
We preserve the *intent* (efficiency) without violating thermodynamics. No net-positive claims.
