# 10x Loop Results

Repeated `disproof -> improve` 10 times as requested.

## Method
Each iteration re-ran `scripts/disproof.py` (Librarian needs 2.24e21 bits/s, Solaris needs 333W heat >200W) — always FAIL.
Then applied one real optimization with diminishing returns on reducible power above Landauer floor 8.575e-11W.

## Log (`scripts/loop_10.py`)
| Iter | Optimization | Power | Saving vs orig | vs Landauer | Disproof |
|---|---|---|---|---|---|
|1|auto-precision FP16/INT8|0.09300W|40.0%|1.1e9x|FAIL|
|2|stride prefetcher 85%|0.06975W|55.0%|8.1e8x|FAIL|
|3|clock-gating|0.05929W|61.7%|6.9e8x|FAIL|
|4|power-gate idle cores|0.05336W|65.6%|6.2e8x|FAIL|
|5|L1 bypass|0.04909W|68.3%|5.7e8x|FAIL|
|6|sparsity|0.04614W|70.2%|5.4e8x|FAIL|
|7|near-threshold 0.6V|0.04384W|71.7%|5.1e8x|FAIL|
|8|3D DRAM|0.04252W|72.6%|5.0e8x|FAIL|
|9|approximate 1%|0.04167W|73.1%|4.9e8x|FAIL|
|10|ideal DVFS|0.04105W|73.5%|4.8e8x|FAIL|

Final: 0.155W → 0.04105W (26.5% of original, 73.5% saved), still 4.8e8× above Landauer floor.
Never reaches 0W, never +20W.

Conclusion: Loop proves the claim cannot become true; real GPU can only asymptotically approach limit. See `rtl/` for v0.2 implemented; v0.3-1.1 modeled in estimator — next step is to implement v0.3 prefetcher in RTL.
