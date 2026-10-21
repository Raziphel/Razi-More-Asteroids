-- Base Space Age fallback when K2SO is NOT installed.
-- The fork's crystalline family remains useful without quartz or sand items.
-- Preserve every source recipe ID for save compatibility and avoid introducing
-- foreign Krastorio prototype names in the final Space Age data stage.
local Recipe = require("__razi_lib__/lib/recipe")
local recipes = data.raw.recipe or {}
local items = data.raw.item or {}
local fluids = data.raw.fluid or {}
local function item(name, amount, probability)
  if not items[name] then return nil end
  local result = {type = "item", name = name, amount = amount}
  if probability then result.probability = probability end
  return result
end
local function rework(name, outputs)
  local recipe = Recipe.optional(name)
  if not recipe then return end
  local results = {}
  for _,entry in ipairs(outputs) do
    if entry then results[#results+1] = entry end
  end
  -- Do not produce empty or invalid results if another mod changes the
  -- resource prototype list.
  if #results == 0 then return end
  recipe:set_results(results):set_main_product(nil)
end

-- Stone + minor ice from a quartz-like silicate rock, not free late-game
-- tungsten or rare metals. Both materials exist in vanilla Space Age.
rework("crystalline-asteroid-crushing", {
  item("stone", 10),
  item("ice", 2),
  item("crystalline-asteroid-chunk", 1, 0.2)
})
-- Crystalline separation consumes acid, yields mineral traces: advanced
-- asteroid processing is still necessary via technology unlocks.
rework("advanced-crystalline-asteroid-crushing", {
  item("stone", 8),
  item("calcite", 1, 0.25),
  item("crystalline-asteroid-chunk", 1, 0.05)
})
-- Protect against other optional mods that replace the normal fluids or
-- items (validation happens after all recipe-stage updates).
local families = {"uranium","rock","scrap","organic","chemical","crystalline"}
for _,family in ipairs(families) do
  for _,prefix in ipairs({"","advanced-"}) do
    local name = prefix .. family .. "-asteroid-crushing"
    local recipe = recipes[name]
    if recipe then
      for _,group in ipairs({"ingredients","results"}) do
        for _,entry in ipairs(recipe[group] or {}) do
          local table_of_kind = entry.type == "fluid" and fluids or items
          if not table_of_kind[entry.name] then
            error("[Razi More Asteroids] Missing Space Age " .. group ..
              " prototype " .. tostring(entry.name) .. " in recipe " .. name)
          end
        end
      end
    end
  end
end
