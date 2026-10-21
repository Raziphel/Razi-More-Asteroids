from pathlib import Path
import json
root=Path(".")
# Change the entire asteroid family, including sprite references, icon names,
# prototype IDs, route families and all text. Preserve original 2D art bytes.
for p in list(root.rglob("*")):
    if not p.is_file() or ".git" in p.parts or "dist" in p.parts:
        continue
    if p.suffix in {".lua",".cfg",".md",".json",".txt"} and "tools" not in p.parts:
        raw=p.read_bytes()
        if b"petrified" in raw or b"Petrified" in raw:
            p.write_bytes(raw.replace(b"petrified",b"crystalline").replace(b"Petrified",b"Crystalline"))
# Rename on-disk image paths after references have been rewritten.
for p in sorted(root.glob("graphics/**/*petrified*"),key=lambda v:len(v.parts),reverse=True):
    p.rename(p.with_name(p.name.replace("petrified","crystalline")))
# Source recipe balance: replace old wood, fish, bioflux, egg outcomes completely.
p=Path("recipe.lua")
s=p.read_text()
old='''{type = "item", name = "wood", amount_min = 5, amount_max = 20},
        {type = "item", name = "raw-fish", amount = 1, probability = 0.4},'''
new='''{type = "item", name = "kr-sand", amount = 8},
        {type = "item", name = "kr-quartz", amount = 2},'''
assert old in s
s=s.replace(old,new,1)
old='''{type = "item", name = "bioflux", amount = 5},
        {type = "fluid", name = "fluoroketone-cold", amount = 10},'''
new='''{type = "fluid", name = "sulfuric-acid", amount = 20},'''
assert old in s
s=s.replace(old,new,1)
old='{type = "item", name = "biter-egg", amount = 1},'
new='''{type = "item", name = "kr-quartz", amount = 4},
        {type = "item", name = "kr-rare-metal-ore", amount = 1, probability = 0.25},'''
assert old in s
s=s.replace(old,new,1)
p.write_text(s)
# Make new asteroid visible in fitting industrial systems, not biological ones.
p=Path("prototypes/compat/razi_routes.lua")
s=p.read_text()
s=s.replace('["arig"]={"organic","crystalline"}','["arig"]={"organic","rock"}')
s=s.replace('["panglia"]={"organic","crystalline"}','["panglia"]={"organic","rock"}')
s=s.replace('["tenebris"]={"organic","crystalline"}','["tenebris"]={"organic","chemical"}')
s=s.replace('["tenebris-prime"]={"organic","crystalline"}','["tenebris-prime"]={"organic","chemical"}')
s=s.replace('["balack"]={"organic","crystalline"}','["balack"]={"organic","rock"}')
s=s.replace('["rabbasca"]={"organic","crystalline"}','["rabbasca"]={"organic","rock"}')
for key,new in {
 '["hyarion"]={"rock","uranium"}':'["hyarion"]={"rock","crystalline"}',
 '["ribbonia"]={"chemical","scrap"}':'["ribbonia"]={"chemical","crystalline"}',
 '["obsidiax"]={"rock","uranium"}':'["obsidiax"]={"rock","crystalline"}',
 '["khemia"]={"chemical","rock"}':'["khemia"]={"chemical","crystalline"}',
 '["igrys"]={"rock","uranium"}':'["igrys"]={"rock","crystalline"}',
 '["shchierbin"]={"chemical","rock"}':'["shchierbin"]={"chemical","crystalline"}'
}.items():
 assert key in s
 s=s.replace(key,new)
p.write_text(s)
# Accurate profile and source attribution, no premature release tag.
p=Path("info.json")
info=json.loads(p.read_text())
info["version"]="0.5.1"
info["homepage"]="https://github.com/Raziphel/Razi-More-Asteroids"
info["description"]="Six K2SO asteroid families including crystalline; guarded quartz, rare-metal, biomass and chemical processing, plus RP3 route ecology."
p.write_text(json.dumps(info,indent=2)+"\n")
p=Path("locale/en/idkwtph.cfg")
s=p.read_text().replace("What ancient mysteries will you discover?","Quartz-rich ore veins hardened in the vacuum of space.")
p.write_text(s)
print("Replaced petrified family with crystalline prototypes, graphics paths and recipes.")
