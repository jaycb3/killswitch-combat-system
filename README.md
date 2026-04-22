# Killswitch — Achaea (Mudlet) combat system

GMCP-first curing and offence scaffolding for **Achaea** on **Mudlet**.

## Install (recommended): `.mpackage` from the command line

1. **Build** the package (requires `zip`, usually preinstalled on macOS):

   From the **repository root** (`killswitch/`), run **bash** explicitly:

   ```bash
   bash scripts/build-mpackage.sh
   ```

   You should see lines starting with `==>` and a `dist/killswitch-0.1.0.mpackage` file when it finishes.

   **If nothing prints or the script exits immediately:** do not use `sh scripts/...` — use `bash` as above. If `./scripts/build-mpackage.sh` says “Permission denied”, run `chmod +x scripts/build-mpackage.sh` once, or keep using `bash scripts/build-mpackage.sh`.

   This writes `dist/killswitch-0.1.0.mpackage` (a ZIP with `config.lua`, `killswitch.xml`, and `src/`).

   **Windows:** CMD and PowerShell do not run `.sh` files by themselves. From the repo root, either:

   - **`scripts\build-mpackage.bat`** — uses Git Bash + `zip` if installed, otherwise PowerShell’s `Compress-Archive`.
   - Or in PowerShell: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\build-mpackage.ps1`

   To use the bash script on Windows, install [Git for Windows](https://git-scm.com/download/win), open **Git Bash**, `cd` to the repo, then run `bash scripts/build-mpackage.sh` (needs `zip` on your `PATH`; Git Bash often includes it).

   **No shell?** From the repo root you can run:

   ```bash
   mkdir -p dist && rm -f dist/killswitch-0.1.0.mpackage && zip -r dist/killswitch-0.1.0.mpackage config.lua killswitch.xml README.md src
   ```

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
