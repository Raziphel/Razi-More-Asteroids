-- Space Age/K2SO shared integration. The engine loads this during
-- data-updates automatically; never import it from data.lua.
require("prototypes.compat.k2so_fluids")

local route_option = settings and settings.startup and
  settings.startup["razi-more-asteroids-extended-routes"]
if route_option == nil or route_option.value == true then
  require("prototypes.compat.space_age_spawns")
end

local technologies = data.raw.technology or {}
local recipes = data.raw.recipe or {}
local function unlock(technology, recipe)
  local tech = technologies[technology]
  if not tech or not recipes[recipe] then return false end
  tech.effects = tech.effects or {}
  for _, effect in ipairs(tech.effects) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe then
      return true
    end
  end
  tech.effects[#tech.effects+1] = {type="unlock-recipe",recipe=recipe}
  return true
end

-- Planet discoveries own the ordinary mineral / life resources; no special
-- RP3 or third-party technology is assumed.
local basics = {
  {"uranium-asteroid-crushing", "space-platform"},
  {"crystalline-asteroid-crushing", "space-platform"},
  {"rock-asteroid-crushing", "planet-discovery-vulcanus"},
  {"scrap-asteroid-crushing", "planet-discovery-fulgora"},
  {"organic-asteroid-crushing", "planet-discovery-gleba"},
  {"chemical-asteroid-crushing", "planet-discovery-aquilo"}
}
for _, entry in ipairs(basics) do
  if not unlock(entry[2],entry[1]) then
    unlock("advanced-asteroid-processing",entry[1])
  end
end
local families = {"uranium","crystalline","rock","scrap","organic","chemical"}
for _, material in ipairs(families) do
  local recipe = "advanced-" .. material .. "-asteroid-crushing"
  if material == "chemical" then
    if not unlock("planet-discovery-aquilo",recipe) then
      unlock("advanced-asteroid-processing",recipe)
    end
  else
    unlock("advanced-asteroid-processing",recipe)
  end
end

-- Exact recipe references, idempotent even if a compatibility mod touched
-- productivity research in an earlier data stage.
local productivity = technologies["asteroid-productivity"]
if productivity then
  productivity.effects = productivity.effects or {}
  local exists = {}
  for _, effect in ipairs(productivity.effects) do
    if effect.type == "change-recipe-productivity" then
      exists[effect.recipe] = true
    end
  end
  for _, material in ipairs(families) do
    for _, prefix in ipairs({"","advanced-"}) do
      local name = prefix .. material .. "-asteroid-crushing"
      if recipes[name] and not exists[name] then
        productivity.effects[#productivity.effects+1] =
          {type="change-recipe-productivity",recipe=name,change=0.1}
        exists[name] = true
      end
    end
  end
end
