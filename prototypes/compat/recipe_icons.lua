-- Recipe artwork is assembled from the REAL item/fluid icons. Tinting a
-- single rock graphic for every ingredient hid the distinct recovered
-- materials. This keeps source chunks recognizable while showing outputs in
-- their original colors, including mods that replace the output icons.
local families = {
  "uranium", "rock", "scrap", "organic",
  "chemical", "crystalline", "halide", "electrostatic"
}

local specialties = {
  "razi-orbital-rare-metal-recovery", "razi-crystalline-ore-leaching",
  "razi-orbital-biomass-recovery", "razi-orbital-mineral-water-recovery",
  "razi-orbital-scrap-sorting", "razi-orbital-hydrogen-recovery",
  "razi-orbital-oxygen-recovery", "razi-orbital-conductor-recovery"
}

local function get_prototype(kind, name)
  return (data.raw[kind] or {})[name]
end

local function add_layers(icons, prototype, scale, offset)
  if not prototype then return false end
  local layers = prototype.icons
  if not layers then
    if not prototype.icon then return false end
    layers = {{icon=prototype.icon, icon_size=prototype.icon_size or 64}}
  end
  local added = false
  for _, original in ipairs(layers) do
    if original.icon then
      local layer = table.deepcopy(original)
      local shift = layer.shift or {0, 0}
      layer.icon_size = layer.icon_size or prototype.icon_size or 64
      layer.scale = (layer.scale or 1) * scale
      layer.shift = {
        (shift[1] or 0) * scale + offset[1],
        (shift[2] or 0) * scale + offset[2]
      }
      icons[#icons + 1] = layer
      added = true
    end
  end
  return added
end

local function recipe_icon(recipe)
  if not recipe then return end
  local source_name, source_proto
  for _, ingredient in ipairs(recipe.ingredients or {}) do
    if ingredient.type == "item"
      and ingredient.name:find("%-asteroid%-chunk$") then
      source_name = ingredient.name
      source_proto = get_prototype("item", source_name)
      break
    end
  end
  if not source_proto then return end

  local products, seen = {}, {}
  for _, result in ipairs(recipe.results or {}) do
    -- Own-chunk returns are catalysts, not a visibly different product.
    if result.name ~= source_name and not seen[result.name] then
      local prototype = get_prototype(result.type, result.name)
      if prototype and (prototype.icon or prototype.icons) then
        products[#products + 1] = prototype
        seen[result.name] = true
      end
    end
  end
  -- Muluna's outputs are the same item at higher quality. Show its real
  -- astronomical-data ingredient in the corner instead of a second rock.
  if #products == 0 then
    for _, ingredient in ipairs(recipe.ingredients or {}) do
      if ingredient.type == "fluid"
        and ingredient.name == "muluna-astronomical-data" then
        products[1] = get_prototype("fluid", ingredient.name)
      end
    end
  end

  local icons = {}
  if not add_layers(icons, source_proto, 0.69, {-9, -4}) then return end
  if #products == 1 then
    add_layers(icons, products[1], 0.40, {14, 10})
  elseif #products == 2 then
    add_layers(icons, products[1], 0.32, {14, -11})
    add_layers(icons, products[2], 0.32, {14, 12})
  elseif #products >= 3 then
    add_layers(icons, products[1], 0.28, {11, -15})
    add_layers(icons, products[2], 0.28, {16, 0})
    add_layers(icons, products[3], 0.28, {11, 15})
  end
  if #icons == 0 then return end
  recipe.icon = nil
  recipe.icon_size = 64
  recipe.icons = icons
end

for _, family in ipairs(families) do
  for _, prefix in ipairs({"", "advanced-"}) do
    recipe_icon(data.raw.recipe[prefix .. family .. "-asteroid-crushing"])
  end
  recipe_icon(data.raw.recipe[family .. "-asteroid-reprocessing"])
  recipe_icon(data.raw.recipe["muluna-" .. family .. "-asteroid-chunk-upcycling"])
end

for _, name in ipairs(specialties) do
  recipe_icon(data.raw.recipe[name])
end
