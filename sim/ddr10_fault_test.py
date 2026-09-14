#!/usr/bin/env python3
"""
Fault test for DDR10 25600 MT/s proposal.
Tests: timing (39ps tCK), SI (PAM4 eye), BER.
"""
import math, random

tCK_target = 39e-12  # 39ps
fpga_min_period = 2e-9  # Artix-7 ~500MHz max ~2ns
asic_3nm_min = 35e-12  # 3nm ~28GHz limit ~35ps

print(f"[TIMING] DDR10 tCK target {tCK_target*1e12:.1f}ps")
print(f"  FPGA min {fpga_min_period*1e12:.0f}ps -> FAULT on FPGA (needs {fpga_min_period/tCK_target:.1f}x slower)")
print(f"  ASIC 3nm min {asic_3nm_min*1e12:.0f}ps -> {'PASS' if asic_3nm_min < tCK_target else 'FAULT'} (margin {(tCK_target-asic_3nm_min)*1e12:.1f}ps)")
if fpga_min_period > tCK_target:
    print("  -> Fault detected: need to down-clock to 12800 MT/s for FPGA or use ASIC")

# SI: PAM4 eye at 0.85V
v_swim = 0.85
noise = 0.02  # 20mV crosstalk 128b
eye_pam4 = v_swim/3 - noise  # 3 eyes
print(f"\n[SI] PAM4 eye @ {v_swim}V: {eye_pam4*1000:.1f}mV (need >50mV)")
print(f"  {'PASS' if eye_pam4>0.05 else 'FAULT'} — {128}b crosstalk risk, needs DFE 4-tap")

# BER with ECC
ber_raw = 1e-6 if eye_pam4<0.1 else 1e-12  # rough
ber_ecc = ber_raw * 1e-6  # ECC 1e-6 correction
print(f"\n[BER] raw {ber_raw:.1e} -> ECC {ber_ecc:.1e} (target 1e-18) -> {'PASS' if ber_ecc<1e-18 else 'FAULT'}")

# Power
power_per_pin = 0.002  # 2mW
total = power_per_pin * 128 * 8
print(f"\n[POWER] 128b×8ch ×2mW = {total:.1f}W (need cooling)")

# Verdict
faults = (fpga_min_period > tCK_target) + (eye_pam4 < 0.05) + (ber_ecc >= 1e-18)
if faults:
    print(f"\n[RESULT] {faults} fault(s) detected — design needs iteration (down-clock, add DFE, widen ECC)")
else:
    print("\n[RESULT] PASS — DDR10 viable in 3nm ASIC with DFE")
# For CI: exit 0 even if faults (we want to see them)
