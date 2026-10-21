-- Resource identities for all eight families. Keep established prototype IDs for
-- save compatibility, while giving each family an unmistakable resource niche.
-- Called after the Space Age/K2SO fallback modules have resolved their items.
local Recipe = require("__razi_lib__/lib/recipe")
local items = data.raw.item or {}
local fluids = data.raw.fluid or {}
local function item(name,amount,chance)
  if not items[name] then return nil end
  local result={type="item",name=name,amount=amount}
  if chance then result.probability=chance end
  return result
end
local function fluid(name,amount)
  if not fluids[name] then return nil end
  return {type="fluid",name=name,amount=amount}
end
local function change(name,outputs,inputs)
  local recipe=Recipe.optional(name)
  if not recipe then return end
  local actual={}
  for _,entry in ipairs(outputs) do
    if entry then actual[#actual+1]=entry end
  end
  if #actual==0 then return end
  recipe:set_results(actual):set_main_product(nil)
  if inputs then recipe:set_ingredients(inputs) end
end
-- Lithic: the construction/stone family, not free tungsten.
change("advanced-rock-asteroid-crushing",{
  item("stone",12),item("calcite",2),
  item("rock-asteroid-chunk",1,0.05)
})
-- Dense-metal: tungsten, rather than duplicate stone or K2SO sand.
change("crystalline-asteroid-crushing",{
  item("tungsten-ore",5),item("crystalline-asteroid-chunk",1,0.15)
}, {item("crystalline-asteroid-chunk",1)})
change("advanced-crystalline-asteroid-crushing",{
  item("tungsten-ore",9),
  item("crystalline-asteroid-chunk",1,0.05)
}, {item("crystalline-asteroid-chunk",1),fluid("sulfuric-acid",20)})
-- Wreckage has predictable salvage; K2SO adds dedicated component sorting.
change("advanced-scrap-asteroid-crushing",{
  item("scrap",24),item("scrap-asteroid-chunk",1,0.05)
})
-- Volatile specializes in ammonia; Halide owns fluorine and brine.
change("advanced-chemical-asteroid-crushing",{
  fluid("ammonia",32),item("chemical-asteroid-chunk",1,0.05)
})
-- New family recipes already have their own vanilla outputs; verify them.
for _,name in ipairs({
  "halide-asteroid-crushing","advanced-halide-asteroid-crushing",
  "electrostatic-asteroid-crushing","advanced-electrostatic-asteroid-crushing"
}) do
  local recipe=Recipe.optional(name)
  assert(recipe,"Missing eighth-family recipe: "..name)
end
