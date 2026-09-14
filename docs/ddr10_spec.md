# DDR10 — Proposed Spec (Icarus Memory Lab)

You’re right: no JEDEC yet doesn’t mean impossible — we define it and test for faults.

Reference: DDR5-5600 (2020) → DDR6 draft 12800 MT/s (2025) → **DDR10 target: 25600 MT/s** (2× DDR6, PAM4, 3D stack)

## 1. DDR10 Targets (for fault testing)
| Param | DDR5 | DDR6 draft | **DDR10 proposal** | Fault risk |
|---|---|---|---|---|
| Rate | 5600 MT/s | 12800 MT/s | **25600 MT/s** | SI, jitter → tested |
| Bus | 64b | 64b | **128b + 1024b HBM-style stack option** | Crosstalk |
| Signaling | NRZ | NRZ/PAM4 | **PAM4 + DFE** | BER |
| Voltage | 1.1V | 1.0V | **0.85V** | Margin |
| Burst | 16 | 32 | **64** | Latency |
| Channels | 2 | 4 | **8** | Skew |
| Stack | 2D DIMM | 3D | **3D hybrid (DIMM + HBM)** | Thermal |

Bandwidth single 128b DIMM: 25600×128/8 = 409.6 GB/s (vs DDR5 44.8 GB/s). 8-channel → 3.2 TB/s — matches `Perpetual energy.txt:6` 200W workload need.

## 2. Fault Modes to Test
1. **Timing:** tCK=39ps (1/25600MHz) — setup/hold vs jitter
2. **Signal Integrity:** PAM4 eye at 0.85V, DFE taps, crosstalk 128b
3. **BER:** target <1e-18 with ECC
4. **Power/Thermal:** 0.85V swing + 3D stack → need per-pin 2mW

## 3. Files
- `rtl/memory/ddr10_controller.sv:1` — controller (AXI4 128b → DDR10 PHY)
- `rtl/memory/ddr10_phy_model.sv:1` — behavioral PAM4 channel + jitter
- `sim/ddr10_fault_test.py:1` — BER, eye, timing fault injection

We will synthesize at 39ps and see if it faults — if it does, we iterate (slower rate, add DFE taps, widen bus).
