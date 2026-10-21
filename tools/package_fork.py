#!/usr/bin/env python3
"""Build a deterministic, minimal Factorio Mod Portal upload archive."""
from pathlib import Path
from zipfile import ZipFile, ZipInfo, ZIP_DEFLATED
import json

root=Path(__file__).resolve().parents[1]
meta=json.loads((root/"info.json").read_text())
name=meta["name"]+"_"+meta["version"]
dist=root/"dist"
dist.mkdir(exist_ok=True)
archive=dist/(name+".zip")
top_level={
    "info.json","settings.lua","data.lua","data-updates.lua",
    "data-final-fixes.lua","asteroids.lua","recipe.lua","item.lua",
    "more-asteroids-spawn-definitions.lua",
    "thumbnail.png","changelog.txt","LICENSE"
}
allowed={".lua",".cfg",".png"}
included=[root/path for path in top_level]
for subdir in ("graphics","prototypes","locale"):
    included.extend(p for p in (root/subdir).rglob("*")
                    if p.is_file() and p.suffix in allowed)
if not all(p.is_file() for p in included):
    missing=[str(p.relative_to(root)) for p in included if not p.is_file()]
    raise FileNotFoundError(missing)
if len(included)!=len(set(included)):
    raise ValueError("Duplicate file paths in release manifest")
with ZipFile(archive,"w",ZIP_DEFLATED,compresslevel=9) as z:
    for path in sorted(included):
        if path.is_symlink():
            raise ValueError(f"Release cannot include symlinks: {path}")
        relative=path.relative_to(root).as_posix()
        member=ZipInfo(f"{name}/{relative}",(2026,1,1,0,0,0))
        member.compress_type=ZIP_DEFLATED
        member.external_attr=(0o100644<<16)
        z.writestr(member,path.read_bytes(),compress_type=ZIP_DEFLATED,compresslevel=9)
with ZipFile(archive) as z:
    members=z.namelist()
    assert len(members)==len(set(members))
    assert z.testzip() is None,"Corrupt ZIP member"
    assert all(p.startswith(name+"/") and ".." not in Path(p).parts for p in members)
    assert set(members)=={f"{name}/{p.relative_to(root).as_posix()}" for p in included}
    packaged=json.loads(z.read(name+"/info.json"))
    assert packaged["name"]==meta["name"] and packaged["version"]==meta["version"]
    assert not any("/tools/" in p or "/docs/" in p or "/.git/" in p for p in members)
    assert not any(".razi-backup-" in p or "Copy.png" in p for p in members)
print(f"PASS: {archive} ({len(included)} files, {archive.stat().st_size:,} bytes)")
