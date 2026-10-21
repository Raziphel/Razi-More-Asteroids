-- Depend on published RaziLib 1.3.1; centralize startup setting definitions.
local Settings = require("__razi_lib__/lib/settings")
data:extend({
  Settings.bool("razi-more-asteroids-extended-routes", "startup", true, "a"),
  Settings.bool("razi-more-asteroids-k2so-recovery", "startup", true, "b")
})
