-- Reprocessing mirrors Space Age's exclusive 40/20/20/20 outcomes.
-- This is conversion, not resource generation: it must not accept productivity
-- or quality modules, and it never changes vanilla or third-party recipes.
local source = data.raw.recipe["metallic-asteroid-reprocessing"]
local technology = data.raw.technology["asteroid-reprocessing"]
if not source or not technology then return end

local families = {
  {"uranium", "rock", "crystalline"},
  {"rock", "crystalline", "uranium"},
  {"crystalline", "rock", "electrostatic"},
  {"scrap", "electrostatic", "rock"},
  {"organic", "chemical", "scrap"},
  {"chemical", "halide", "organic"},
  {"halide", "chemical", "electrostatic"},
  {"electrostatic", "scrap", "halide"}
}

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
  local own, alternative_a, alternative_b = family[1], family[2], family[3]
  local input = own .. "-asteroid-chunk"
  local name = own .. "-asteroid-reprocessing"
  if data.raw.item[input]
    and data.raw.item[alternative_a .. "-asteroid-chunk"]
    and data.raw.item[alternative_b .. "-asteroid-chunk"] then
    if not data.raw.recipe[name] then
      local recipe = table.deepcopy(source)
      recipe.name = name
      recipe.localised_name = {"recipe-name." .. name}
      recipe.icon = "__razi-more-asteroids__/graphics/icons/" .. input .. ".png"
      recipe.icons = nil
      recipe.icon_size = 64
      recipe.order = "b-b-d[" .. string.format("%02d", index) .. "-" .. own .. "]"
      recipe.enabled = false
      recipe.main_product = nil
      recipe.ingredients = {{
        type = "item", name = input, amount = 1, ignored_by_stats = 1
      }}
      -- shared_probability partitions ONE roll, so conversion cannot
      -- multiply chunks (unlike independent probabilities).
      recipe.results = {
        {type="item", name=input, amount=1,
          shared_probability={min=0.0,max=0.4}, ignored_by_stats=1},
        {type="item", name=alternative_a.."-asteroid-chunk", amount=1,
          shared_probability={min=0.4,max=0.6}},
        {type="item", name=alternative_b.."-asteroid-chunk", amount=1,
          shared_probability={min=0.6,max=0.8}}
      }
      recipe.auto_recycle = false
      recipe.allow_productivity = false
      recipe.allow_quality = false
      recipe.allow_decomposition = false
      data:extend({recipe})
    end
    unlock_once(name)
  end
end
