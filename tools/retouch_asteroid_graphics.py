#!/usr/bin/env python3
"""Retouch EXISTING Factorio asteroid PNGs in place, preserving dimensions and alpha.

No generated artwork and no added dependencies: uses only Python's standard
library. Retains texture/lighting by color-grading the existing source pixels.
A private PNG text marker prevents accidentally grading an asset twice.
"""
from __future__ import annotations
import argparse
import binascii
from pathlib import Path
import struct
import zlib

ROOT = Path(__file__).resolve().parents[1]
PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"
FAMILIES = {
    # shadow, midtone, sunlit mineral, exposed seam / brilliant mineral
    "rock": ((38, 43, 48), (99, 99, 97), (154, 145, 125), (203, 177, 136)),
    "uranium": ((18, 29, 29), (46, 67, 58), (77, 128, 69), (154, 212, 82)),
    "scrap": ((37, 44, 48), (87, 95, 99), (147, 119, 98), (207, 145, 93)),
    "organic": ((30, 37, 27), (70, 87, 48), (125, 137, 73), (186, 184, 112)),
    "chemical": ((25, 45, 56), (52, 100, 113), (104, 165, 162), (189, 213, 159)),
    "crystalline": ((53, 76, 90), (127, 160, 171), (198, 224, 224), (240, 251, 253)),
}
MARKER = b"RaziResourceArt\x001"
SIZES = ("chunk", "small", "medium", "big", "huge")


def chunks_of(png: bytes):
    assert png.startswith(PNG_SIGNATURE), "Not a PNG"
    offset = len(PNG_SIGNATURE)
    while offset < len(png):
        n = struct.unpack(">I", png[offset:offset+4])[0]
        typ = png[offset+4:offset+8]
        body = png[offset+8:offset+8+n]
        crc = struct.unpack(">I", png[offset+8+n:offset+12+n])[0]
        assert (binascii.crc32(typ + body) & 0xffffffff) == crc, typ
        yield typ, body
        offset += 12+n
        if typ == b"IEND": break


def chunk(typ: bytes, body: bytes) -> bytes:
    return struct.pack(">I", len(body)) + typ + body + struct.pack(
        ">I", binascii.crc32(typ + body) & 0xffffffff)


def unfilter(raw: bytes, width: int, height: int):
    pitch = width * 4
    rows = []
    filters = []
    cursor = 0
    prior = bytearray(pitch)
    for _ in range(height):
        f = raw[cursor]
        line = bytearray(raw[cursor+1:cursor+pitch+1])
        assert len(line) == pitch
        cursor += pitch+1
        for j in range(pitch):
            a = line[j-4] if j >= 4 else 0
            b = prior[j]
            c = prior[j-4] if j >= 4 else 0
            if f == 1: predictor = a
            elif f == 2: predictor = b
            elif f == 3: predictor = (a+b)//2
            elif f == 4:
                p = a+b-c
                da, db, dc = abs(p-a), abs(p-b), abs(p-c)
                predictor = a if da<=db and da<=dc else (b if db<=dc else c)
            elif f == 0: predictor = 0
            else: raise ValueError(f"Unsupported PNG filter: {f}")
            line[j] = (line[j] + predictor) & 255
        rows.append(line)
        filters.append(f)
        prior = line
    assert cursor == len(raw)
    return rows, filters


def refilter(rows, filters):
    result = bytearray()
    prior = bytearray(len(rows[0]))
    for line, f in zip(rows, filters):
        result.append(f)
        for j, value in enumerate(line):
            a = line[j-4] if j>=4 else 0
            b = prior[j]
            c = prior[j-4] if j>=4 else 0
            if f==1: predictor=a
            elif f==2: predictor=b
            elif f==3: predictor=(a+b)//2
            elif f==4:
                p=a+b-c
                da,db,dc=abs(p-a),abs(p-b),abs(p-c)
                predictor=a if da<=db and da<=dc else (b if db<=dc else c)
            else: predictor=0
            result.append((value-predictor)&255)
        prior=line
    return bytes(result)


def blend(a, b, t):
    return a + (b-a)*t


