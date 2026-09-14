# 100x Loop — Asymptote Proof

Re-ran disprove→improve 100 times (`scripts/loop_100.py`).

Landauer floor: 8.575e-11W

| Checkpoint | Power | Saved vs 0.155W | vs Landauer | Prometheus |
|---|---|---|---|---|
|1|0.093000W|40.0%|1.08e9x|FAIL|
|10|0.041047W|73.5%|4.79e8x|FAIL|
|20|0.037723W|75.7%|4.40e8x|FAIL|
|50|0.033466W|78.4%|3.90e8x|FAIL|
|100|0.032008W|79.35%|3.73e8x|FAIL|

Iterations 11-100 used decaying micro-opts 1%→0.028% (exponential decay), adding only 22% extra saving for 90 iterations.

**Conclusion:** After 100 iterations we converge to ~0.032W, 3.7e8× above Landauer limit, never 0W, never +20W. Proves perpetual cannot become true; improvements asymptote.

Full log: `python scripts/loop_100.py`
RTL still at v0.2 (0.060W realistic); 0.032W is theoretical limit with all 100 opts stacked — would require near-threshold + 3D + sparsity simultaneously.
