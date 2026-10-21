from pathlib import Path
p=Path('data-updates.lua')
s=p.read_text()
assert '--add recipes to tech research' in s
s=s[:s.index('--add recipes to tech research')]+'''-- Guard research unlocks from renamed/missing K2SO and Razi Protocol techs.
local function unlock(techname,recipe)
  local tech=data.raw.technology[techname]
  if not tech or not data.raw.recipe[recipe] then return false end
  tech.effects=tech.effects or {}
  for _,effect in pairs(tech.effects) do
    if effect.type=="unlock-recipe" and effect.recipe==recipe then return true end
  end
  tech.effects[#tech.effects+1]={type="unlock-recipe",recipe=recipe}
  return true
end
local basic={
  ["uranium-asteroid-crushing"]="space-platform",
  ["petrified-asteroid-crushing"]="space-platform",
  ["rock-asteroid-crushing"]="planet-discovery-vulcanus",
  ["scrap-asteroid-crushing"]="planet-discovery-fulgora",
  ["organic-asteroid-crushing"]="planet-discovery-gleba",
  ["chemical-asteroid-crushing"]="planet-discovery-aquilo"
}
for recipe,techname in pairs(basic) do
  if not unlock(techname,recipe) then
    unlock("advanced-asteroid-processing",recipe)
  end
end
for _,material in ipairs({"uranium","petrified","rock","scrap","organic"}) do
  unlock("advanced-asteroid-processing","advanced-"..material.."-asteroid-crushing")
end
if not unlock("planet-discovery-aquilo","advanced-chemical-asteroid-crushing") then
  unlock("advanced-asteroid-processing","advanced-chemical-asteroid-crushing")
end
local productivity=data.raw.technology["asteroid-productivity"]
if productivity then
  productivity.effects=productivity.effects or {}
  for _,material in ipairs({"uranium","petrified","rock","scrap","organic","chemical"}) do
    for _,prefix in ipairs({"","advanced-"}) do
      local recipe=prefix..material.."-asteroid-crushing"
      if data.raw.recipe[recipe] then
        local duplicate=false
        for _,effect in ipairs(productivity.effects) do
          if effect.type=="change-recipe-productivity" and effect.recipe==recipe then
            duplicate=true; break
          end
        end
        if not duplicate then productivity.effects[#productivity.effects+1]={
          type="change-recipe-productivity",recipe=recipe,change=0.1
        } end
      end
    end
  end
end
'''
p.write_text(s)
print('Source tech unlocks and productivity are now guarded/idempotent')
