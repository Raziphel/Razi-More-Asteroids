-- Integrate Muluna's actual asteroid upcycling mechanics, rather than
-- adding a parallel quality shortcut. Muluna owns the technology, the
-- astronomical-data fluidbox, the quality roll and Rigor compatibility.
if not (mods and mods["planet-muluna"] and mods["quality"]) then return end

local template = data.raw.recipe["muluna-metallic-asteroid-chunk-upcycling"]
local technology = data.raw.technology["muluna-asteroid-upcycling"]
local astronomical_data = data.raw.fluid["muluna-astronomical-data"]
if not template or not technology or not astronomical_data then return end

local families = {
  "uranium", "rock", "crystalline", "scrap",
  "organic", "chemical", "halide", "electrostatic"
}
-- Dense, unusual and late-game chunks consume more telescope data.
local expensive = {crystalline=true, halide=true, electrostatic=true}

local function unlock_once(name)
  technology.effects = technology.effects or {}
  for _, effect in ipairs(technology.effects) do
    if effect.type == "unlock-recipe" and effect.recipe == name then return end
  end
  technology.effects[#technology.effects + 1] = {
    type = "unlock-recipe", recipe = name
  }
end

for index, family in ipairs(families) do
  local chunk = family .. "-asteroid-chunk"
  local name = "muluna-" .. chunk .. "-upcycling"
  if data.raw.item[chunk] then
    if not data.raw.recipe[name] then
      -- Deep copying preserves Muluna's loss rate, quality_change,
      -- shared_probability, Crusher 2 category and optional Rigor rules.
      local recipe = table.deepcopy(template)
      recipe.name = name
      recipe.localised_name = {"recipe-name." .. name}
      recipe.localised_description = nil
      recipe.order = "b-b-u[" .. string.format("%02d", index) .. "-" .. family .. "]"
      recipe.enabled = false
      recipe.main_product = nil
      recipe.icon = "__razi-more-asteroids__/graphics/icons/" .. chunk .. ".png"
      recipe.icons = nil
      recipe.icon_size = 64
      for _, ingredient in ipairs(recipe.ingredients or {}) do
        if ingredient.type == "item" then
          ingredient.name = chunk
        elseif ingredient.type == "fluid"
          and ingredient.name == "muluna-astronomical-data" then
          ingredient.amount = expensive[family] and 2 or 1
        end
      end
      for _, result in ipairs(recipe.results or {}) do
        if result.type == "item" then result.name = chunk end
      end
      data:extend({recipe})
    end
    unlock_once(name)
  end
end
