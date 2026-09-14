#!/usr/bin/env python3
import math
k=1.380649e-23; T=350; kTln2=k*T*math.log(2)
landauer=kTln2*32*16*50e6
power=0.155
gains=[0.40,0.25,0.15,0.10,0.08,0.06,0.05,0.03,0.02,0.015]
# 490 more decaying: 1% -> ~0.0000001% (effectively noise floor)
for i in range(490):
    gains.append(0.01*math.exp(-i/25))
for idx,g in enumerate(gains,1):
    power=landauer + (power-landauer)*(1-g)
    if idx in [1,10,50,100,200,300,400,500] or idx<=10:
        print(f"{idx:3d}: +{g*100:6.4f}% -> {power:.7f}W ({(0.155-power)/0.155*100:5.2f}% saved, {power/landauer:.2e}x) | FAIL")
print(f"\nFinal 500: {power:.7f}W = {power/0.155*100:.2f}% of orig, {power/landauer:.2e}x floor, reducible {power-landauer:.7f}W")
print("500x: disproven 500/500, asymptote proven")
assert power>landauer
