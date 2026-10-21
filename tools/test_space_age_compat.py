#!/usr/bin/env python3
"""Static regression guard: Space Age alone must load without K2SO."""
from pathlib import Path
import json
root=Path(__file__).resolve().parents[1]
read=lambda p:(root/p).read_text()
info=json.loads(read("info.json"))
deps=info["dependencies"]
assert any(s.startswith("space-age ") for s in deps)
assert any(s.startswith("? Krastorio2-spaced-out ") for s in deps)
assert not any(s.startswith("Krastorio2-spaced-out ") for s in deps)
assert not any("RP3" in d or "razi-protocol" in d for d in deps)
assert all(not any(planet in d.lower() for planet in
    ("maraxsis","cerys","muluna")) for d in deps)

final=read("data-final-fixes.lua")
assert 'mods["Krastorio2-spaced-out"]' in final
assert 'require("prototypes.compat.space_age_recipes")' in final
assert 'require("prototypes.compat.crystalline")' in final
assert 'require("prototypes.compat.k2so_recipes")' in final
assert final.index('if mods and mods["Krastorio2-spaced-out"]') < final.index(
    'require("prototypes.compat.crystalline")')
assert final.index('else') < final.index('require("prototypes.compat.space_age_recipes")')

source=read("data-updates.lua")
assert 'require("prototypes.compat.space_age_spawns")' in source
assert "razi_routes" not in source+final
assert not (root/"prototypes/compat/razi_routes.lua").exists()
assert 'require("prototypes.compat.k2so_fluids")' in source
for tech in ("space-platform","planet-discovery-vulcanus",
    "planet-discovery-fulgora","planet-discovery-gleba",
    "planet-discovery-aquilo","advanced-asteroid-processing"):
    assert tech in source

spawns=read("prototypes/compat/space_age_spawns.lua")
for name in ("nauvis","vulcanus","fulgora","gleba","aquilo",
    "solar-system-edge","shattered-planet"):
    assert name in spawns
for name in ("castra","hyarion","obsidiax","paracelsin","corrundum",
    "muria","khemia","panglia","maraxsis"):
    assert '"'+name+'"' not in spawns
assert "not names[def.asteroid]" in spawns
assert "not (is_start and hostile)" in spawns
assert "util.spawn_definitions" in spawns
ratios=read("more-asteroids-spawn-definitions.lua")
assert "for i = 1, #ratio do" in ratios
assert "max > 0" in ratios
fallback=read("prototypes/compat/space_age_recipes.lua")
for item in ('item("stone"','item("ice"','item("calcite"'):
    assert item in fallback
assert 'rework("crystalline-asteroid-crushing"' in fallback
assert 'rework("advanced-crystalline-asteroid-crushing"' in fallback
assert not any(x in fallback for x in ("kr-quartz","kr-sand","kr-rare-metal-ore"))
print("PASS: Space Age standalone, research, deduplicated vanilla routes, no RP3")
