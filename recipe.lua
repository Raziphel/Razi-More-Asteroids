data:extend(
{
    {
        type = "recipe",
        name = "uranium-asteroid-crushing",
        icon = "__razi-more-asteroids__/graphics/icons/uranium-asteroid-crushing.png",
        categories = {"crushing"},
        subgroup="space-crushing",
        order = "b-a-a",
        auto_recycle = false,
        enabled = false,
        ingredients =
        {
        {type = "item", name = "uranium-asteroid-chunk", amount = 1},
        {type = "fluid", name = "sulfuric-acid", amount = 20}
        },
        energy_required = 2,
        results =
        {
        {type = "item", name = "uranium-ore", amount = 20},
        {type = "item", name = "uranium-asteroid-chunk", amount = 1, probability = 0.2}
        },
        allow_productivity = true,
        allow_decomposition = false
    },
    {
        type = "recipe",
        name = "advanced-uranium-asteroid-crushing",
        icon = "__razi-more-asteroids__/graphics/icons/advanced-uranium-asteroid-crushing.png",
        categories = {"crushing"},
        subgroup="space-crushing",
        order = "b-a-a",
        auto_recycle = false,
        enabled = false,
        ingredients =
        {
        {type = "item", name = "uranium-asteroid-chunk", amount = 1},
        {type = "fluid", name = "sulfuric-acid", amount = 20}
        },
        energy_required = 2,
        results =
        {
        {type = "item", name = "uranium-ore", amount = 10},
        {type = "item", name = "uranium-235", amount = 1, probability = 0.05},
        {type = "item", name = "uranium-238", amount = 1, probability = 0.95},
        {type = "item", name = "uranium-asteroid-chunk", amount = 1, probability = 0.05}
        },
        allow_productivity = true,
        allow_decomposition = false
    },
    {
        type = "recipe",
        name = "rock-asteroid-crushing",
        icon = "__razi-more-asteroids__/graphics/icons/rock-asteroid-crushing.png",
        categories = {"crushing"},
        subgroup="space-crushing",
        order = "b-a-a",
        auto_recycle = false,
        enabled = false,
        ingredients =
        {
        {type = "item", name = "rock-asteroid-chunk", amount = 1},
        },
        energy_required = 2,
        results =
        {
        {type = "item", name = "stone", amount = 20},
        {type = "item", name = "rock-asteroid-chunk", amount = 1, probability = 0.2}
        },
        allow_productivity = true,
        allow_decomposition = false
    },
    {
        type = "recipe",
        name = "advanced-rock-asteroid-crushing",
        icon = "__razi-more-asteroids__/graphics/icons/advanced-rock-asteroid-crushing.png",
        categories = {"crushing"},
        subgroup="space-crushing",
        order = "b-a-a",
        auto_recycle = false,
        enabled = false,
        ingredients =
        {
        {type = "item", name = "rock-asteroid-chunk", amount = 1},
        },
        energy_required = 2,
        results =
        {
        {type = "item", name = "stone", amount = 5},
        {type = "item", name = "tungsten-ore", amount = 5},
        {type = "item", name = "rock-asteroid-chunk", amount = 1, probability = 0.05}
        },
        allow_productivity = true,
        allow_decomposition = false
    },
    {
        type = "recipe",
        name = "chemical-asteroid-crushing",
        icon = "__razi-more-asteroids__/graphics/icons/chemical-asteroid-crushing.png",
        categories = {"crushing"},
        subgroup="space-crushing",
        order = "b-a-a",
        auto_recycle = false,
        enabled = false,
        ingredients =
        {
        {type = "item", name = "chemical-asteroid-chunk", amount = 1},
        },
        energy_required = 2,
        results =
        {
        {type = "fluid", name = "ammonia", amount = 20},
        {type = "item", name = "chemical-asteroid-chunk", amount = 1, probability = 0.2}
        },
        allow_productivity = true,
        allow_decomposition = false
    },
    {
        type = "recipe",
        name = "advanced-chemical-asteroid-crushing",
        icon = "__razi-more-asteroids__/graphics/icons/advanced-chemical-asteroid-crushing.png",
        categories = {"crushing"},
        subgroup="space-crushing",
        order = "b-a-a",
        auto_recycle = false,
        enabled = false,
        ingredients =
        {
        {type = "item", name = "chemical-asteroid-chunk", amount = 1},
        },
        energy_required = 2,
        results =
        {
        {type = "fluid", name = "ammonia", amount = 5},
        {type = "fluid", name = "fluorine", amount = 5},
        {type = "fluid", name = "lithium-brine", amount = 5},
        {type = "item", name = "chemical-asteroid-chunk", amount = 1, probability = 0.05}
        },
        allow_productivity = true,
        allow_decomposition = false
    },
    {
        type = "recipe",
        name = "scrap-asteroid-crushing",
        icon = "__razi-more-asteroids__/graphics/icons/scrap-asteroid-crushing.png",
        categories = {"crushing"},
        subgroup="space-crushing",
        order = "b-a-a",
        auto_recycle = false,
        enabled = false,
        ingredients =
        {
        {type = "item", name = "scrap-asteroid-chunk", amount = 1},
        },
        energy_required = 2,
        results =
        {
        {type = "item", name = "scrap", amount = 20},
        {type = "item", name = "scrap-asteroid-chunk", amount = 1, probability = 0.2}
        },
        allow_productivity = true,
        allow_decomposition = false
    },
    {
        type = "recipe",
        name = "advanced-scrap-asteroid-crushing",
        icon = "__razi-more-asteroids__/graphics/icons/advanced-scrap-asteroid-crushing.png",
        categories = {"crushing"},
        subgroup="space-crushing",
        order = "b-a-a",
        auto_recycle = false,
        enabled = false,
        ingredients =
        {
        {type = "item", name = "scrap-asteroid-chunk", amount = 1},
        },
        energy_required = 2,
        results =
        {
        {type = "item", name = "scrap", amount_min = 5, amount_max = 50},
        {type = "item", name = "scrap-asteroid-chunk", amount = 1, probability = 0.05}
        },
        allow_productivity = true,
        allow_decomposition = false
    },
    {
        type = "recipe",
        name = "organic-asteroid-crushing",
        icon = "__razi-more-asteroids__/graphics/icons/organic-asteroid-crushing.png",
        categories = {"crushing"},
        subgroup="space-crushing",
        order = "b-a-a",
        auto_recycle = false,
        enabled = false,
        ingredients =
        {
        {type = "item", name = "organic-asteroid-chunk", amount = 1},
        },
        energy_required = 2,
        results =
        {
        {type = "item", name = "spoilage", amount_min = 5, amount_max = 50},
        {type = "item", name = "organic-asteroid-chunk", amount = 1, probability = 0.2}
        },
        allow_productivity = true,
        allow_decomposition = false
    },
    {
        type = "recipe",
        name = "advanced-organic-asteroid-crushing",
        icon = "__razi-more-asteroids__/graphics/icons/advanced-organic-asteroid-crushing.png",
        categories = {"crushing"},
        subgroup="space-crushing",
        order = "b-a-a",
        auto_recycle = false,
        enabled = false,
        ingredients =
        {
        {type = "item", name = "organic-asteroid-chunk", amount = 1},
        {type = "item", name = "nutrients", amount = 5},
        {type = "fluid", name = "water", amount = 50},

        },
        energy_required = 2,
        results =
        {
        {type = "item", name = "pentapod-egg", amount = 1, probability = 0.1},
        {type = "item", name = "yumako", amount = 5, probability = 0.5},
        {type = "item", name = "jellynut", amount = 10, probability = 0.125},
        {type = "item", name = "organic-asteroid-chunk", amount = 1, probability = 0.05}
        },
        allow_productivity = true,
        allow_decomposition = false
    },
    {
        type = "recipe",
        name = "crystalline-asteroid-crushing",
        icon = "__razi-more-asteroids__/graphics/icons/crystalline-asteroid-crushing.png",
        categories = {"crushing"},
        subgroup="space-crushing",
        order = "b-a-a",
        auto_recycle = false,
        enabled = false,
        ingredients =
        {
        {type = "item", name = "crystalline-asteroid-chunk", amount = 1},
        },
        energy_required = 2,
        results =
        {
        {type = "item", name = "stone", amount = 8},
        {type = "item", name = "ice", amount = 2},
        {type = "item", name = "crystalline-asteroid-chunk", amount = 1, probability = 0.2}
        },
        allow_productivity = true,
        allow_decomposition = false
    },
    {
        type = "recipe",
        name = "advanced-crystalline-asteroid-crushing",
        icon = "__razi-more-asteroids__/graphics/icons/advanced-crystalline-asteroid-crushing.png",
        categories = {"crushing"},
        subgroup="space-crushing",
        order = "b-a-a",
        auto_recycle = false,
        enabled = false,
        ingredients =
        {
        {type = "item", name = "crystalline-asteroid-chunk", amount = 1},
        {type = "fluid", name = "sulfuric-acid", amount = 20},

        },
        energy_required = 2,
        results =
        {
        {type = "item", name = "stone", amount = 4},
        {type = "item", name = "calcite", amount = 1, probability = 0.25},
        {type = "item", name = "crystalline-asteroid-chunk", amount = 1, probability = 0.05}
        },
        allow_productivity = true,
        allow_decomposition = false
    }
  })


