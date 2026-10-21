#!/usr/bin/env python3
"""Fail-fast release gate for Factorio 2.1. Not an engine-load substitute."""
import json
from pathlib import Path
import re
import subprocess
import sys
from zipfile import ZipFile

ROOT=Path(__file__).resolve().parents[1]
metadata=json.loads((ROOT/"info.json").read_text())
assert metadata["version"]=="1.0.0"
assert metadata["factorio_version"]=="2.1"
assert "razi_lib >= 1.3.1" in metadata["dependencies"]
assert any(d.startswith("space-age ") for d in metadata["dependencies"])
assert any(d.startswith("? Krastorio2-spaced-out ") for d in metadata["dependencies"])
assert "! More-Asteroids" in metadata["dependencies"]
assert not (ROOT/"control.lua").exists(), "Unexpected runtime script"

# 2.1 removed these recipe prototype fields.
for path in [ROOT/"recipe.lua",*(ROOT/"prototypes/compat").glob("*.lua")]:
    source=path.read_text()
    if path.name in ("recipe.lua","k2so_recipes.lua","k2so_extended_recipes.lua"):
        assert not re.search(r"(?<![A-Za-z_])category\s*=",source),path
        assert 'categories' in source,path
    assert not re.search(r"(?<![A-Za-z_])always_show_products\s*=",source),path
    assert not re.search(r"(?<![A-Za-z_])show_amount_in_title\s*=",source),path
assert "kr-quartz" not in (ROOT/"recipe.lua").read_text()
assert "kr-sand" not in (ROOT/"recipe.lua").read_text()
assert "kr-rare-metal-ore" not in (ROOT/"recipe.lua").read_text()
assert "parameter-" not in (ROOT/"asteroids.lua").read_text()
assert "chunk backlight overrides" not in (ROOT/"asteroids.lua").read_text()

# Factorio requires a 99-dash header and 4-space entries.
changelog=(ROOT/"changelog.txt").read_text()
lines=changelog.splitlines()
assert lines[0]=="-"*99
assert lines[1]=="Version: "+metadata["version"]
assert lines[2].startswith("Date: ")
assert all("\t" not in line and line==line.rstrip() for line in lines)
for line in lines[3:]:
    assert line.startswith("  ") and (
        line.startswith("    - ") or (line.startswith("  ") and line.endswith(":"))
    ),f"Bad changelog line: {line!r}"

suites=[
    "smoke.py","test_space_age_compat.py","test_k2so_integration.py",
    "test_k2so_extended.py","test_razilib_integration.py","test_asteroid_art.py",
]
for filename in suites:
    subprocess.run([sys.executable,str(ROOT/"tools"/filename)],check=True)
subprocess.run([sys.executable,str(ROOT/"tools/package_fork.py")],check=True)
p=ROOT/"dist"/(metadata["name"]+"_"+metadata["version"]+".zip")
with ZipFile(p) as z:
    names=z.namelist()
    assert z.testzip() is None
    assert any(x.endswith("/changelog.txt") for x in names)
    assert any(x.endswith("/thumbnail.png") for x in names)
    assert any(x.endswith("/LICENSE") for x in names)
    assert len([x for x in names if "/graphics/icons/" in x])==42
    assert len([x for x in names if "/graphics/entity/asteroid/" in x])==30
print("PASS: candidate package, 2.1 metadata, changelog, icons, six test suites")
print("PENDING: Factorio 2.1 engine loading in Space Age + RaziLib, with and without K2SO")
