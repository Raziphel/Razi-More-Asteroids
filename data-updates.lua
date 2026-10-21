--File to alter data in base/space-age game files

-- Preserve pre-existing crusher fluidboxes and support K2SO machines.
require("prototypes.compat.k2so_fluids")

--adding the asteroid spawn definitions to the original data
--had to comment out the code block that added definitions to the connections due to some NIL error
-- theoretically the additional asteroids shouldn't spawn in between the planets because of this but they do anyway. Idk how
local planets = data.raw["planet"]
local locations = data.raw["space-location"]
local connections = data.raw["space-connection"]
local more_asteroid_util = require("__razi-more-asteroids__.more-asteroids-spawn-definitions")

local planet_stuffmapping = {
  ["nauvis"] = more_asteroid_util.spawn_definitions(more_asteroid_util.nauvis_vulcanus, 0.1),
  ["vulcanus"] = more_asteroid_util.spawn_definitions(more_asteroid_util.nauvis_vulcanus, 0.9),
  ["gleba"] = more_asteroid_util.spawn_definitions(more_asteroid_util.nauvis_gleba, 0.9),
  ["fulgora"] = more_asteroid_util.spawn_definitions(more_asteroid_util.nauvis_fulgora, 0.9),
  ["aquilo"] = more_asteroid_util.spawn_definitions(more_asteroid_util.fulgora_aquilo, 0.9),
  ["cerys"] = more_asteroid_util.spawn_definitions(more_asteroid_util.fulgora_cerys, 0.9),
  ["muluna"] = more_asteroid_util.spawn_definitions(more_asteroid_util.nauvis_muluna, 0.9),
  ["maraxsis"] = more_asteroid_util.spawn_definitions(more_asteroid_util.vulcanus_maraxsis, 0.9)
}

local location_stuffmapping = {
  ["solar-system-edge"] = more_asteroid_util.spawn_definitions(more_asteroid_util.aquilo_solar_system_edge, 0.9),
  ["shattered-planet"] = more_asteroid_util.spawn_definitions(more_asteroid_util.shattered_planet_trip, 0.8)
}

local connection_stuffmapping = {
  ["nauvis-vulcanus"] = more_asteroid_util.spawn_definitions(more_asteroid_util.nauvis_vulcanus),
  ["nauvis-gleba"] = more_asteroid_util.spawn_definitions(more_asteroid_util.nauvis_gleba),
  ["nauvis-fulgora"] = more_asteroid_util.spawn_definitions(more_asteroid_util.nauvis_fulgora),
  ["vulcanus-gleba"] = more_asteroid_util.spawn_definitions(more_asteroid_util.vulcanus_gleba),
  ["gleba-fulgora"] = more_asteroid_util.spawn_definitions(more_asteroid_util.gleba_fulgora),
  ["gleba-aquilo"] = more_asteroid_util.spawn_definitions(more_asteroid_util.gleba_aquilo),
  ["fulgora-aquilo"] = more_asteroid_util.spawn_definitions(more_asteroid_util.fulgora_aquilo),
  ["aquilo-solar-system-edge"] = more_asteroid_util.spawn_definitions(more_asteroid_util.aquilo_solar_system_edge),
  ["solar-system-edge-shattered-planet"] = more_asteroid_util.spawn_definitions(more_asteroid_util.shattered_planet_trip),
  ["fulgora-cerys"] = more_asteroid_util.spawn_definitions(more_asteroid_util.fulgora_cerys),
  ["nauvis-muluna"] = more_asteroid_util.spawn_definitions(more_asteroid_util.nauvis_muluna),
  ["vulcanus-maraxsis"] = more_asteroid_util.spawn_definitions(more_asteroid_util.vulcanus_maraxsis),
  ["fulgora-maraxsis"] = more_asteroid_util.spawn_definitions(more_asteroid_util.fulgora_maraxsis)
}

