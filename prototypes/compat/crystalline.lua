-- Resolve the actual K2SO items after compatibility mods have loaded.
-- Other K2SO compatibility mods can rename kr-sand -> sand; never leave
-- missing result prototypes in the original crystalline crushing recipes.
local items = data.raw.item or {}
local Recipe = require("__razi_lib__/lib/recipe")
local sand = items["kr-sand"] and "kr-sand" or (items["sand"] and "sand")
local quartz = items["kr-quartz"] and "kr-quartz"
local ore = items["kr-rare-metal-ore"] and "kr-rare-metal-ore"
local stone = items["stone"] and "stone"

local function item_result(name, amount, probability)
  if not name then return nil end
  local result = {type = "item", name = name, amount = amount}
  if probability then result.probability = probability end
  return result
end

local function append(results, name, amount, probability)
  local result = item_result(name, amount, probability)
  if result then results[#results + 1] = result end
end

local basic = Recipe.optional("crystalline-asteroid-crushing")
if basic then
  local results = {}
  append(results, sand or stone, 8)
  append(results, quartz or stone, 2)
  append(results, "crystalline-asteroid-chunk", 1, 0.2)
  basic:set_results(results):set_main_product(nil)
end

local advanced = Recipe.optional("advanced-crystalline-asteroid-crushing")
if advanced then
  local results = {}
  append(results, quartz or stone, 4)
  -- A rare trace, not a bulk source: advanced leaching is the deliberate
  -- source once advanced asteroid processing has been researched.
  append(results, ore, 1, 0.2)
  append(results, "crystalline-asteroid-chunk", 1, 0.05)
  advanced:set_results(results):set_main_product(nil)
end

if type(log) == "function" and (not sand or not quartz or not ore) then
  log("[Razi More Asteroids] Crystalline fallback: K2SO resources missing (sand="
    .. tostring(sand) .. ", quartz=" .. tostring(quartz) .. ", rare ore=" .. tostring(ore) .. ")")
end
