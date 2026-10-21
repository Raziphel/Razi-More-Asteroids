#!/usr/bin/env python3
"""Structural regression checks for the K2SO data-stage integration.

Static checks only. Factorio with K2SO still requires engine testing.
"""
import json
from pathlib import Path

root = Path(__file__).resolve().parents[1]
read = lambda path: (root / path).read_text()
info = json.loads(read("info.json"))
assert "(?) nulls-k2so-tweaks" in info["dependencies"]
assert "? Krastorio2-spaced-out" in " ".join(info["dependencies"])

final = read("data-final-fixes.lua")
assert final.index('require("prototypes.compat.crystalline")') < final.index(
    'require("prototypes.compat.k2so_recipes")'
)
assert 'require("prototypes.compat.k2so_recipes")' in final

crystal = read("prototypes/compat/crystalline.lua")
assert 'items["kr-sand"]' in crystal and 'items["sand"]' in crystal
assert 'items["kr-quartz"]' in crystal
assert 'items["kr-rare-metal-ore"]' in crystal
assert 'basic.results = results' in crystal
assert 'advanced.results = results' in crystal

recipes = read("prototypes/compat/k2so_recipes.lua")
names = [
    "razi-orbital-rare-metal-recovery",
    "razi-crystalline-ore-leaching",
    "razi-orbital-biomass-recovery",
    "razi-orbital-mineral-water-recovery",
]
locale = read("locale/en/razi-more-asteroids.cfg")
for name in names:
    assert f'add("{name}"' in recipes, name
    assert f"{name}=" in locale, name
assert 'not all_exist(ingredients) or not all_exist(results)' in recipes
assert 'type="unlock-recipe"' in recipes
assert 'type="change-recipe-productivity"' in recipes
assert 'kr-rare-metal-ore' in recipes and '"rare-metals"' not in recipes
assert 'kr-biomass' in recipes and 'kr-mineral-water' in recipes
assert 'kr-quartz' in recipes

# All active asteroid, chunk, spawn, icon, recipe and locale prototypes
# must have converted to crystalline; only documentation may mention history.
sources = [
    "asteroids.lua", "item.lua", "recipe.lua", "data-updates.lua",
    "more-asteroids-spawn-definitions.lua", "locale/en/idkwtph.cfg",
]
for source in sources:
    body = read(source).lower()
    assert "petrified" not in body, source
    assert "crystalline" in body, source
icons = root / "graphics" / "icons"
for stem in ("crystalline-asteroid-chunk", "crystalline-asteroid-crushing",
             "advanced-crystalline-asteroid-crushing", "small-crystalline-asteroid",
             "medium-crystalline-asteroid", "big-crystalline-asteroid",
             "huge-crystalline-asteroid"):
    assert (icons / (stem + ".png")).is_file(), stem
assert len(list((root / "graphics/entity/asteroid/crystalline").rglob("*.png"))) >= 5

print("PASS: K2SO guarded output aliases, four optional recipes, progression, crystalline assets")
