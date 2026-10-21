#!/usr/bin/env python3
"""Pre-publication RaziLib 1.3.1 consumer API and dependency contract."""
import json
from pathlib import Path
root=Path(__file__).resolve().parents[1]
source=lambda name:(root/name).read_text()
meta=json.loads(source("info.json"))
assert meta["version"]=="1.0.0"
assert "razi_lib >= 1.3.1" in meta["dependencies"]
assert "razi_lib" not in meta["name"],"Don't rename the asteroid mod"
assert any(x.startswith("? Krastorio2-spaced-out ") for x in meta["dependencies"])
assert not (root/"lib").exists(),"Never vendor RaziLib into a consumer mod"

settings=source("settings.lua")
updates=source("data-updates.lua")
final=source("data-final-fixes.lua")
k2crusher=source("prototypes/compat/k2so_crushers.lua")
crystal=source("prototypes/compat/crystalline.lua")
fallback=source("prototypes/compat/space_age_recipes.lua")
for path in ("prototypes/compat/k2so_recipes.lua","prototypes/compat/k2so_extended_recipes.lua"):
    text=source(path)
    assert 'require("__razi_lib__/lib/technology")' in text
    assert 'Technology.optional("advanced-asteroid-processing")' in text
    assert ':add_effect(effect' in text

assert 'require("__razi_lib__/lib/settings")' in settings
assert 'Settings.bool(' in settings
assert 'Settings.enabled(' in updates and 'Settings.enabled(' in final
assert 'require("__razi_lib__/lib/technology")' in updates
assert 'Technology.optional(' in updates and 'productivity:add_effect(' in updates
assert 'require("__razi_lib__/lib/recipe")' in final
assert 'Recipe.normalize_2_1(recipe:raw())' in final
assert 'Recipe.optional(' in final
assert 'require("__razi_lib__/lib/recipe")' in crystal
assert ':set_results(results):set_main_product(nil)' in crystal
assert 'require("__razi_lib__/lib/recipe")' in fallback
assert 'recipe:set_results(results):set_main_product(nil)' in fallback
assert 'require("__razi_lib__/lib/recipe")' in k2crusher
assert ':add_category("kr-crushing")' in k2crusher
assert 'type="fluid"' not in k2crusher
assert not (root/"control.lua").exists()

# Optional: verify real RaziLib implementation if a checked-out copy exists.
lib=root.parent/"razilib-reference"
if (lib/"info.json").exists():
    version=json.loads((lib/"info.json").read_text())["version"]
    assert tuple(map(int,version.split("."))) >= (1,3,1)
    apis={
        "lib/settings.lua":["function Settings.bool","function Settings.enabled"],
        "lib/recipe.lua":["function Recipe.optional","function Recipe.normalize_2_1",
                          "function methods:add_category","function methods:set_results",
                          "function methods:set_main_product"],
        "lib/technology.lua":["function Technology.optional","function methods:unlock",
                              "function methods:add_effect"]
    }
    for path,needles in apis.items():
        text=(lib/path).read_text()
        for needle in needles: assert needle in text,f"RaziLib API missing: {needle}"

print("PASS: hard RaziLib 1.3.1 dependency, real Settings/Recipe/Technology use, no vendored library")
