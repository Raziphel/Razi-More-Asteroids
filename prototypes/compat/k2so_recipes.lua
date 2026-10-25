local Technology = require("__razi_lib__/lib/technology")
-- K2SO orbital processing. Only real K2SO prototypes are referenced;
-- skip optional recipes if another mod removed an input or output.
local items,fluids,recipes,techs=data.raw.item or {},data.raw.fluid or {},data.raw.recipe or {},data.raw.technology or {}
local advanced=Technology.optional("advanced-asteroid-processing")
if not advanced then return end

local function item(name,n,p)
  local result={type="item",name=name,amount=n}
  if p then result.probability=p end
  return result
end
local function fluid(name,n)
  return {type="fluid",name=name,amount=n}
end
local function all_exist(specs)
  for _,spec in ipairs(specs) do
    if spec.type=="item" and not items[spec.name] then return false end
    if spec.type=="fluid" and not fluids[spec.name] then return false end
  end
  return true
end
local function add_effect(technology, effect)
  if not technology then return end
  technology:add_effect(effect, function(existing)
    return existing.type == effect.type and existing.recipe == effect.recipe
  end)
end
local function add(name,icon,order,ingredients,results,energy,productivity_allowed)
  if not all_exist(ingredients) or not all_exist(results) then
    if type(log)=="function" then
      log("[Razi More Asteroids] K2SO recipe unavailable: "..name)
    end
    return
  end
  -- Do not let native machine productivity amplify any feedback outputs.
  local allow_productivity = productivity_allowed ~= false
  if not allow_productivity then
    for _,result in ipairs(results) do
      result.ignored_by_productivity = result.amount
    end
  end
  if not recipes[name] then
    data:extend({{
      type="recipe",name=name,
      icon="__razi-more-asteroids__/graphics/icons/"..icon..".png",
      icon_size=64,categories={"crushing"},subgroup="space-crushing",
      order=order,enabled=false,auto_recycle=false,
      energy_required=energy,ingredients=ingredients,results=results,
      allow_productivity=allow_productivity,allow_decomposition=false
    }})
  end
  add_effect(advanced,{type="unlock-recipe",recipe=name})
  if allow_productivity then
    add_effect(Technology.optional("asteroid-productivity"),{
      type="change-recipe-productivity",recipe=name,change=0.1
    })
  end
end

-- Dense-metal chunks supply raw rare-metal ORE. Existing K2SO refining
-- research, space-platform infrastructure and resource economics still apply.
add("razi-orbital-rare-metal-recovery","advanced-crystalline-asteroid-crushing","b-a-d",
  {item("crystalline-asteroid-chunk",2),fluid("sulfuric-acid",30)},
  {item("kr-rare-metal-ore",1,0.35),item("tungsten-ore",4)},4)

-- Dense-metal ore leaching: trade chunk throughput and acid for
-- a low but predictable source of K2SO rare-metal ore.
add("razi-crystalline-ore-leaching","advanced-crystalline-asteroid-crushing","b-a-e",
  {item("crystalline-asteroid-chunk",3),fluid("sulfuric-acid",75)},
  {item("kr-rare-metal-ore",1),item("tungsten-ore",8)},6)

-- Spoilage can be converted into nutrients (including via Rubia).
-- Keep the recovery recipe, but never multiply its results with productivity.
add("razi-orbital-biomass-recovery","advanced-organic-asteroid-crushing","b-a-f",
  {item("organic-asteroid-chunk",2),item("nutrients",5)},
  {item("kr-biomass",3),item("spoilage",5)},5,false)

-- Supplement planetary mineral-water extraction; never replace it.
add("razi-orbital-mineral-water-recovery","advanced-chemical-asteroid-crushing","b-a-g",
  {item("halide-asteroid-chunk",2),fluid("water",50)},
  {fluid("kr-mineral-water",30),item("sulfur",2)},5)
