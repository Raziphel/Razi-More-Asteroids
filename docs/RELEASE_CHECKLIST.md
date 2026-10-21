# First-public-release verification

Candidate ZIP: `dist/razi-more-asteroids_1.0.1.zip`
Status: **package-ready, engine validation pending**. Do not claim a completed in-game test until performed.

## Packaging gate

Build with the `git archive` command in README.md, using only the explicitly listed Factorio files. Check the ZIP root is `razi-more-asteroids_1.0.1/` and that `unzip -l` shows no `.exe`, `.bat`, `.ps1`, `.sh`, or `.py` entries. Developer scripts are maintained outside this mod repository. This packaging check is not an in-game test.

## Required manual startup tests

- [ ] Confirm **razi_lib >= 1.3.1** is installed and Factorio recognizes it as a required dependency.

- [ ] Factorio **2.1.20+ with Space Age and RaziLib only**, clean mod configuration: reaches main menu with no prototype errors.
- [ ] New Space Age game: Nauvis and vanilla space routes display additional asteroid populations, no duplicate/prototype errors.
- [ ] Space Age crystalline basic/advanced crushing uses only vanilla items and fluids; processing works in a fluid-equipped crusher.
- [ ] Repeat loading and crafting with **Krastorio2-spaced-out 2.0.17+** installed alongside RaziLib.
- [ ] Confirm all **eight** optional K2SO orbital recipes appear after Advanced Asteroid Processing and have functional ingredients, inputs and outputs.
- [ ] K2SO ground crusher handles dry recipes. **Wet recipes must not appear** in dry-only K2SO machine selections.
- [ ] Inspect a physical space platform's crusher fluid inputs and outputs (including uranium, chemicals, and extra K2SO recipes).
- [ ] Test optional **K2SO Recovery = Off**: specialty recipes absent; crystalline quartz outputs still work.
- [ ] Test **Space Age routes = Off**: family prototypes still exist; extra location/route populations do not.
- [ ] Optional: load with Null's K2SO Tweaks and Any Planet Start, if installed, and check that nothing resets their fields.
- [ ] Inspect 64px recipe/chunk icons and 144px thumbnail in-game; check all six asteroid families for missing graphics.
- [ ] Verify a saved game can be reopened; back up any existing save with retired Petrified prototype IDs.
- [ ] Validate science progression and reasonable availability without unlocking high-tier resources too early.

## Publication procedure

1. Complete the packaging gate and manual tests above.
2. If a prototype, crafting or sprite issue appears, fix it and **bump the patch version** before uploading.
3. Open [Factorio Mod Portal](https://mods.factorio.com/), create the new mod using the prepared ZIP, and copy the text from `docs/MOD_PORTAL.md`.
4. Set the license to **MIT**, link the repository, and use the existing 144px thumbnail.
5. Add screenshots captured **from Factorio** with the new asteroid types and representative processing recipes. Do not substitute generated concept art for in-game screenshots.
6. Publish only after the checks pass, then verify the mod listing and downloaded ZIP.

## Deliberate integration boundary

RP3 owns its custom planet routes, quality escalation, difficulty presets and journal entries. None of these are release requirements or should be built into this standalone mod.
