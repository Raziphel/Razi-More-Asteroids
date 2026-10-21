-- K2SO-first, non-destructive fluid support for asteroid processing.
-- Source: More Asteroids (MIT), redesigned to preserve other mods' machine prototypes.
local machines = data.raw["assembling-machine"] or {}

local function apply_if_missing(name, boxes, symmetry)
  local machine=machines[name]
  if not machine then return false end
  if type(machine.fluid_boxes)=="table" and next(machine.fluid_boxes) then
    return false
  end
  machine.fluid_boxes=boxes
  machine.fluid_boxes_off_when_no_fluid_recipe=true
  if symmetry and not machine.forced_symmetry then
    machine.forced_symmetry=symmetry
  end
  return true
end

apply_if_missing("crusher", {
  {
    production_type="input", volume=1000,
    pipe_connections={
      {flow_direction="input-output",direction=defines.direction.west,position={-0.5,-1}},
      {flow_direction="input-output",direction=defines.direction.west,position={-0.5,1}},
      {flow_direction="input-output",direction=defines.direction.east,position={0.5,0}}
    }
  },
  {
    production_type="output",volume=1000,
    pipe_connections={{flow_direction="output",direction=defines.direction.west,position={-0.5,0}}}
  },
  {
    production_type="output",volume=1000,
    pipe_connections={{flow_direction="output",direction=defines.direction.east,position={0.5,-1}}}
  },
  {
    production_type="output",volume=1000,
    pipe_connections={{flow_direction="output",direction=defines.direction.east,position={0.5,1}}}
  }
})

-- Crushing Industry's big crusher is present in some K2SO packs. Matching
-- Null's Tweaks safe-if-missing pattern avoids conflicting with its patch.
apply_if_missing("big-crusher", {
  {
    production_type="input",volume=200,
    pipe_connections={{flow_direction="input-output",direction=12,position={-1.5,0.5}}}
  },
  {
    production_type="input",volume=200,
    pipe_connections={{flow_direction="input-output",direction=4,position={1.5,-0.5}}}
  }
}, "horizontal")
