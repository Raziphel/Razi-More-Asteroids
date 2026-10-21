#!/usr/bin/env python3
"""Static smoke checks, not a replacement for Factorio 2.1 startup testing."""
from pathlib import Path
import json, re
root=Path(__file__).resolve().parents[1]
info=json.loads((root/"info.json").read_text())
assert info["name"]=="razi-more-asteroids"
assert info["factorio_version"]=="2.1"
assert any("Krastorio2-spaced-out" in d for d in info["dependencies"])
assert "! More-Asteroids" in info["dependencies"]
assert len(list((root/"graphics"/"entity"/"asteroid").iterdir())) >= 6
data=(root/"data.lua").read_text()
assert "data-updates" not in data, "data-updates must load in its own Factorio stage"
final=(root/"data-final-fixes.lua").read_text()
assert "k2so_recipes" in final and "razi_routes" in final
fluid=(root/"prototypes"/"compat"/"k2so_fluids.lua").read_text()
assert "next(machine.fluid_boxes)" in fluid, "Never replace existing fluid boxes"
source=(root/"data-updates.lua").read_text()
assert 'require("prototypes.compat.k2so_fluids")' in source
assert 'unlock("advanced-asteroid-processing"' in source
assert 'productivity.effects' in source
assert not (root/"control.lua").read_text().strip().endswith("script.on_event")
for path in root.glob("*.lua"):
  content=path.read_text()
  assert "__More-Asteroids__" not in content, str(path)
  for ref in re.findall(r'__razi-more-asteroids__/(graphics/[^"\\]+?\\.png)',content):
    assert (root/ref).is_file(), f"Missing sprite reference: {path}: {ref}"
assert (root/"LICENSE").exists()
print("PASS: metadata, 2.1/K2SO dependency, stage order, graphics, fluids, research, source attribution")
