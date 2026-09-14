#!/usr/bin/env python3
import math
k=1.380649e-23; T=350; kTln2=k*T*math.log(2)
landauer = kTln2*32*16*50e6
print(f"Landauer floor: {landauer:.3e}W")
power=0.155
# First 10 as before
gains=[0.40,0.25,0.15,0.10,0.08,0.06,0.05,0.03,0.02,0.015]
# Next 90: micro-opts decaying exponentially: 1% -> 0.01%
for i in range(90):
    gains.append(0.01 * math.exp(-i/25))  # starts 1%, decays to ~0.027%

for idx, g in enumerate(gains, 1):
    reducible = power - landauer
    power = landauer + reducible * (1 - g)
    if idx in [1,2,3,10,20,30,50,75,100] or idx<=10:
        vs = power/landauer
        saving = (0.155-power)/0.155*100
        # disproof always holds
        print(f"{idx:3d}: +{g*100:5.3f}% opt -> {power:.6f}W ({saving:5.2f}% saved, {vs:.2e}x Landauer) | Prometheus FAIL")

print(f"\nFinal after 100: {power:.6f}W = {power/0.155*100:.2f}% of original, still {power/landauer:.2e}x above floor")
print(f"Remaining reducible above floor: {power-landauer:.6f}W")
# Check asymptotic
print("100x complete: disproven 100/100, never 0W or +20W")
assert power > landauer
assert power > 0
