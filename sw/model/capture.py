#!/usr/bin/env python3
"""
Live-instance capture — records running GPU state each cycle like video frames.
Mirrors rtl/debug/capture.sv (would tap pc, regs, fb in real RTL).
"""
import json, pathlib
from gpu_model import rasterize_triangle, shader_dot
import numpy as np

trace_path = pathlib.Path(__file__).parent / "capture.trace.json"
frames = []

# Simulate 60 "cycles" of running code: each cycle does a dot + raster progress
# This is the "new instance" you mentioned — we capture it as it runs
for cycle in range(60):
    # capture shader state
    a = np.array([cycle, cycle+1, cycle+2, cycle+3], dtype=np.float32)
    b = np.array([1,2,3,4], dtype=np.float32)
    dot = shader_dot(a,b, 'fp32')
    # capture raster state (partial frame)
    # we capture every 10 cycles a frame snapshot
    fb_snapshot = None
    if cycle % 10 == 0:
        v0 = (100+cycle, 100)
        v1 = (500, 100+cycle//2)
        v2 = (300, 400-cycle)
        fb = rasterize_triangle(v0,v1,v2)
        fb_snapshot = int(np.count_nonzero(fb)//3)
    frames.append({
        "cycle": cycle,
        "pc": cycle*4,
        "dot": float(dot),
        "fb_pixels": fb_snapshot,
        "timestamp_ps": cycle*2500  # 400MHz -> 2500ps per cycle
    })

trace_path.write_text(json.dumps({"frames": frames, "meta": {"total_cycles": 60, "clk_ps": 2500}}))
print(f"[CAPTURE] Recorded {len(frames)} cycles -> {trace_path} ({trace_path.stat().st_size} bytes)")
print(f"  Example frame 30: {frames[30]}")
print(f"  Seekable: can jump to any cycle without re-executing from 0 (like video timeline)")
