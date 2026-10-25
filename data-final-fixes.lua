-- RaziLib centralizes settings and Factorio 2.1 recipe normalization.
-- Space Age remains standalone; K2SO remains optional.
local Settings = require("__razi_lib__/lib/settings")
local Recipe = require("__razi_lib__/lib/recipe")

if mods and mods["Krastorio2-spaced-out"] then
  if Settings.enabled("razi-more-asteroids-k2so-recovery", true) then
    require("prototypes.compat.k2so_recipes")
    require("prototypes.compat.k2so_extended_recipes")
  end
  require("prototypes.compat.k2so_crushers")
else
  require("prototypes.compat.space_age_recipes")
end

require("prototypes.compat.eight_family_recipes")

-- Normalize ONLY recipes owned by this mod. In particular, legacy result
-- "probability" becomes Factorio 2.1 "independent_probability". Never
-- normalize other mods' prototypes or change K2SO's normal recipes.
local families = {"uranium", "rock", "scrap", "organic", "chemical", "crystalline", "halide", "electrostatic"}
for _, material in ipairs(families) do
  for _, prefix in ipairs({"", "advanced-"}) do
    local name = prefix .. material .. "-asteroid-crushing"
    local recipe = Recipe.optional(name)
    if recipe then Recipe.normalize_2_1(recipe:raw()) end
  end
end

local specialties = {
  "razi-orbital-rare-metal-recovery", "razi-crystalline-ore-leaching",
  "razi-orbital-biomass-recovery", "razi-orbital-mineral-water-recovery",
  "razi-orbital-scrap-sorting", "razi-orbital-hydrogen-recovery",
  "razi-orbital-oxygen-recovery", "razi-orbital-conductor-recovery"
}
for _, name in ipairs(specialties) do
  local recipe = Recipe.optional(name)
  if recipe then Recipe.normalize_2_1(recipe:raw()) end
end


-- Extend the native asteroid-reprocessing technology, and optionally use
-- Muluna's own quality/data mechanics once all other recipes are registered.
require("prototypes.compat.asteroid_reprocessing")
require("prototypes.compat.muluna_upcycling")

-- Compose recipe icons last so K2SO and other output changes are visible.
require("prototypes.compat.recipe_icons")
