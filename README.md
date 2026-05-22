# WH40K: Dawn of War DE — Traditional Chinese Locale Fix

A comprehensive font-size, rendering, and text correction mod for the Traditional
Chinese locale in **Warhammer 40,000: Dawn of War – Definitive Edition**.  
Resolves text clipping and scaling issues on high-resolution displays.

---

## Quick Start

### For End Users (1 command)

**Linux (Steam / Proton) or WSL2:**
```bash
bash deploy.sh
```

**Windows (PowerShell):**
```powershell
.\deploy.ps1
```

Both scripts auto-detect your Steam installation, create a backup, patch font
files, and deploy. To revert:

```bash
bash uninstall.sh   # Linux / WSL2
.\uninstall.ps1     # Windows
```

---

## Development Setup (Linux only)

Requires [uv](https://docs.astral.sh/uv/) and `make`.

```bash
make setup          # create .venv, install Python env
make help           # list all targets
```

### Common dev commands

| Command | What it does |
|---------|-------------|
| `make dry-run` | Preview font-fix without writing |
| `make apply` | Apply font-fix to `data/font/*.fnt` |
| `make dry-run-tc` | Preview TC text corrections |
| `make apply-tc` | Apply TC text corrections to `Engine.ucs` |
| `make deploy` | Full deploy to game installation |
| `make uninstall` | Revert deployment |
| `make restore-bak` | Restore `.fnt` files from `.bak` snapshots |

Override defaults:
```bash
make apply FONT=noto-serif-tc SIZE=36 MODE=all
make deploy --game-dir /path/to/game
```

---

## What the mod does

- **`data/font/*.fnt`** — Patches `sizeDefault` (and optionally all size keys) in
  every font configuration file to fix text clipping on high-DPI displays.
- **`Engine.ucs`** — Applies targeted Traditional Chinese text corrections
  (punctuation, typos, missing sentence endings).
- **Font switching** — Lets you choose between Noto Sans TC, Noto Serif TC, or
  Microsoft YaHei for CJK text rendering.

---

## Repository Layout

```
wh40k-dow-de-tc-mod/
├── data/
│   ├── font/          ← .fnt configs + bundled TTF/TTC fonts
│   ├── art/           ← UI/glyph flash assets
│   └── sound/         ← (placeholder; reserved for audio overrides)
├── mod/
│   ├── info.json      ← Nexus Mods metadata
│   ├── installInfo.json
│   └── modinfo.json
├── reference/
│   ├── en/Engine.en.ucs   ← English reference for i18n comparison
│   └── compare/           ← Side-by-side diff TSVs
├── scripts/
│   ├── apply_font_fix.py       ← Core font patcher (uv run)
│   ├── apply_tc_corrections.py ← TC text corrections (uv run)
│   ├── setup_relic_tool.ps1    ← Relic SGA tool installer (Windows)
│   ├── unpack_chinese_locale.ps1
│   └── repack_chinese_locale.ps1
├── Engine.ucs         ← Patched TC localization strings
├── deploy.sh          ← Linux / WSL2 deploy (1 command)
├── uninstall.sh       ← Linux / WSL2 uninstall / revert
├── deploy.ps1         ← Windows native deploy (1 command)
├── uninstall.ps1      ← Windows native uninstall / revert
├── Makefile           ← Dev workflow (uv, make)
└── pyproject.toml     ← uv project definition
```

---

## Deployment Details

### Auto-detection

Both deploy scripts detect the Steam installation automatically:

- **Linux**: scans `~/.local/share/Steam`, `~/.steam/steam`, Flatpak paths, and
  all Steam library roots found in `libraryfolders.vdf`.
- **WSL2**: additionally scans `/mnt/c`, `/mnt/d`, etc. for Windows Steam paths.
- **Windows**: reads the registry (`HKLM\SOFTWARE\Valve\Steam`), common default
  paths, and all library roots from `libraryfolders.vdf`.

Override with `--game-dir PATH` (bash) or `-GameDir PATH` (PowerShell), or set
the `DOW_GAME_DIR` environment variable.

### Backup

Every deployment creates a timestamped backup in `backup/<YYYYMMDD-HHmmss>/`
containing the overwritten files. `uninstall.sh` / `uninstall.ps1` reads the
last deploy state from `.copilot_workspace/last_deploy*.env` and uses it to
restore from the correct backup automatically.

### How the mod loads

The game's locale system checks `Engine/Locale/Chinese/data/` **before** the
packed `.sga` archive. The deploy scripts rename `EnginLoc.sga` → `EnginLoc.sga.disabled`
so the patched `data/` folder takes precedence. Uninstall renames it back.

---

## Vortex Mod Manager

The repo is Vortex-compatible. Install target path: `Engine/Locale/Chinese`.

After Vortex deploys, manually run `deploy.sh` or `deploy.ps1` once to:
1. Patch the `.fnt` files in place
2. Disable the original `EnginLoc.sga`

(Vortex handles file copying; the scripts handle the `.sga` disable step.)

---

## Font Options

```bash
make list-fonts      # show all font presets
make list-profiles   # show size profiles (1080p, 4k)

make apply FONT=noto-sans-tc   SIZE=34   # default
make apply FONT=noto-serif-tc  SIZE=36
make apply FONT=msyh           MODE=all
```

---

## Advanced: SGA Repacking (Windows only)

To repack a modified `data/` into a new `.sga` archive (optional):

1. Install SGA tools: `make setup-sga` (or `.\scripts\setup_relic_tool.ps1`)
2. Unpack: `.\scripts\unpack_chinese_locale.ps1`
3. Apply patches: `make apply`
4. Repack: `.\scripts\repack_chinese_locale.ps1`

See `FONT_FIX_README.md` for technical research notes.

---

## Platform Support

| Task | Linux | WSL2 | Windows |
|------|-------|------|---------|
| Python font patching | ✅ | ✅ | ✅ |
| TC text corrections | ✅ | ✅ | ✅ |
| Auto-deploy (`deploy.sh`) | ✅ | ✅ | — |
| Auto-deploy (`deploy.ps1`) | — | ✅ | ✅ |
| SGA unpack/repack | ❌ | ✅ | ✅ |
| `make` / uv (dev) | ✅ | ✅ | — |