--if mods["any-planet-start"] and (settings.startup["aps-planet"].value == planet.name) and (string.find(def.asteroid, "medium") ~= nil) then
-- settings.startup["aps-planet"].value
--if not mods["any-planet-start"] then
for _,planet in pairs(planets) do
  if planet_stuffmapping[planet.name] ~= nil then
    if planet.asteroid_spawn_definitions ~= nil then
      for _,def in pairs(planet_stuffmapping[planet.name]) do
        if not mods["any-planet-start"] then
          table.insert(planet.asteroid_spawn_definitions, def)
        else 
          if (settings.startup["aps-planet"].value ~= planet.name) then
            table.insert(planet.asteroid_spawn_definitions, def)
          elseif (string.find(def.asteroid, "medium") == nil) and (planet.asteroid_spawn_definitions ~= nil) then
            --local name = planet.name
            --table.insert(planet.asteroid_spawn_definitions, def)
          end
        end
      end
    else 
      planet.asteroid_spawn_definitions = planet_stuffmapping[planet.name]
    end
  end
end

for _,location in pairs(locations) do
  if location_stuffmapping[location.name] ~= nil then
    if location.asteroid_spawn_definitions ~= nil then
      for _,def in pairs(location_stuffmapping[location.name]) do
        table.insert(location.asteroid_spawn_definitions, def)
      end
    else
      location.asteroid_spawn_definitions = location_stuffmapping[location.name]
    end
  end
end

for _,connection in pairs(connections) do
  if connection_stuffmapping[connection.name] ~= nil then
    if connection.asteroid_spawn_definitions ~= nil then
      for _,def in pairs(connection_stuffmapping[connection.name]) do
        table.insert(connection.asteroid_spawn_definitions, def)
      end
    else
      connection.asteroid_spawn_definitions = connection_stuffmapping[connection.name]
    end
  end
end
--end


-- Guard research unlocks from renamed/missing K2SO and Razi Protocol techs.
local function unlock(techname,recipe)
  local tech=data.raw.technology[techname]
  if not tech or not data.raw.recipe[recipe] then return false end
  tech.effects=tech.effects or {}
  for _,effect in pairs(tech.effects) do
    if effect.type=="unlock-recipe" and effect.recipe==recipe then return true end
  end
  tech.effects[#tech.effects+1]={type="unlock-recipe",recipe=recipe}
  return true
end
local basic={
  ["uranium-asteroid-crushing"]="space-platform",
  ["crystalline-asteroid-crushing"]="space-platform",
  ["rock-asteroid-crushing"]="planet-discovery-vulcanus",
  ["scrap-asteroid-crushing"]="planet-discovery-fulgora",
  ["organic-asteroid-crushing"]="planet-discovery-gleba",
  ["chemical-asteroid-crushing"]="planet-discovery-aquilo"
}
for recipe,techname in pairs(basic) do
  if not unlock(techname,recipe) then
    unlock("advanced-asteroid-processing",recipe)
  end
end
for _,material in ipairs({"uranium","crystalline","rock","scrap","organic"}) do
  unlock("advanced-asteroid-processing","advanced-"..material.."-asteroid-crushing")
end
if not unlock("planet-discovery-aquilo","advanced-chemical-asteroid-crushing") then
  unlock("advanced-asteroid-processing","advanced-chemical-asteroid-crushing")
end
local productivity=data.raw.technology["asteroid-productivity"]
if productivity then
  productivity.effects=productivity.effects or {}
  for _,material in ipairs({"uranium","crystalline","rock","scrap","organic","chemical"}) do
    for _,prefix in ipairs({"","advanced-"}) do
      local recipe=prefix..material.."-asteroid-crushing"
      if data.raw.recipe[recipe] then
        local duplicate=false
        for _,effect in ipairs(productivity.effects) do
          if effect.type=="change-recipe-productivity" and effect.recipe==recipe then
            duplicate=true; break
          end
        end
        if not duplicate then productivity.effects[#productivity.effects+1]={
          type="change-recipe-productivity",recipe=recipe,change=0.1
        } end
      end
    end
  end
end
