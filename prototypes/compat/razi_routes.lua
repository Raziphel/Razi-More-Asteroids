-- Low-density extensions for K2SO's curated planet pack and RP3's
-- actual final space connections. Keep all source-owned asteroid records.
-- Entirely data-stage: no runtime scans, timers or saved entity state.
local profiles={
  ["castra-prime"]={"rock","scrap"},
  ["castra"]={"rock","scrap"},
  ["arig"]={"organic","rock"},
  ["hyarion"]={"rock","crystalline"},
  ["corrundum"]={"chemical","scrap"},
  ["moshine"]={"scrap","rock"},
  ["panglia"]={"organic","rock"},
  ["ribbonia"]={"chemical","crystalline"},
  ["paracelsin"]={"chemical","uranium"},
  ["rubia"]={"scrap","rock"},
  ["cubium"]={"chemical","scrap"},
  ["tenebris"]={"organic","chemical"},
  ["tenebris-prime"]={"organic","chemical"},
  ["secretas"]={"uranium","rock"},
  ["frozeta"]={"chemical","rock"},
  ["vesta"]={"chemical","rock"},
  ["obsidiax"]={"rock","crystalline"},
  ["khemia"]={"chemical","crystalline"},
  ["balack"]={"organic","rock"},
  ["athos"]={"rock","scrap"},
  ["igrys"]={"rock","crystalline"},
  ["velora"]={"organic","chemical"},
  ["foliax"]={"organic","chemical"},
  ["rabbasca"]={"organic","rock"},
  ["shchierbin"]={"chemical","crystalline"},
  ["muria"]={"chemical","rock"},
  ["linox"]={"scrap","rock"}
}
local asteroid=data.raw.asteroid or {}
local chunks=data.raw["asteroid-chunk"] or {}
local function name_of(value)
  if type(value)=="string" then return value:lower() end
  if type(value)=="table" and type(value.name)=="string" then
    return value.name:lower()
  end
end
local function add(entries, material, hostile, orbit)
  local name=hostile and "medium-"..material.."-asteroid"
    or material.."-asteroid-chunk"
  if hostile and not asteroid[name] then return 0 end
  if not hostile and not chunks[name] then return 0 end
  for _,existing in ipairs(entries) do
    if existing.asteroid==name then return 0 end
  end
  local p=hostile and 0.00012 or 0.00065
  local angle=hostile and 0.6 or 1
  if orbit then
    entries[#entries+1]={
      asteroid=name,type=hostile and "entity" or "asteroid-chunk",
      probability=p*0.5,speed=1*meter/second,angle_when_stopped=angle
    }
  else
    entries[#entries+1]={
      asteroid=name,type=hostile and "entity" or "asteroid-chunk",
      spawn_points={
        {position=0.1,probability=p*0.5,angle_when_stopped=angle},
        {position=0.5,probability=p,angle_when_stopped=angle},
        {position=0.9,probability=p*0.5,angle_when_stopped=angle}
      }
    }
  end
  return 1
end
local count=0
for _,kind in ipairs({"planet","space-location"}) do
  for _,place in pairs(data.raw[kind] or {}) do
    local family=profiles[name_of(place.name)]
    if family then
      place.asteroid_spawn_definitions=place.asteroid_spawn_definitions or {}
      for _,material in ipairs(family) do
        count=count+add(place.asteroid_spawn_definitions,material,false,true)
        count=count+add(place.asteroid_spawn_definitions,material,true,true)
      end
    end
  end
end
for _,route in pairs(data.raw["space-connection"] or {}) do
  if not route.hidden then
    local family=profiles[name_of(route.to)] or profiles[name_of(route.from)]
    if family then
      route.asteroid_spawn_definitions=route.asteroid_spawn_definitions or {}
      for _,material in ipairs(family) do
        count=count+add(route.asteroid_spawn_definitions,material,false,false)
        count=count+add(route.asteroid_spawn_definitions,material,true,false)
      end
    end
  end
end
if type(log)=="function" then
  log("[Razi More Asteroids] Added "..count.." non-duplicate K2SO and RP3 asteroid spawns")
end
