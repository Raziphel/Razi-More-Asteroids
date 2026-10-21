# Razi More Asteroids

A Factorio **2.1 Space Age** mod with **eight distinct asteroid families** using updated versions of the original More Asteroids graphics. Based on the MIT-licensed original by spartanlaser32.

**Requires:** Space Age 2.1.20+ and [RAZI Library](https://mods.factorio.com/mod/razi_lib) 1.3.1+. **Optional:** Krastorio 2: Spaced Out (K2SO) 2.0.17+. Does not require Razi Protocol.

## Eight orbital resources

| In-game identity | Basic extraction | Advanced extraction | K2SO integration |
| --- | --- | --- | --- |
| Radioactive | Uranium ore | Uranium isotopes | Uranium processing chain |
| Lithic | Stone | Stone + calcite | K2SO stone/sand/glass processing |
| Dense-Metal | Tungsten ore | More tungsten | Raw rare-metal ore, acid leaching |
| Wreckage | Fulgora scrap | Consistent scrap recovery | Electronic components and inserter-part salvage |
| Biogenic | Spoilage | Nutrient-fed biological recovery | Biomass processing |
| Volatile | Ammonia | More ammonia | Hydrogen and oxygen extraction |
| Halide | Fluorine | Fluorine + lithium brine | Mineral water and sulfur recovery |
| Electrostatic | Holmium ore | More holmium | K2SO silicon and conductor recovery |

These are eight *new asteroid families* relative to vanilla Space Age's Metallic, Carbonic, Oxide and Promethium asteroids. No fictional lens factories or extra materials are needed.

**Existing-save compatibility:** the six established prototype IDs (`uranium`, `rock`, `scrap`, `organic`, `chemical`, `crystalline`) remain unchanged, but their displayed identities and outputs have changed. Dense-Metal uses the former Crystalline ID. Halide and Electrostatic add entirely new prototype IDs. Back up existing games and review production lines before updating.

## Game progression and locations

Families appear in themed densities across native Space Age routes and vanilla planet orbits, with additional hazards on outer-system routes. Dense-Metal requires Vulcanus discovery to process tungsten; Electrostatic requires Fulgora discovery to process holmium; Halide and Volatile require Aquilo discovery for their chemical products. Custom RP3 planet routes and asteroid quality are handled by RP3, not this mod.

Existing vanilla and third-party asteroid spawn entries are preserved and duplicate records are avoided. Space Age's base asteroid types are not replaced.

## Deeper K2SO integration

K2SO expands processing without replacing its normal industry or providing free tech cards:

- Dense-Metal: raw rare-metal ore separation and acid-based ore leaching.
- Wreckage: salvage electronic components and inserter parts.
- Biogenic: recover biomass using nutrients.
- Volatile: wash volatile chunks for hydrogen or oxygen.
- Halide: mineral-water extraction and sulfur separation.
- Electrostatic: acid-based recovery of holmium and K2SO silicon.
- Lithic: yields stone for the existing K2SO mineral/glass lines.
- Radioactive: uranium and isotope products for the existing nuclear chain.

All eight optional specialty recipes require valid K2SO prototypes and the relevant processing research. Dry recipes can run in compatible K2SO crushers; wet recipes remain in fluid-capable crushers. The mod does not modify K2SO's own recipe balances.

## Original artwork, refreshed

All eight families reuse the original asteroid geometry. Two new sets of variants were made by modifying existing Chemical and Crystalline textures rather than using generated artwork. Dense-Metal, Volatile, Halide and Electrostatic have distinctive updated shading. Icons are 64×64; the Mod Portal thumbnail is 144×144.

## Settings

- **Populate Space Age asteroid routes** (on): add all eight families to vanilla routes and locations.
- **Enable K2SO orbital resource recovery** (on): register eight optional K2SO recovery recipes when K2SO is installed.

## Packaging and release

The source repository contains **no** `.py`, `.sh`, `.bat`, `.ps1`, or `.exe` files. Package the 1.1.0 release using the explicit allowlist:

```sh
mkdir -p dist
git archive --format=zip --prefix=razi-more-asteroids_1.1.0/ -o dist/razi-more-asteroids_1.1.0.zip HEAD info.json LICENSE changelog.txt thumbnail.png settings.lua data.lua data-updates.lua data-final-fixes.lua asteroids.lua recipe.lua item.lua more-asteroids-spawn-definitions.lua locale graphics prototypes
```

Check the ZIP contents before uploading. Factorio 2.1 in-game load/crafting tests are still required with Space Age + RaziLib, both with and without K2SO. See `docs/RELEASE_CHECKLIST.md`. This repository has not automatically published the mod to the Mod Portal.

## Original credits

Based on [More Asteroids](https://mods.factorio.com/mod/More-Asteroids) by spartanlaser32, originally released under MIT. The upstream license is retained. [Source repository](https://github.com/Raziphel/Razi-More-Asteroids).
