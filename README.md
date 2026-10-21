# Razi More Asteroids: K2SO Edition

A standalone Factorio 2.1 fork of [More Asteroids](https://mods.factorio.com/mod/More-Asteroids) by **spartanlaser32**, focused on **Krastorio 2: Spaced Out** and the **Razi Protocol 3.0** galaxy.

## What the first development pass includes

- Keeps six asteroid families: uranium, rock, scrap, organic, chemical and **crystalline**. Crystalline replaces the unused Petrified family with K2SO resource processing.
- Preserves hostile asteroid sizes, chunk collection and asteroid productivity research.
- Requires Factorio 2.1, Space Age and K2SO. Original More Asteroids is marked incompatible so duplicate source recipes and asteroids do not load.
- Uses automatic Factorio loading stages instead of manually importing `data-updates.lua` during `data.lua`.
- Never overwrites existing crusher fluid-box layouts. Adds support only to crushers with no fluid boxes and includes a guarded Big Crusher integration compatible with Null's K2SO Tweaks.
- Safely skips technology unlocks if research is absent or renamed. Does not introduce a second research tree.
- Adds quartz/sand and rare-metal-ore yields to crystalline chunks, plus four guarded K2SO orbital processing routes after advanced asteroid processing.
- Adds small, idempotent resource and medium-hostile asteroid populations on selected modded planets and their real space routes. Native mod resources, Imersite Asteroids and RP3's existing hostile quality escalation remain authoritative.
- All new extensions are startup-configurable; no runtime events, polling or save globals are added.

## Settings

| Startup setting | Default | Behavior |
| --- | --- | --- |
| Razi More Asteroids: Extended Routes | On | Populate a small number of RP3/K2SO planet and route entries not covered by the original |
| Razi More Asteroids: K2SO Recovery | On | Add rare-metal ore, crystalline leaching, biomass and mineral-water recipes |

## K2SO orbital processing

Crystalline replaces Petrified. Basic crushing yields 8 sand and 2 quartz per chunk. Advanced crushing uses 20 sulfuric acid for 4 quartz and a 20% chance of raw rare-metal ore.

The optional advanced-processing recipes provide:

- **Crystalline ore leaching:** 3 crystalline chunks + 75 sulfuric acid => 1 raw rare-metal ore + 4 quartz.
- **Rock rare-metal recovery:** 2 rock chunks + 30 sulfuric acid => 6 stone and 35% chance of 1 raw rare-metal ore.
- **Organic biomass:** 2 organic chunks + 5 nutrients => 3 K2SO biomass + 5 spoilage.
- **Chemical mineral water:** 2 chemical chunks + 50 water => 30 mineral water + 2 sulfur.

These inputs preserve K2SO's refining loop and intentionally do not grant endgame imersite or free science. Recipes are only registered when their inputs and outputs exist. Sand output follows K2SO and Null's Tweaks aliases (`kr-sand` or `sand`) independently of the optional recovery setting.

Changing from Petrified prototypes to Crystalline prototypes removes the former IDs. Back up existing saves before trying this development fork.

## Integration boundaries

**Do not bundle or depend on Quality Asteroids / Quality Asteroids Expanded.** Razi Protocol 3.0 already provides a native 10-stage quality scaling system that recognizes real hostile asteroid prototypes. No additional quality carriers or child asteroid multiplication are introduced here.

This fork **does not** grant legendary-quality collectible chunks or free imersite science; resources must still be processed using proper recipes. Other authors' asteroid spawn records are not replaced. The extra planet populations deliberately remain small.

The original source was released for Factorio 2.0; this development branch targets 2.1 but **full engine and entire RP3 modpack loading still require validation**. Not yet a published Mod Portal release.

## Resource-matched asteroid artwork

All 72 active asteroid sprites and corresponding icons are **regraded original artwork**, not newly generated models. The shapes, shadow profiles, transparent silhouettes, resolution and animation frame layouts are preserved.

- Rock: cool stony grays with restrained tungsten-colored mineral inclusions
- Uranium: dark mineral faces and radioactive green highlights
- Scrap: weathered gunmetal and oxidized industrial rust
- Organic: muted fungal olive and biomass browns
- Chemical: aqueous turquoise, ammonia/fluorine greens and pale mineral deposits
- Crystalline: bright frosted quartz, sand-white highlights and cool blue mineral faces

To reproduce the art pass on an unchanged source tree: `python3 tools/retouch_asteroid_graphics.py --apply`. Re-running on already retouched PNGs safely does nothing. Use `python3 tools/test_asteroid_art.py` to verify that alpha masks and dimensions match the repository's current baseline. Graphics processing uses Python's standard library; build tools are excluded from the mod ZIP.

## Build / installation

This repository contains the full standalone mod source and upstream graphics. Its `info.json` name is `razi-more-asteroids`.

Package into a ZIP whose root folder is named `razi-more-asteroids_0.5.0`; place the ZIP in the Factorio mods folder alongside K2SO. Do not enable the original More Asteroids mod simultaneously. Back up saves before switching.

RP3 should declare the new mod as a hard dependency **after the fork is published and verified**. The fork deliberately does not depend on RP3, avoiding circular dependencies.

## Credits and license

Based on **More Asteroids** by [spartanlaser32](https://github.com/spartanlaser32/More-Asteroids), licensed under MIT on the Factorio Mod Portal. Upstream asteroid assets and original source concepts are preserved. Modifications and K2SO/RP3 support are by Razi's Realm.

This fork includes the MIT permission notice, and retains attribution to the original author.