-- New, independently collectible asteroid families. Reuse proven recipe
-- prototypes rather than inventing a second machine or crafting category.
local function add_family_recipe(family, source, advanced, results)
  local source_name = (advanced and "advanced-" or "") .. source .. "-asteroid-crushing"
  local name = (advanced and "advanced-" or "") .. family .. "-asteroid-crushing"
  local prototype = table.deepcopy(data.raw.recipe[source_name])
  prototype.name = name
  prototype.icon = "__razi-more-asteroids__/graphics/icons/" .. name .. ".png"
  prototype.ingredients = {{type="item",name=family.."-asteroid-chunk",amount=1}}
  prototype.results = results
  prototype.energy_required = advanced and 4 or 2
  prototype.order = "b-a-" .. (family == "halide" and "m" or "n")
  prototype.enabled = false
  prototype.main_product = nil
  data:extend({prototype})
end

add_family_recipe("halide","chemical",false,{
  {type="fluid",name="fluorine",amount=12}
})
add_family_recipe("halide","chemical",true,{
  {type="fluid",name="fluorine",amount=10},
  {type="fluid",name="lithium-brine",amount=14}
})
add_family_recipe("electrostatic","crystalline",false,{
  {type="item",name="holmium-ore",amount=3}
})
add_family_recipe("electrostatic","crystalline",true,{
  {type="item",name="holmium-ore",amount=7}
})
