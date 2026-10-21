-- K2SO's ground crusher is a furnace with the kr-crushing category.
-- Make ONLY dry asteroid crushing available there: changing wet recipes would
-- allow a machine without fluid ports to select recipes it cannot finish.
local recipes = data.raw.recipe or {}
local furnaces = data.raw.furnace or {}
local crusher = furnaces["kr-crusher"]
local found = false
for _,cat in ipairs(crusher and crusher.crafting_categories or {}) do
  if cat == "kr-crushing" then found = true end
end
if not found or not (data.raw["recipe-category"] or {})["kr-crushing"] then
  return
end

local function contains_fluid(recipe)
  for _,key in ipairs({"ingredients","results"}) do
    for _,component in ipairs(recipe[key] or {}) do
      if component.type == "fluid" then return true end
    end
  end
  return false
end

local families = {"uranium","rock","scrap","organic","chemical","crystalline"}
local count = 0
for _,family in ipairs(families) do
  for _,prefix in ipairs({"","advanced-"}) do
    local recipe = recipes[prefix..family.."-asteroid-crushing"]
    if recipe and not contains_fluid(recipe) then
      local cats = {}
      local seen = {}
      local function append(name)
        if name and not seen[name] then
          cats[#cats+1] = name
          seen[name] = true
        end
      end
      for _,cat in ipairs(recipe.categories or {}) do append(cat) end
      append("kr-crushing")
      recipe.categories = cats
      count = count + 1
    end
  end
end
local salvage=recipes["razi-orbital-scrap-sorting"]
if salvage and not contains_fluid(salvage) then
  salvage.categories={"crushing","kr-crushing"}
  count=count+1
end
if type(log) == "function" then
  log("[Razi More Asteroids] Enabled "..count.." dry asteroid recipes in K2SO crushers")
end
