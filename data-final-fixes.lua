-- Space Age is the standalone base. K2SO support loads only if installed.
-- Factorio calls this after data-updates for all loaded mods.
local opts = settings and settings.startup or {}
local option = opts["razi-more-asteroids-k2so-recovery"]
if mods and mods["Krastorio2-spaced-out"] then
  -- Resolve sand/quartz aliases after K2SO and its own final-fixes.
  require("prototypes.compat.crystalline")
  if not option or option.value == true then
    require("prototypes.compat.k2so_recipes")
    require("prototypes.compat.k2so_extended_recipes")
  end
  -- Existing ground K2SO crushers can perform dry asteroid processing.
  require("prototypes.compat.k2so_crushers")
else
  -- No K2SO item IDs in the final Space Age recipe prototypes.
  require("prototypes.compat.space_age_recipes")
end
