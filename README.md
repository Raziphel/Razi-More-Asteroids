# Razi More Asteroids

Standalone Factorio **2.1 Space Age** asteroid mod, based on [More Asteroids](https://mods.factorio.com/mod/More-Asteroids) by spartanlaser32. **Krastorio 2: Spaced Out (K2SO) is optional**, not a requirement.

## Six resource families

| Family | Space Age resources | Optional K2SO enhancements |
| --- | --- | --- |
| Uranium | Uranium ore and isotopes | Existing uranium processing |
| Rock | Stone and tungsten ore | Rare-metal ore recovery |
| Scrap | Fulgora recyclable scrap | Existing scrap processing |
| Organic | Spoilage and advanced biological products | Biomass recovery |
| Chemical | Ammonia, fluorine and lithium brine | Mineral-water recovery |
| Crystalline | Stone, ice and trace calcite | Sand, quartz and trace rare-metal ore |

Crystalline replaces Petrified, including its prototypes and artwork. Back up saves containing the retired Petrified asteroid family before upgrading. All 72 active original sprites/icons have been resource-color-graded without changing original silhouettes, frames or alpha.

## Vanilla Space Age compatibility

- Spawns themed asteroid families around Nauvis, Vulcanus, Gleba, Fulgora, Aquilo and the edge/shattered destinations, as well as their existing vanilla routes.
- Extends spawn definitions without overwriting native or other mod records; avoids duplicate entries.
- Unlocks processing with Space Age technology progression, using existing research and productivity technologies.
- Gives Crystalline useful Space Age outputs even when K2SO is absent.
- Preserves existing crusher fluid boxes, with guarded ports where otherwise missing.
- Uses no runtime polling, saved globals, RP3-specific planet names or custom galaxy logic.

## Optional K2SO processing

When K2SO is installed, Crystalline yields sand and quartz instead of the vanilla mineral fallback. Basic crystalline crushing gives 8 sand and 2 quartz. Advanced crushing consumes sulfuric acid and yields 4 quartz plus a small rare-metal ore chance.

Eight specialty recipes unlock through advanced asteroid processing:

- Crystalline leaching: 3 crystalline chunks + 75 sulfuric acid produces 1 raw rare-metal ore and 4 quartz.
- Rock rare-metal recovery: 2 rock chunks + 30 sulfuric acid produces 6 stone and a 35% chance for raw rare-metal ore.
- Organic biomass: 2 organic chunks + 5 nutrients produces 3 K2SO biomass and 5 spoilage.
- Chemical extraction: 2 chemical chunks + 50 water produces 30 K2SO mineral water and 2 sulfur.

Additional K2SO-only processing after advanced asteroid research:

- Scrap sorting: 3 scrap chunks gives 6 scrap plus chances for K2SO electronic components and inserter parts.
- Hydrogen recovery: 2 chemical chunks + 50 water gives 30 hydrogen and 2 sulfur.
- Oxygen recovery: 2 chemical chunks + 50 water gives 30 oxygen and 2 sulfur.
- Quartz washing: 2 crystalline chunks + 40 water gives 6 quartz and 4 sand.

The K2SO ground crusher also supports DRY regular asteroid crushing and dry scrap sorting. Fluid-input or fluid-output recipes stay exclusive to fluid-capable Space Age crushers, and the K2SO machine's own fluid boxes are never modified.

Each specialized recipe is registered only when its ingredient/result prototypes exist. Other K2SO compatibility mods may rename kr-sand to sand, which is resolved at final-fixes. Ore still requires K2SO refining. No imersite, free science, or planetary endgame skips.

## Startup settings

| Setting | Default | Meaning |
| --- | --- | --- |
| Space Age asteroid routes | On | Add asteroids only on native Space Age locations and routes. Internal setting name retained for existing saves. |
| K2SO orbital resource recovery | On | Enable the eight specialized recipes when K2SO is installed. No effect without K2SO. |

## Integration boundary

Razi Protocol owns its own custom planets, asteroid belts, quality escalation, journals, and difficulty balance. This fork does not apply those RP3-specific changes and does not require RP3. The upstream optional-planet profiles are not activated.

Do not install the original More Asteroids simultaneously. Do not add another quality-asteroid layer here.

## Build and verification

Package using the Python helper in tools/package_fork.py. Test with tools/smoke.py, tools/test_space_age_compat.py, tools/test_k2so_integration.py, and tools/test_asteroid_art.py. These structural tests do not replace actual Factorio 2.1 startup tests in (1) Space Age alone and (2) Space Age + K2SO.

Not yet verified as a public Mod Portal release.

## Credit and license

Original [More Asteroids](https://github.com/spartanlaser32/More-Asteroids) by spartanlaser32, released under MIT. Original license and credit preserved. Razi's Realm provides the fork adaptations and recolored original graphics.
