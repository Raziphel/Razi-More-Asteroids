-- One small optional orbital route into K2SO's rare-metal economy.
-- Never supply imersite or late planetary products for free: Razi Protocol
-- already owns imersite asteroid distribution and research pacing.
local items=data.raw.item or {}
local techs=data.raw.technology or {}
local recipes=data.raw.recipe or {}
local fluids=data.raw.fluid or {}
if not (items["rare-metals"] and items["rock-asteroid-chunk"]
  and fluids["sulfuric-acid"] and techs["advanced-asteroid-processing"]
  and recipes["advanced-rock-asteroid-crushing"]) then
  return
end
local id="razi-orbital-rare-metal-recovery"
if not recipes[id] then
  data:extend({
    {
      type="recipe",
      name=id,
      localised_name={"recipe-name."..id},
      icon="__razi-more-asteroids__/graphics/icons/advanced-rock-asteroid-crushing.png",
      icon_size=64,
      category="crushing",
      subgroup="space-crushing",
      order="b-a-b",
      enabled=false,
      energy_required=4,
      auto_recycle=false,
      ingredients={
        {type="item",name="rock-asteroid-chunk",amount=2},
        {type="fluid",name="sulfuric-acid",amount=30}
      },
      results={
        {type="item",name="rare-metals",amount=1,probability=0.5},
        {type="item",name="stone",amount=6}
      },
      allow_productivity=true,
      allow_decomposition=false
    }
  })
end
local tech=techs["advanced-asteroid-processing"]
tech.effects=tech.effects or {}
local found=false
for _,effect in ipairs(tech.effects) do
  if effect.type=="unlock-recipe" and effect.recipe==id then
    found=true; break
  end
end
if not found then
  tech.effects[#tech.effects+1]={type="unlock-recipe",recipe=id}
end
local productivity=techs["asteroid-productivity"]
if productivity then
  productivity.effects=productivity.effects or {}
  local exists=false
  for _,effect in ipairs(productivity.effects) do
    if effect.type=="change-recipe-productivity" and effect.recipe==id then
      exists=true; break
    end
  end
  if not exists then productivity.effects[#productivity.effects+1]={
    type="change-recipe-productivity",recipe=id,change=0.1
  } end
end
