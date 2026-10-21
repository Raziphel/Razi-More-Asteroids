#!/usr/bin/env python3
"""Verify modified art keeps sprite dimensions and silhouette pixel-for-pixel."""
from pathlib import Path
import subprocess
import sys
import zlib
sys.path.insert(0, str(Path(__file__).resolve().parent))
from retouch_asteroid_graphics import ROOT, assets, chunks_of, unfilter, MARKER

def read(png):
    chunks=list(chunks_of(png))
    header=next(d for t,d in chunks if t==b"IHDR")
    import struct
    w,h,depth,kind,_,_,interlace=struct.unpack(">IIBBBBB",header)
    assert (depth,kind,interlace)==(8,6,0)
    rows,_=unfilter(zlib.decompress(b"".join(d for t,d in chunks if t==b"IDAT")),w,h)
    alpha=b"".join(row[3::4] for row in rows)
    return (w,h,alpha),chunks

n=0
for material,path in assets():
    relative=path.relative_to(ROOT)
    baseline=subprocess.run(["git","show","HEAD:"+relative.as_posix()],cwd=ROOT,
        check=True,capture_output=True).stdout
    edited=path.read_bytes()
    original_shape,_=read(baseline)
    new_shape,chunks=read(edited)
    assert original_shape==new_shape, f"Altered silhouette/alpha: {relative}"
    if baseline!=edited:
        assert any(t==b"tEXt" and d==MARKER for t,d in chunks), relative
    n+=1
print(f"PASS: {n} sprite dimensions, silhouettes, alpha channels intact")
