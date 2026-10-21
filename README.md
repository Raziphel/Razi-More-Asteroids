# Razi More Asteroids: K2SO Edition

A standalone Factorio 2.1 fork of [More Asteroids](https://mods.factorio.com/mod/More-Asteroids) by **spartanlaser32**, focused on **Krastorio 2: Spaced Out** and the **Razi Protocol 3.0** galaxy.

## What the first development pass includes

- Preserves the six original asteroid families, complete with the upstream sprites and original material-processing recipes: uranium, rock, scrap, organic, petrified and chemical.
- Preserves hostile asteroid sizes, chunk collection and asteroid productivity research.
- Requires Factorio 2.1, Space Age and K2SO. Original More Asteroids is marked incompatible so duplicate source recipes and asteroids do not load.
- Uses automatic Factorio loading stages instead of manually importing `data-updates.lua` during `data.lua`.
- Never overwrites existing crusher fluid-box layouts. Adds support only to crushers with no fluid boxes and includes a guarded Big Crusher integration compatible with Null's K2SO Tweaks.
- Safely skips technology unlocks if research is absent or renamed. Does not introduce a second research tree.
- Adds one deliberately modest K2SO rare-metal recovery option from rock asteroid chunks after advanced asteroid processing, while keeping the original recipes.
- Adds small, idempotent resource and medium-hostile asteroid populations on selected modded planets and their real space routes. Native mod resources, Imersite Asteroids and RP3's existing hostile quality escalation remain authoritative.
- All new extensions are startup-configurable; no runtime events, polling or save globals are added.

## Settings

| Startup setting | Default | Behavior |
| --- | --- | --- |
| Razi More Asteroids: Extended Routes | On | Populate a small number of RP3/K2SO planet and route entries not covered by the original |
| Razi More Asteroids: K2SO Recovery | On | Unlock a moderate rare-metal recovery recipe from rock chunks |

## Integration boundaries

**Do not bundle or depend on Quality Asteroids / Quality Asteroids Expanded.** Razi Protocol 3.0 already provides a native 10-stage quality scaling system that recognizes real hostile asteroid prototypes. No additional quality carriers or child asteroid multiplication are introduced here.

This fork **does not** grant legendary-quality collectible chunks or free imersite science; resources must still be processed using proper recipes. Other authors' asteroid spawn records are not replaced. The extra planet populations deliberately remain small.

The original source was released for Factorio 2.0; this development branch targets 2.1 but **full engine and entire RP3 modpack loading still require validation**. Not yet a published Mod Portal release.

## Build / installation

This repository contains the full standalone mod source and upstream graphics. Its `info.json` name is `razi-more-asteroids`.

Package into a ZIP whose root folder is named `razi-more-asteroids_0.5.0`; place the ZIP in the Factorio mods folder alongside K2SO. Do not enable the original More Asteroids mod simultaneously. Back up saves before switching.

RP3 should declare the new mod as a hard dependency **after the fork is published and verified**. The fork deliberately does not depend on RP3, avoiding circular dependencies.

## Credits and license

Based on **More Asteroids** by [spartanlaser32](https://github.com/spartanlaser32/More-Asteroids), licensed under MIT on the Factorio Mod Portal. Upstream asteroid assets and original source concepts are preserved. Modifications and K2SO/RP3 support are by Razi's Realm.

This fork includes the MIT permission notice, and retains attribution to the original author.
