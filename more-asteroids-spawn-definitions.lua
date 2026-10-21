-- Eight distinct Space Age asteroid ecologies. RP3 owns any custom routes.
-- Keep the published family IDs (uranium/rock/scrap/organic/chemical/
-- crystalline) for saved games. Halide/electrostatic are new.
local M = {}
local speed = 1 * meter / second
-- Profile start/final ratios, density of collectable chunks, threat scaling.
-- Ore-rich asteroids do not appear plentiful around Nauvis.
local function profile(near,far,chunks,threat)
  return {near=near,far=far,chunks=chunks,threat=threat}
end
M.nauvis_vulcanus=profile(
  {uranium=0.45,rock=0.55},
  {rock=0.30,crystalline=0.65,uranium=0.05},{0.004,0.006},{0,0.35})
M.nauvis_gleba=profile(
  {uranium=0.6,rock=0.4},
  {organic=0.85,uranium=0.15},{0.003,0.005},{0,0.3})
M.nauvis_fulgora=profile(
  {uranium=0.6,rock=0.4},
  {scrap=0.55,electrostatic=0.30,uranium=0.15},{0.004,0.006},{0,0.5})
M.vulcanus_gleba=profile(
  {rock=0.4,crystalline=0.6},
  {organic=0.7,rock=0.3},{0.004,0.006},{0.3,0.6})
M.gleba_fulgora=profile(
  {organic=0.75,uranium=0.25},
  {scrap=0.55,electrostatic=0.45},{0.005,0.006},{0.45,0.7})
M.gleba_aquilo=profile(
  {organic=0.7,chemical=0.3},
  {chemical=0.50,halide=0.45,organic=0.05},{0.004,0.007},{0.5,0.85})
M.fulgora_aquilo=profile(
  {scrap=0.55,electrostatic=0.45},
  {chemical=0.35,halide=0.50,electrostatic=0.15},{0.005,0.007},{0.6,0.95})
M.aquilo_solar_system_edge=profile(
  {chemical=0.45,halide=0.45,electrostatic=0.1},
  {halide=0.4,crystalline=0.3,electrostatic=0.3},{0.003,0.004},{0.95,1.5})
M.shattered_planet_trip=profile(
  {halide=0.30,crystalline=0.35,electrostatic=0.35},
  {electrostatic=0.45,crystalline=0.35,uranium=0.20},
  {0.0025,0.002},{1.5,2.3})

local families={"uranium","rock","scrap","organic","chemical",
  "crystalline","halide","electrostatic"}
local sizes={"chunk","small","medium","big","huge"}
local sizes_mult={1,0.30,0.18,0.06,0.017}
local size_angle={1,0.7,0.6,0.5,0.4}
local function lerp(a,b,t) return a+(b-a)*t end
local function weight(profile,family,at)
  local t=math.max(0,math.min(1,(at-0.1)/0.8))
  return lerp(profile.near[family] or 0,profile.far[family] or 0,t)
end
local function total(profile,at)
  local sum=0
  for _,family in ipairs(families) do sum=sum+weight(profile,family,at) end
  return math.max(sum,0.0001)
end
local function chance(profile,family,size,at)
  local t=math.max(0,math.min(1,(at-0.1)/0.8))
  local density=lerp(profile.chunks[1],profile.chunks[2],t)
  local danger=lerp(profile.threat[1],profile.threat[2],t)
  local modifier=sizes_mult[size]
  if size>1 then modifier=modifier*danger end
  return density*modifier*weight(profile,family,at)/total(profile,at)
end
function M.spawn_definitions(profile,at)
  local result={}
  if not profile then return result end
  for _,family in ipairs(families) do
    for size_index,size in ipairs(sizes) do
      local asteroid=(size=="chunk" and family.."-asteroid-chunk"
        or size.."-"..family.."-asteroid")
      local angle=size_angle[size_index]
      if at then
        local probability=chance(profile,family,size_index,at)
        if probability>0 then
          result[#result+1]={
            asteroid=asteroid,
            type=size=="chunk" and "asteroid-chunk" or nil,
            probability=probability,speed=speed,angle_when_stopped=angle
          }
        end
      else
        local points={}
        local any=false
        for _,distance in ipairs({0.1,0.5,0.9}) do
          local probability=chance(profile,family,size_index,distance)
          any=any or probability>0
          points[#points+1]={
            distance=distance,probability=probability,
            speed=speed,angle_when_stopped=angle
          }
        end
        if any then
          result[#result+1]={
            asteroid=asteroid,
            type=size=="chunk" and "asteroid-chunk" or nil,
            spawn_points=points
          }
        end
      end
    end
  end
  return result
end
return M
