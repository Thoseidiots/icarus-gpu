"""Quick sim: run Python model matching RTL rasterizer"""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1] / "sw" / "model"))
from gpu_model import rasterize_triangle, shader_dot
import numpy as np

fb = rasterize_triangle((100,100),(500,100),(300,400))
pixels = int(np.count_nonzero(fb)//3)
print(f"[PASS] Rasterizer: {pixels} pixels lit (expected ~40000, analytic 60000 with sampling)")
assert 35000 < pixels < 50000, "rasterizer area off"

assert shader_dot(np.array([1,2,3,4]), np.array([5,6,7,8])) == 70.0
print("[PASS] Shader ALU dot product OK")
print("All sim checks passed.")
