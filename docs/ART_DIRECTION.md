# Asteroid material art direction

Artwork is based on the existing More Asteroids sprites. Retain the original
transparent silhouettes, resolution, shading normal maps and game-art style.
Do not replace these source assets with generated concept art. Material hues
must remain readable in 64×64 item icons and on full-size space-platform sprites.

| In-game identity | Internal ID | What it gives | Art cues |
| --- | --- | --- | --- |
| Radioactive | uranium | Uranium ore / isotopes | Blackened rock; localized yellow-green uranium deposits |
| Lithic | rock | Stone / calcite | Coarse grey stone with warm pale calcite inclusions |
| Wreckage | scrap | Scrap / K2SO components | Oxidized rusty surfaces, scratched gunmetal plates |
| Biogenic | organic | Spoilage / Gleba organics / K2SO biomass | Dark fungal moss, mottled olive tissue, muted spores |
| Volatile | chemical | Ammonia / K2SO hydrogen and oxygen | Cool aqua ice-gas pockets, translucent green-cyan inclusions |
| Dense-Metal | crystalline | Tungsten / K2SO rare-metal ore | Dense charcoal-steel, exposed silvery metal seams |
| Halide | halide | Fluorine / lithium brine / K2SO mineral water | Salt-white crystal edges over pale violet mineral surfaces |
| Electrostatic | electrostatic | Holmium ore / K2SO silicon | Dark indigo mineral rock with restrained turquoise conductor veins |

Resource recognition comes from **surface inclusions and material contrast**,
not just a flat color filter. Space Age's normal/roughness maps provide familiar
lighting and silhouettes. Each family has its own modest light/specular
profile in `asteroids.lua`.

Update every family's five world sprites (chunk through huge) and seven UI icons
together, retaining identical dimensions and alpha masks. The existing names
`rock`, `chemical`, and `crystalline` deliberately remain in prototypes to
avoid breaking existing saves; only displayed identities have changed.

K2SO makes additional outputs available but does not change what the asteroid
is made of. Do not paint K2SO-only materials on a Space Age-only asteroid that
cannot give them without K2SO. Do not introduce executable scripts into this mod
repository or its Mod Portal archives.

**Verification:** compare all 96 assets to their committed predecessor and
confirm 40 world-sprite dimensions/silhouettes and 56 icon alpha masks.
Factorio's in-game renderer must still be inspected before publishing.


## Final 1.1.0 visual polish

- **Icons first:** All 56 existing UI textures receive a controlled highlight/
  shadow clarity pass with more visible ore inclusions. They stay at 64×64.
- **World sprites:** All 40 source asteroid textures receive the same treatment
  at their native dimensions, with subtler highlights than the icons.
- **Lighting:** Rock and Biogenic surfaces are less glossy; Dense-Metal,
  Wreckage and Electrostatic preserve more pronounced normal-map relief.
- **Material separation:** Uranium has lime mineral specks; Lithic has muted
  calcite; Dense-Metal has steel-white inclusions; Wreckage retains rust with
  exposed metal; Biogenic retains muted fungal mottling; Volatile keeps aqua
  chemical pools; Halide retains lavender-white mineral crusts; Electrostatic
  retains a deep-blue body with teal conductive inclusions.
- **Constraints:** No new shapes, no new texture bases, no procedural glow,
  no dimensions or alpha changes, and no gameplay/recipe alterations.
