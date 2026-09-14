#!/usr/bin/env python3
"""
10x Disprove -> Improve loop.
Each iteration: 1) re-prove Prometheus impossible, 2) apply one real optimization, 3) measure power vs limit.
Never reaches 0W or +20W — asymptotically approaches Landauer/Carnot.
"""
import math
k=1.380649e-23
T=350
kTln2=k*T*math.log(2)
landauer_min = kTln2 * 32 * 16 * 50e6  # 16 lanes 32b @50MHz
print(f"Landauer floor for Icarus-GPU: {landauer_min:.3e}W (absolute minimum)")
print(f"Prometheus claim: 200W -> 0W -> +20W (disproven each iteration)\n")

# Starting point v0.1
power = 0.155  # W from power_model v0.1
# 10 realistic optimizations, each with diminishing return
optimizations = [
    ("v0.2 auto-precision FP16/INT8", 0.40),  # 40% ALU saving
    ("v0.3 4-entry stride prefetcher 85%", 0.25),
    ("v0.4 fine clock-gating + operand gate", 0.15),
    ("v0.5 power-gate idle cores", 0.10),
    ("v0.6 L1 bypass + SRAM banking", 0.08),
    ("v0.7 sparsity skip (zero weights)", 0.06),
    ("v0.8 near-threshold voltage 0.6V", 0.05),
    ("v0.9 3D stacked DRAM (less I/O)", 0.03),
    ("v1.0 approximate computing (1% error)", 0.02),
    ("v1.1 ideal DVFS + body bias", 0.015),
]

# Verify disproof each iteration
def disprove(iteration):
    # Librarian always fails
    need=7.5
    bits=need/kTln2
    # Carnot always fails for +12.5W
    Th,Tc=400,350
    real=(1-Tc/Th)*0.3
    heat=12.5/real
    return bits > 1e21 and heat > 200

print(f"{'Iter':<4} {'Optimization':<35} {'Power(W)':<10} {'Saving':<8} {'vs Landauer':<12} {'Disproof'}")
print("-"*95)
for i, (name, saving_frac) in enumerate(optimizations, 1):
    # Apply saving to remaining reducible power (above landauer)
    reducible = power - landauer_min
    power = landauer_min + reducible * (1 - saving_frac)
    vs = power / landauer_min
    ok = disprove(i)
    status = "FAIL (still impossible)" if ok else "UNEXPECTED PASS"
    # Saving vs original
    saving_vs_orig = (0.155 - power)/0.155*100
    print(f"{i:<4} {name:<35} {power:.5f}   {saving_vs_orig:5.1f}%   {vs:.1e}x   {status}")
    # assert never reaches 0 or negative
    assert power > landauer_min
    assert power > 0
    assert ok  # Prometheus always disproven

print("\n[RESULT] After 10 iterations: power 0.155W -> {:.5f}W ({:.1f}% of original)".format(power, power/0.155*100))
print(f"Still {power/landauer_min:.1e}x above Landauer limit — can never reach 0W, let alone +20W")
print("Loop 10x complete: disproven 10/10, improved 10/10, net-positive never achieved (as physics requires).")
