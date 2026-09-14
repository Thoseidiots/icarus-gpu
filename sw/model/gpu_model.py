"""
Icarus-GPU Python reference model — validates RTL behavior before synthesis.
Implements same triangle rasterizer + shader core dot-product.
"""
import numpy as np

FB_W, FB_H = 640, 480

def edge(a,b,p):
    return (p[0]-a[0])*(b[1]-a[1]) - (p[1]-a[1])*(b[0]-a[0])

def rasterize_triangle(v0,v1,v2):
    fb = np.zeros((FB_H, FB_W, 3), dtype=np.uint8)
    # bounding box
    min_x = max(0, min(v0[0], v1[0], v2[0]))
    max_x = min(FB_W-1, max(v0[0], v1[0], v2[0]))
    min_y = max(0, min(v0[1], v1[1], v2[1]))
    max_y = min(FB_H-1, max(v0[1], v1[1], v2[1]))
    # winding: ensure CCW
    area = edge(v0,v1,v2)
    if area == 0: return fb
    for y in range(min_y, max_y+1):
        for x in range(min_x, max_x+1):
            w0 = edge(v1,v2,(x,y))
            w1 = edge(v2,v0,(x,y))
            w2 = edge(v0,v1,(x,y))
            if (w0>=0 and w1>=0 and w2>=0) if area>0 else (w0<=0 and w1<=0 and w2<=0):
                fb[y,x] = [255,0,255] # magenta
    return fb

def shader_dot(a,b, precision='fp32'):
    """Oracle-real: variable precision"""
    if precision=='int8':
        return int(np.dot(a.astype(np.int8), b.astype(np.int8)))
    elif precision=='fp16':
        return float(np.dot(a.astype(np.float16), b.astype(np.float16)))
    else:
        return float(np.dot(a.astype(np.float32), b.astype(np.float32)))

if __name__ == "__main__":
    fb = rasterize_triangle((100,100),(500,100),(300,400))
    print(f"Rasterized pixels: {np.count_nonzero(fb)} / {FB_W*FB_H}")
    # save ppm for visual check
    with open("frame.ppm","wb") as f:
        f.write(f"P6\n{FB_W} {FB_H}\n255\n".encode())
        f.write(fb.tobytes())
    print("Wrote frame.ppm")

    # shader test
    a = np.array([1,2,3,4], dtype=np.float32)
    b = np.array([5,6,7,8], dtype=np.float32)
    print("dot fp32:", shader_dot(a,b,'fp32'), " int8:", shader_dot(a,b,'int8'))