def grade(rows, material: str):
    palette = FAMILIES[material]
    for line in rows:
        for j in range(0, len(line), 4):
            r, g, b, a = line[j:j+4]
            if a==0: continue
            # Preserve original detail and source shading, even at icon scale.
            lum = (0.2126*r + 0.7152*g + 0.0722*b) / 255
            if material=="crystalline":
                lum = min(0.999, lum*1.33 + 0.105)  # translucent quartz face
            # Upstream uses highly saturated tints, especially uranium/scrap.
            # Neutralize the old tint but retain its roughness and mineral veins.
            s = min(2.999, max(0.0, lum*3))
            k = int(s)
            t = s-k
            target = [blend(palette[k][c], palette[k+1][c], t) for c in range(3)]
            # Chroma microcontrast retains facets, scratched plates and crevices.
            original_gray = (r+g+b)/3
            residual = ((r-original_gray), (g-original_gray), (b-original_gray))
            keep = 0.14 if material in ("uranium","scrap","crystalline") else 0.20
            for c in range(3):
                value = target[c] + residual[c]*keep
                # Soft mineral highlights using *existing* brighter source pixels.
                # No procedurally added objects or replacement geometry.
                if material=="crystalline" and lum>0.54:
                    value += ((7, 11, 19)[c] * (lum-0.54)/0.46)
                elif material=="uranium" and lum>0.53:
                    value += ((-9, 18, -4)[c] * (lum-0.53)/0.47)
                elif material=="chemical" and lum>0.60:
                    value += ((10, 8, -7)[c] * (lum-0.6)/0.4)
                line[j+c] = max(0, min(255, round(value)))


def retouch(path: Path, material: str, apply: bool):
    original = path.read_bytes()
    old = list(chunks_of(original))
    if any(typ==b"tEXt" and data==MARKER for typ,data in old):
        return "already-graded"
    header = next(body for typ,body in old if typ==b"IHDR")
    w,h,depth,kind,comp,flt,interlace = struct.unpack(">IIBBBBB",header)
    assert depth==8 and kind==6 and comp==0 and flt==0 and interlace==0, path
    raw = zlib.decompress(b"".join(body for typ,body in old if typ==b"IDAT"))
    rows,filters = unfilter(raw,w,h)
    before_alpha = b"".join(row[3::4] for row in rows)
    if not apply: return f"would-retouch:{w}x{h}"
    grade(rows,material)
    assert b"".join(row[3::4] for row in rows)==before_alpha
    encoded = zlib.compress(refilter(rows,filters),level=9)
    out = bytearray(PNG_SIGNATURE)
    inserted=False
    for typ,body in old:
        if typ==b"IDAT":
            if not inserted:
                out += chunk(b"tEXt",MARKER)
                out += chunk(b"IDAT",encoded)
                inserted=True
            continue
        out += chunk(typ,body)
    assert inserted
    assert struct.unpack(">IIBBBBB",next(body for typ,body in chunks_of(out)
        if typ==b"IHDR")) == (w,h,depth,kind,comp,flt,interlace)
    path.write_bytes(out)
    return f"retouched:{w}x{h}"


def assets():
    entity = ROOT / "graphics/entity/asteroid"
    icons = ROOT / "graphics/icons"
    for material in FAMILIES:
        for size in SIZES:
            path=entity/material/size/f"asteroid-{material}-{size}-colour-01.png"
            if not path.is_file():
                raise FileNotFoundError(path)
            yield material,path
        # Only icons the mod actually references, not unused upstream copies.
        expected=[
            f"{material}-asteroid-chunk.png",
            f"{material}-asteroid-crushing.png",
            f"advanced-{material}-asteroid-crushing.png",
            f"small-{material}-asteroid.png",
            f"medium-{material}-asteroid.png",
            f"big-{material}-asteroid.png",
            f"huge-{material}-asteroid.png",
        ]
        for basename in expected:
            path=icons/basename
            if not path.is_file(): raise FileNotFoundError(path)
            yield material,path


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--apply",action="store_true",help="Modify existing PNGs in place")
    args=parser.parse_args()
    records=[]
    for material,path in assets():
        records.append((material,path,retouch(path,material,args.apply)))
    for material in FAMILIES:
        subset=[r for r in records if r[0]==material]
        print(f"{material}: {len(subset)} existing assets; "
            + ", ".join(sorted({r[2].split(':')[0] for r in subset})))
    print("Total files:",len(records),"/ no geometry or alpha changes")


if __name__=="__main__":
    main()
