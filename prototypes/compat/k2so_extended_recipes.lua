local Technology = require("__razi_lib__/lib/technology")
-- K2SO-only specialty recipes. Each entry is independently guarded so
-- optional K2SO forks can remove a product without crashing the data stage.
-- Respect the existing advanced-asteroid-processing unlock and productivity.
local items,fluids,recipes,technologies =
  data.raw.item or {}, data.raw.fluid or {}, data.raw.recipe or {},
  data.raw.technology or {}
local tech=Technology.optional("advanced-asteroid-processing")
if not tech then return end
local function item(name, amount, chance)
  local v={type="item",name=name,amount=amount}
  if chance then v.probability=chance end
  return v
end
local function fluid(name,amount)
  return {type="fluid",name=name,amount=amount}
end
local function valid(specs)
  for _,component in ipairs(specs) do
    local existing=component.type=="fluid" and fluids or items
    if not existing[component.name] then return false end
  end
  return true
end
local function effect_once(technology, effect)
  if not technology then return end
  technology:add_effect(effect, function(existing)
    return existing.type == effect.type and existing.recipe == effect.recipe
  end)
end
local function register(name,icon,order,ingredients,results,seconds)
  if not valid(ingredients) or not valid(results) then
    if type(log)=="function" then
      log("[Razi More Asteroids] Skipped optional K2SO recipe: "..name)
    end
    return
  end
  if not recipes[name] then
    data:extend({{
      type="recipe",name=name,enabled=false,
      icon="__razi-more-asteroids__/graphics/icons/"..icon..".png",
      icon_size=64,categories={"crushing"},subgroup="space-crushing",
      order=order,energy_required=seconds,
      ingredients=ingredients,results=results,
      auto_recycle=false,allow_decomposition=false,
      allow_productivity=true,always_show_made_in=true
    }})
  end
  effect_once(tech,{type="unlock-recipe",recipe=name})
  effect_once(Technology.optional("asteroid-productivity"),{
    type="change-recipe-productivity",recipe=name,change=0.1
  })
end

-- A competing use for orbital scrap, but not a source of instant circuits.
-- K2SO's existing electronics and inserter subassemblies remain useful.
register("razi-orbital-scrap-sorting","advanced-scrap-asteroid-crushing","b-a-h",
  {item("scrap-asteroid-chunk",3)},
  {item("scrap",6),item("kr-electronic-components",1,0.5),
   item("kr-inserter-parts",1,0.25)},5)

-- Small supplemental gas returns for K2SO's real hydrogen/oxygen economy.
-- Does not produce actual thruster fuel, oxidizer, or research items.
register("razi-orbital-hydrogen-recovery","advanced-chemical-asteroid-crushing","b-a-i",
  {item("chemical-asteroid-chunk",2),fluid("water",50)},
  {fluid("kr-hydrogen",30),item("sulfur",2)},5)
register("razi-orbital-oxygen-recovery","advanced-chemical-asteroid-crushing","b-a-j",
  {item("chemical-asteroid-chunk",2),fluid("water",50)},
  {fluid("kr-oxygen",30),item("sulfur",2)},5)

-- Electrostatic ore separation: supports K2SO electronics without
-- creating free science or replacing the K2SO silicon manufacturing line.
register("razi-orbital-conductor-recovery","advanced-electrostatic-asteroid-crushing","b-a-k",
  {item("electrostatic-asteroid-chunk",3),fluid("sulfuric-acid",40)},
  {item("holmium-ore",4),item("kr-silicon",2)},6)
