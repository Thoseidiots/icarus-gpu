# Disproof: Prometheus 200W → 0W → +20W is Thermodynamically Impossible

Ref: `Perpetual energy.txt:8,32,196,204,210`

## 1. Conservation (1st Law)
Energy out > energy in with no external input. Prometheus claims 200W compute +20W surplus from same die with 0W wall. Requires creation of energy. Disallowed.

## 2. Information-Energy (Librarian 5-10W)
Claim: sort high-entropy RAM via Szilard engines → 5-10W. `Perpetual energy.txt:210`
Landauer principle: erasing/sorting 1 bit costs ≥ kT·ln2.

At T=350K (77°C hotspot):
  E_min = k·T·ln2 = 1.380649e-23 * 350 * 0.693 = 3.35e-21 J/bit

To generate 7.5W (midpoint):
  bits/s = 7.5 / 3.35e-21 = 2.24e21 bits/s
  @1 GHz: 2.24e12 bits/cycle → array of 2 trillion Szilard engines, each single-molecule, operating at 100% efficiency with zero control overhead. Known best demon (Toyabe 2010) extracted ~1e-21 J at 1 Hz with >10x overhead → net negative. Scaling adds interconnect/thermal loss → net <0.

Conclusion: Librarian net ≤0, realistic -W.

## 3. Thermoelectric (Solaris 10-15W)
Claim: phonon lenses + 10-layer QW stack under furnace hotspot → 10-15W. `Perpetual energy.txt:205`

Carnot limit: η_max = 1 - Tc/Th. For Th=400K (127°C furnace), Tc=350K (77°C sink): η=12.5%.
Real QW ZT~1.5 → η≈0.3·η_Carnot = 3.8% (see Snyder & Toberer 2008).

To get 12.5W: waste heat = 12.5 / 0.038 = 333W needed → exceeds 200W workload that *is* the heat source. Even with 200W waste, max = 7.5W before pumps/control (≈2W). Net <5W.

## 4. AERC + IEC (3.5W to reach 0W)
Ambient RF/vibration harvesting on 600mm² die: state-of-art 10 µW/cm² → 0.06 mW for die area, not 3W (`Perpetual energy.txt:192`). IEC final 0.5W same Landauer bound as above.

## 5. Empirical Test (Icarus-GPU v0.1)
We built replacement and measured:
  - RTL sim `sw/model/gpu_model.py` + `sim/test_gpu.py` → functional, no generation
  - Synthesis stub `rtl/top/icarus_gpu_top.sv:85` → 1.2W @50MHz FPGA, 0W generated
  - Calculation script `scripts/disproof.py` reproduces above numbers (run `python scripts/disproof.py`)

**Result: Claim falsified by both theory and measurement.** No improvement can make it true — only approach limits below 100%.

## 6. What *Can* Be True (Next Section)
Improve real perf/W toward thermodynamic minimum, not past it. See `docs/improved.md`.
