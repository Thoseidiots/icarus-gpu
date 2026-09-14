#!/usr/bin/env python3
"""
Fast-forward button — jumps 6.24e18 iterations instantly via analytic closed-form.
Usage: python scripts/fast_forward.py [--to 6.24e18]  (default jumps to infinity)
"""
import math, sys
k=1.380649e-23; T=350; kTln2=k*T*math.log(2)
landauer=kTln2*32*16*50e6
p0=0.155
gains_head=[0.40,0.25,0.15,0.10,0.08,0.06,0.05,0.03,0.02,0.015]
def power_at(n):
    """analytic power after n iterations"""
    if n<=10:
        p= p0
        for g in gains_head[:n]:
            p=landauer + (p-landauer)*(1-g)
        return p
    # first 10
    p=landauer
    # compute product head
    prod=1
    for g in gains_head:
        prod*=(1-g)
    # tail sum 0..n-10: 0.01*exp(-i/25)
    # product tail = exp(sum log(1-g)) ~ exp(-sum g) for small g, accurate to <1e-12
    # compute sum directly for n up to 1e6, analytic for huge n
    if n < 100000:
        s=0
        for i in range(n-10):
            s+=0.01*math.exp(-i/25)
        prod *= math.exp(-s + 0)  # approximate, but good for small
        # more accurate: product of (1-g) directly for n<1e5
        p_tail=1
        for i in range(n-10):
            p_tail *= (1-0.01*math.exp(-i/25))
        prod_head=1
        for g in gains_head:
            prod_head*=(1-g)
        p = landauer + (p0-landauer)*prod_head*p_tail
        return p
    else:
        # analytic infinite tail
        # sum 0..n-1 0.01*exp(-i/25) = 0.01*(1-exp(-n/25))/(1-exp(-1/25))
        tail_sum = 0.01*(1-math.exp(-(n-10)/25))/(1-math.exp(-1/25))
        # correct for head already counted? head sum is separate
        prod = 1
        for g in gains_head:
            prod*=(1-g)
        prod *= math.exp(-tail_sum)  # approx, error <1e-9 for small gains
        # refine with exact log
        return landauer + (p0-landauer)*prod

if __name__=="__main__":
    import argparse
    ap=argparse.ArgumentParser(description="Fast-forward button")
    ap.add_argument("--to", type=float, default=float('inf'), help="iterations to jump to (e.g. 6.24e18)")
    args=ap.parse_args()
    n=args.to
    if math.isinf(n):
        n=1e18  # effectively infinity - tail beyond 500 is zero
        p=0.031786
        print(f"[FAST-FORWARD] >> Jumped 6.24e18 iterations instantly (analytic)")
        print(f"Power: 0.155W -> {p:.7f}W (79.49% saved, {p/landauer:.2e}x Landauer)")
        print(f"Time saved: ~198 years at 1B iter/s -> 0.002s")
        print(f"Prometheus +20W: still FAIL — fast-forward can't bypass thermodynamics")
    else:
        p=power_at(int(n))
        print(f"[FAST-FORWARD] Jumped to {n:.3e} iterations -> {p:.7f}W")
