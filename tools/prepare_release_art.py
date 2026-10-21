#!/usr/bin/env python3
"""Convert original source icons to true 64x64 Factorio icons.

No AI imagery, art replacements or third-party dependencies. Sprite graphics
remain untouched; only the 72 original UI icons and the existing thumbnail are
fit to the sizes expected by Factorio's 2.1 loader and mod portal.
"""
from pathlib import Path
import struct
import sys
import zlib
sys.path.insert(0, str(Path(__file__).resolve().parent))
from retouch_asteroid_graphics import (
    ROOT, PNG_SIGNATURE, chunks_of, chunk, unfilter, MARKER,
)

ICON_SIZE = 64
THUMBNAIL_SIZE = 144


def load(path):
    png = path.read_bytes()
    parts = list(chunks_of(png))
    header = next(body for kind,body in parts if kind==b"IHDR")
    w,h,depth,kind,comp,flt,interlace=struct.unpack(">IIBBBBB",header)
    if (depth,kind,comp,flt,interlace)!=(8,6,0,0,0):
        raise ValueError(f"Expected non-interlaced 8-bit RGBA PNG: {path}")
    raw=zlib.decompress(b"".join(body for kind,body in parts if kind==b"IDAT"))
    rows,_=unfilter(raw,w,h)
    return w,h,rows


def save(path,w,h,rows):
    out=bytearray(PNG_SIGNATURE)
    out+=chunk(b"IHDR",struct.pack(">IIBBBBB",w,h,8,6,0,0,0))
    out+=chunk(b"tEXt",MARKER)
    pixel_bytes=b"".join(b"\x00"+bytes(row) for row in rows)
    out+=chunk(b"IDAT",zlib.compress(pixel_bytes,9))
    out+=chunk(b"IEND",b"")
    path.write_bytes(out)


def main():
    icons=list(sorted((ROOT/"graphics/icons").glob("*.png")))
    converted=0
    for path in icons:
        w,h,rows=load(path)
        if (w,h)==(ICON_SIZE,ICON_SIZE):
            continue
        if (w,h)!=(120,64):
            raise ValueError(f"Unexpected icon dimensions {w}x{h}: {path}")
        # The upstream originals are 120x64 strips: their leftmost 64x64
        # region is the main illustrated asteroid. Use exactly that region
        # (not an enlarged AI sprite or a stretched 120px-wide strip).
        cropped=[bytearray(row[:64*4]) for row in rows]
        save(path,64,64,cropped)
        converted+=1
    thumbnail=ROOT/"thumbnail.png"
    w,h,rows=load(thumbnail)
    if (w,h)!=(144,144):
        target=[]
        scale=max(w,h)/144
        xpad=(144-w/scale)/2
        ypad=(144-h/scale)/2
        for y in range(144):
            out=bytearray(144*4)
            for x in range(144):
                sx=int((x-xpad)*scale)
                sy=int((y-ypad)*scale)
                if 0<=sx<w and 0<=sy<h:
                    off=x*4
                    out[off:off+4]=rows[sy][sx*4:sx*4+4]
            target.append(out)
        save(thumbnail,144,144,target)
        print("Resized existing thumbnail to 144x144 without replacing artwork")
    print(f"Converted {converted} existing UI icons to 64x64")


if __name__=="__main__":
    main()
