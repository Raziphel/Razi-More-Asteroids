#!/usr/bin/env python3
"""Build an installable Factorio archive without extra development scripts."""
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
import json
root=Path(__file__).resolve().parents[1]
meta=json.loads((root/'info.json').read_text())
name=meta['name']+'_'+meta['version']
dest=root/'dist'
dest.mkdir(exist_ok=True)
archive=dest/(name+'.zip')
allowed={'.lua','.json','.cfg','.png','.txt','.md'}
with ZipFile(archive,'w',ZIP_DEFLATED,compresslevel=6) as z:
  for p in sorted(root.rglob('*')):
    if not p.is_file(): continue
    rel=p.relative_to(root)
    if any(x in ('.git','dist','tools','docs','__pycache__') for x in rel.parts):
      continue
    if p.name!='LICENSE' and p.suffix not in allowed: continue
    z.write(p,name+'/'+rel.as_posix())
with ZipFile(archive) as z:
  assert name+'/info.json' in z.namelist()
  assert name+'/asteroids.lua' in z.namelist()
  assert any('/graphics/entity/asteroid/' in n for n in z.namelist())
  assert not any('/tools/' in n for n in z.namelist())
print(archive)
