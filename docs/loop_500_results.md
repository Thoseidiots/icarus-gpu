# 500x Loop

`scripts/loop_500.py` — same 10 strong opts + 490 decaying micro-opts 1%→0%.

| Iter | Power | Saved |
|---|---|---|
|1|0.0930000W|40.0%|
|10|0.0410468W|73.5%|
|50|0.0334664W|78.4%|
|100|0.0320083W|79.35%|
|200|0.0317900W|79.49%|
|500|0.0317860W|79.49%|

Converged at ~0.03179W (20.5% of 0.155W), 3.71e8× above Landauer 8.575e-11W.
Iterations 100→500 added only 0.00022W (0.14%) — flat asymptote. Prometheus `+20W` still FAIL 500/500 (needs 2.24e21 bits/s + 333W heat).

Improvement is real but bounded — perpetual never becomes true.
