#!/usr/bin/env python3
"""
Disproof calculator for Prometheus claims.
Run: python scripts/disproof.py — exits non-zero if claim were possible (it isn't).
"""
import math
k=1.380649e-23
T=350
kTln2=k*T*math.log(2)
print(f"[DISPROOF] kT ln2 @ {T}K = {kTln2:.3e} J/bit")

# Librarian test
need_W=7.5
bits_per_s = need_W / kTln2
print(f"[LIBRARIAN] To generate {need_W}W need {bits_per_s:.3e} bits/s")
# Assume wildly optimistic 1e12 engines at 1 GHz
engines=1e12
max_bits = engines * 1e9  # 1 bit per engine per cycle
print(f"[LIBRARIAN] With {engines:.0e} engines @1GHz max {max_bits:.3e} bits/s -> short by {bits_per_s/max_bits:.1f}x")
assert bits_per_s > max_bits, "Would need >1e12 engines"
print("[FAIL] Librarian impossible -> claim falsified")

# Solaris test
Th,Tc=400,350
carnot=1-Tc/Th
real=carnot*0.3
need=12.5
heat_needed=need/real
print(f"[SOLARIS] Carnot {carnot*100:.1f}%, realistic {real*100:.1f}%, heat needed for {need}W = {heat_needed:.1f}W")
assert heat_needed > 200, "Needs more waste heat than workload provides"
print("[FAIL] Solaris impossible -> claim falsified")

# Overall
print("[RESULT] Prometheus 200W->0W->+20W DISPROVEN. No parameter tweak can fix — violates 1st/2nd law.")
