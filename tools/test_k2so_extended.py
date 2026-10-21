#!/usr/bin/env python3
"""Structural K2SO compatibility and progression guards.

Checks optional integration against tracked K2SO source where present.
Still requires an in-game Factorio 2.1 load test to certify recipes.
"""
from pathlib import Path
import json
root=Path(__file__).resolve().parents[1]
read=lambda path:(root/path).read_text()
meta=json.loads(read("info.json"))
assert meta["version"]=="1.0.0"
assert any(s.startswith("? Krastorio2-spaced-out") for s in meta["dependencies"])
final=read("data-final-fixes.lua")
assert 'mods["Krastorio2-spaced-out"]' in final
assert 'require("prototypes.compat.k2so_extended_recipes")' in final
assert 'require("prototypes.compat.k2so_crushers")' in final
assert final.index('require("prototypes.compat.k2so_extended_recipes")') < final.index(
    'require("prototypes.compat.k2so_crushers")')
assert final.index('require("prototypes.compat.k2so_crushers")') < final.index(
    'require("prototypes.compat.space_age_recipes")')

extended=read("prototypes/compat/k2so_extended_recipes.lua")
expected={
    "razi-orbital-scrap-sorting":("kr-electronic-components","kr-inserter-parts"),
    "razi-orbital-hydrogen-recovery":("kr-hydrogen","chemical-asteroid-chunk"),
    "razi-orbital-oxygen-recovery":("kr-oxygen","chemical-asteroid-chunk"),
    "razi-orbital-quartz-washing":("kr-quartz","crystalline-asteroid-chunk"),
}
locale=read("locale/en/razi-more-asteroids.cfg")
for name,items in expected.items():
    assert 'register("'+name+'"' in extended, name
    assert locale.count(name+"=")==2, name
    for item in items: assert '"'+item+'"' in extended
assert 'if not valid(ingredients) or not valid(results)' in extended
assert 'Technology.optional("advanced-asteroid-processing")' in extended
assert 'type="unlock-recipe"' in extended
assert 'type="change-recipe-productivity"' in extended
assert 'items["kr-sand"]' in extended and 'items["sand"]' in extended
assert 'if not recipes[name]' in extended

crusher=read("prototypes/compat/k2so_crushers.lua")
assert '(data.raw.furnace or {})["kr-crusher"]' in crusher
assert 'category == "kr-crushing"' in crusher
assert 'ingredient.type == "fluid"' in crusher
assert 'not contains_fluid(recipe:raw())' in crusher
assert 'recipe:add_category("kr-crushing")' in crusher
assert 'recipe.category = nil' not in crusher
assert 'local Recipe = require("__razi_lib__/lib/recipe")' in crusher
assert '"razi-orbital-scrap-sorting"' in crusher
assert 'data.raw["recipe-category"]' in crusher

source=root.parent/"k2so-compat-reference"
if source.is_dir():
    code="\n".join(path.read_text() for path in (source/"prototypes").rglob("*.lua"))
    for name in ("kr-crushing","kr-quartz","kr-electronic-components",
                 "kr-inserter-parts","kr-hydrogen","kr-oxygen"):
        assert name in code, "Unverified K2SO source reference: "+name
print("PASS: K2SO eight specialty recipes, guarded gas/scrap/quartz and dry crusher bridge")
