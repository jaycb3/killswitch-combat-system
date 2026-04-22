# Killswitch — Achaea (Mudlet) combat system

GMCP-first curing and offence scaffolding for **Achaea** on **Mudlet**.

## Install (recommended): `.mpackage` from the command line

1. **Build** the package (requires `zip`):

   ```bash
   ./scripts/build-mpackage.sh
   ```

   This writes `dist/killswitch-0.1.0.mpackage` (a ZIP with `config.lua`, `killswitch.xml`, and `src/`).

2. In Mudlet, open your Achaea profile and paste **one** line in the command line (adjust the path):

   **macOS / Linux**

   ```lua
   lua installPackage([[/full/path/to/killswitch/dist/killswitch-0.1.0.mpackage]])
   ```

   **Windows** (forward slashes work in Lua):

   ```lua
   lua installPackage([[C:/Users/You/path/to/killswitch/dist/killswitch-0.1.0.mpackage]])
   ```

3. Enable **GMCP** for the profile (Settings → Special Options).

4. **Uninstall** (if needed):

   ```lua
   lua uninstallPackage("killswitch")
   ```

The installer extracts Lua sources under `getMudletHomeDir()/killswitch/` (same layout as a manual clone).

## Install (manual): clone into Mudlet home

1. Clone or copy this repo so you have `getMudletHomeDir()/killswitch/src/...`.
2. In Mudlet, run:

   ```lua
   assert(loadfile(getMudletHomeDir() .. "/killswitch/src/killswitch_loader.lua"))()
   ```

3. Enable **GMCP** for your Achaea profile.

4. Optional: use the aliases from `killswitch.xml` (`atk`, `unatk`, `ksaffs`, `ksdefs`) if you imported that XML separately.

## Layout

- `src/core/` — `ks` namespace, GMCP bridge, vitals, action queue
- `src/curing/` — `ks.dict` (affliction/defence/helper/meta), priorities, curing loop, keepup
- `src/offense/` — locks, target, limb counter, offence controller, class modules
- `src/ui/` — HUD echo + alias helpers

## Licence

Combat commands are **placeholders** — replace with your class’s real abilities. Use at your own risk; automation may conflict with game rules.

## Reference

Based on the [svof](https://github.com/svof/svof) dict structure and IRE GMCP (`Char.Vitals`, `Char.Afflictions`, `Char.Defences`, `IRE.Target`, `IRE.Rift`, `Room`).
# killswitch-combat-system
