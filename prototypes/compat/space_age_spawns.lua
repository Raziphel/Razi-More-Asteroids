-- Space Age's five planets, edge and shattered-planet route ONLY.
-- Extra planets and custom galaxy connections are intentionally left to their
-- owning mods. Never replace vanilla or third-party asteroid records.
local util = require("more-asteroids-spawn-definitions")
local mapping = {
  nauvis = {util.nauvis_vulcanus, 0.1},
  vulcanus = {util.nauvis_vulcanus, 0.9},
  gleba = {util.nauvis_gleba, 0.9},
  fulgora = {util.nauvis_fulgora, 0.9},
  aquilo = {util.fulgora_aquilo, 0.9}
}
local locations = {
  ["solar-system-edge"] = {util.aquilo_solar_system_edge, 0.9},
  ["shattered-planet"] = {util.shattered_planet_trip, 0.8}
}
local connections = {
  ["nauvis-vulcanus"] = util.nauvis_vulcanus,
  ["nauvis-gleba"] = util.nauvis_gleba,
  ["nauvis-fulgora"] = util.nauvis_fulgora,
  ["vulcanus-gleba"] = util.vulcanus_gleba,
  ["gleba-fulgora"] = util.gleba_fulgora,
  ["gleba-aquilo"] = util.gleba_aquilo,
  ["fulgora-aquilo"] = util.fulgora_aquilo,
  ["aquilo-solar-system-edge"] = util.aquilo_solar_system_edge,
  ["solar-system-edge-shattered-planet"] = util.shattered_planet_trip
}

local function valid(definition)
  if type(definition.asteroid) ~= "string" then return false end
  if definition.type == "asteroid-chunk" then
    return (data.raw["asteroid-chunk"] or {})[definition.asteroid] ~= nil
  end
  return (data.raw.asteroid or {})[definition.asteroid] ~= nil
end

local function add(place, source, at, is_start)
  if not place or not source then return 0 end
  local existing = place.asteroid_spawn_definitions or {}
  local names = {}
  for _,def in pairs(existing) do
    if type(def) == "table" then names[def.asteroid] = true end
  end
  local count = 0
  for _,def in ipairs(util.spawn_definitions(source, at)) do
    -- Any Planet Start's starting world should not spawn hostile asteroids
    -- around a platform. Resource chunks remain collectible.
    local hostile = def.type ~= "asteroid-chunk"
    if valid(def) and not names[def.asteroid] and not (is_start and hostile) then
      existing[#existing+1] = def
      names[def.asteroid] = true
      count = count + 1
    end
  end
  if count > 0 then place.asteroid_spawn_definitions = existing end
  return count
end

local starting_planet
if mods and mods["any-planet-start"] then
  local option = settings and settings.startup and settings.startup["aps-planet"]
  starting_planet = option and option.value
end

local total = 0
for name,entry in pairs(mapping) do
  total = total + add((data.raw.planet or {})[name], entry[1], entry[2],
    name == starting_planet)
end
for name,entry in pairs(locations) do
  total = total + add((data.raw["space-location"] or {})[name], entry[1], entry[2])
end
for name,source in pairs(connections) do
  total = total + add((data.raw["space-connection"] or {})[name], source)
end
if type(log) == "function" then
  log("[Razi More Asteroids] Added " .. total .. " nonduplicate Space Age asteroid records")
end
