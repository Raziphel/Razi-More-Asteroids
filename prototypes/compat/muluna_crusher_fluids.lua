-- Muluna's Crusher 2 gets the same fluid connections as the crusher.
-- k2so_fluids.lua gives the crusher fluid boxes in data-updates. Muluna copies
-- Crusher 2 from the crusher in data.lua, before that, and in its
-- data-final-fixes (prototypes/final-fixes/data-cells.lua) replaces the fluid
-- boxes of Crusher 2 with linked placeholders and one "data" port at index 30.
-- The wet crushing recipes can still run in Crusher 2, so their fluid could only
-- enter through the data port. Copies of Crusher 2 made by other mods (Tenebris
-- bioluminescent, Rabbasca harene-infused) keep its category and its layout.
-- Put the crusher's boxes in front. A recipe's fluidbox_index counts only the
-- boxes of its own production type, and Muluna's data recipes pin their fluid to
-- input 30, so one input placeholder is dropped for each input box added.
if not (mods and mods["planet-muluna"]) then return end

local machines = data.raw["assembling-machine"] or {}
local crusher = machines["crusher"]
if not (crusher and type(crusher.fluid_boxes) == "table") then return end

local function is_placeholder(box)
  local connections = box.pipe_connections or {}
  return #connections == 1 and connections[1].connection_type == "linked"
end

local function category_of(connection, name)
  local category = connection.connection_category
  if type(category) == "string" then return category == name end
  for _, value in ipairs(category or {}) do
    if value == name then return true end
  end
  return category == nil and name == "default"
end

local function has_port(machine, name)
  for _, box in ipairs(machine.fluid_boxes or {}) do
    for _, connection in ipairs(box.pipe_connections or {}) do
      if connection.connection_type ~= "linked" and category_of(connection, name) then return true end
    end
  end
  return false
end

local function has_category(machine, name)
  for _, category in ipairs(machine.crafting_categories or {}) do
    if category == name then return true end
  end
  return false
end

local function key(connection)
  local position = connection.position or {}
  return tostring(position.x or position[1]) .. "," .. tostring(position.y or position[2])
    .. "," .. tostring(connection.direction)
end

-- The data port sits where the crusher has an east output ({0.5, -1}); a
-- crusher box with a connection on an occupied spot is left out. The wet
-- crushing recipes have at most two fluid results, the other two outputs stay.
local function pipes_for(machine)
  local taken = {}
  for _, box in ipairs(machine.fluid_boxes or {}) do
    for _, connection in ipairs(box.pipe_connections or {}) do
      if connection.connection_type ~= "linked" then taken[key(connection)] = true end
    end
  end
  local pipes = {}
  for _, box in ipairs(crusher.fluid_boxes) do
    local free = not is_placeholder(box)
    for _, connection in ipairs(box.pipe_connections or {}) do
      if taken[key(connection)] then free = false end
    end
    if free then pipes[#pipes + 1] = box end
  end
  return pipes
end

local names = {}
for name in pairs(machines) do names[#names + 1] = name end
table.sort(names)

for _, name in ipairs(names) do
  local machine = machines[name]
  local pipes = {}
  if has_category(machine, "muluna-crusher-2") and has_port(machine, "data")
      and not has_port(machine, "default") then
    pipes = pipes_for(machine)
  end
  if #pipes > 0 then
    local boxes = {}
    for _, box in ipairs(pipes) do boxes[#boxes + 1] = table.deepcopy(box) end
    local to_drop = 0
    for _, box in ipairs(pipes) do
      if box.production_type == "input" then to_drop = to_drop + 1 end
    end
    for _, box in ipairs(machine.fluid_boxes) do
      if to_drop > 0 and is_placeholder(box) and box.production_type == "input" then
        to_drop = to_drop - 1
      else
        boxes[#boxes + 1] = box
      end
    end
    if to_drop == 0 then
      machine.fluid_boxes = boxes
      if type(log) == "function" then
        log("[Razi More Asteroids] " .. name .. " gets the crusher's fluid connections next to its data port")
      end
    elseif type(log) == "function" then
      log("[Razi More Asteroids] " .. name .. " has too few placeholder fluid boxes, its fluid connections stay as they are")
    end
  end
end
