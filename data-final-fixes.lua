-- Factorio automatically executes this after all mods' data-updates.lua.
-- When RP3 depends on this standalone mod, RP3's own quality-asteroid
-- data-final-fixes will see and quality-scale our real hostile prototypes.
local options=settings and settings.startup or {}
local function enabled(id)
  local setting=options[id]
  return setting==nil or setting.value==true
end
require("prototypes.compat.crystalline")
if enabled("razi-more-asteroids-k2so-recovery") then
  require("prototypes.compat.k2so_recipes")
end
if enabled("razi-more-asteroids-extended-routes") then
  require("prototypes.compat.razi_routes")
end
