-- K2SO ground crushers support only dry recipes. RaziLib handles category
-- deduplication without changing the recipe's other crafting machines.
local Recipe = require("__razi_lib__/lib/recipe")
local crusher = (data.raw.furnace or {})["kr-crusher"]
local category_exists = (data.raw["recipe-category"] or {})["kr-crushing"]
local found = false
for _, category in ipairs(crusher and crusher.crafting_categories or {}) do
  if category == "kr-crushing" then found = true end
end
if not found or not category_exists then return end

local function contains_fluid(recipe)
  for _, field in ipairs({"ingredients", "results"}) do
    for _, ingredient in ipairs(recipe[field] or {}) do
      if ingredient.type == "fluid" then return true end
    end
  end
  return false
end

local count = 0
local families = {"uranium", "rock", "scrap", "organic", "chemical", "crystalline"}
for _, family in ipairs(families) do
  for _, prefix in ipairs({"", "advanced-"}) do
    local recipe = Recipe.optional(prefix .. family .. "-asteroid-crushing")
    if recipe and not contains_fluid(recipe:raw()) then
      recipe:add_category("kr-crushing")
      count = count + 1
    end
  end
end
local salvage = Recipe.optional("razi-orbital-scrap-sorting")
if salvage and not contains_fluid(salvage:raw()) then
  salvage:add_category("kr-crushing")
  count = count + 1
end
if type(log) == "function" then
  log("[Razi More Asteroids] Enabled " .. count .. " dry asteroid recipes in K2SO crushers")
end
