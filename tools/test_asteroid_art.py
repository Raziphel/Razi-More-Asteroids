#!/usr/bin/env python3
"""Verify release icons and untouched in-world asteroid silhouettes."""
from pathlib import Path
import subprocess
import struct
import sys
import zlib
sys.path.insert(0,str(Path(__file__).resolve().parent))
from retouch_asteroid_graphics import ROOT,assets,chunks_of,unfilter

def decode(png):
    parts=list(chunks_of(png))
    head=next(d for t,d in parts if t==b"IHDR")
    w,h,depth,kind,_,_,interlace=struct.unpack(">IIBBBBB",head)
    assert (depth,kind,interlace)==(8,6,0)
    raw=zlib.decompress(b"".join(d for t,d in parts if t==b"IDAT"))
    rows,_=unfilter(raw,w,h)
    return w,h,rows

def original(relative):
    p=subprocess.run(["git","show","HEAD:"+relative.as_posix()],
                     cwd=ROOT,check=True,capture_output=True)
    return decode(p.stdout)

entities=icons=0
for family,path in assets():
    relative=path.relative_to(ROOT)
    w,h,rows=decode(path.read_bytes())
    ow,oh,old=original(relative)
    if "entity" in relative.parts:
        assert (w,h)==(ow,oh),relative
        assert all(r[3::4]==o[3::4] for r,o in zip(rows,old)),relative
        entities+=1
    else:
        assert (w,h)==(64,64),relative
        assert (ow,oh) in ((120,64),(64,64))
        assert all(r[3::4]==o[:256][3::4] for r,o in zip(rows,old)),relative
        icons+=1
assert set((ROOT/"graphics").rglob("*.png"))=={p for _,p in assets()}
assert decode((ROOT/"thumbnail.png").read_bytes())[:2]==(144,144)
assert (entities,icons)==(30,42)
print("PASS: 30 in-world silhouettes, 42 square 64px icons, 144px thumbnail")
