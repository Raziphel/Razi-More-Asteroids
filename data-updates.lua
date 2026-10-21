-- Native Space Age research policy, implemented through RaziLib's
-- idempotent data-stage helpers. The external library makes no changes itself.
local Settings = require("__razi_lib__/lib/settings")
local Technology = require("__razi_lib__/lib/technology")
local Recipe = require("__razi_lib__/lib/recipe")

-- Never replace an existing machine's fluid ports.
require("prototypes.compat.k2so_fluids")

if Settings.enabled("razi-more-asteroids-extended-routes", true) then
  require("prototypes.compat.space_age_spawns")
end

local function unlock(technology_name, recipe_name)
  if not Recipe.exists(recipe_name) then return false end
  local technology = Technology.optional(technology_name)
  if not technology then return false end
  technology:unlock(recipe_name)
  return true
end

-- Basic asteroid processing follows the standard Space Age discoveries.
-- If another mod removes a technology, use advanced asteroid processing.
local basics = {
  {"uranium-asteroid-crushing", "space-platform"},
  {"crystalline-asteroid-crushing", "planet-discovery-vulcanus"},
  {"rock-asteroid-crushing", "space-platform"},
  {"scrap-asteroid-crushing", "planet-discovery-fulgora"},
  {"organic-asteroid-crushing", "planet-discovery-gleba"},
  {"chemical-asteroid-crushing", "planet-discovery-aquilo"},
  {"halide-asteroid-crushing", "planet-discovery-aquilo"},
  {"electrostatic-asteroid-crushing", "planet-discovery-fulgora"}
}
for _, entry in ipairs(basics) do
  if not unlock(entry[2], entry[1]) then
    unlock("advanced-asteroid-processing", entry[1])
  end
end

local families = {"uranium", "crystalline", "rock", "scrap", "organic", "chemical", "halide", "electrostatic"}
for _, material in ipairs(families) do
  local name = "advanced-" .. material .. "-asteroid-crushing"
  local planetary = {
    crystalline = "planet-discovery-vulcanus",
    electrostatic = "planet-discovery-fulgora",
    chemical = "planet-discovery-aquilo",
    halide = "planet-discovery-aquilo"
  }
  local research = planetary[material] or "advanced-asteroid-processing"
  if not unlock(research, name) then
    unlock("advanced-asteroid-processing", name)
  end
end

-- Avoid duplicate research effects on repeated passes or other mod edits.
local productivity = Technology.optional("asteroid-productivity")
if productivity then
  for _, material in ipairs(families) do
    for _, prefix in ipairs({"", "advanced-"}) do
      local recipe_name = prefix .. material .. "-asteroid-crushing"
      if Recipe.exists(recipe_name) then
        productivity:add_effect({
          type = "change-recipe-productivity",
          recipe = recipe_name,
          change = 0.1
        }, function(effect)
          return effect.type == "change-recipe-productivity"
            and effect.recipe == recipe_name
        end)
      end
    end
  end
end
