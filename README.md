# WH40K: Dawn of War DE — Traditional Chinese Locale Fix

A comprehensive font-size, rendering, and text correction mod for the Traditional
Chinese locale in **Warhammer 40,000: Dawn of War – Definitive Edition**.  
Resolves text clipping and scaling issues on high-resolution displays.

> **Download:** [Releases](https://github.com/shc261392/wh40k-dow-de-tc-mod/releases/latest) — grab `wh40k-dow-de-tc-mod-v*.zip` (mod) and `vortex-ext-*.zip` (Vortex extension).

---

## Installing the Mod

### Option A — Vortex Mod Manager (recommended)

1. **Install the game extension** — drag `vortex-ext-game-warhammer40kdawnofwar-v*.zip` onto the Vortex **Extensions** tab and click *Enable*.  
   *(Only needed once. This lets Vortex recognise DoW DE as a managed game.)*

2. **Add the mod** — drag `wh40k-dow-de-tc-mod-v*.zip` onto Vortex.

3. **Deploy** — click *Deploy Mods* in Vortex.  
   Vortex automatically renames `EnginLoc.sga` → `EnginLoc.sga.disabled` so the patched files take priority.

4. **Launch the game.** Chinese text should now render correctly.

To uninstall: click *Purge Mods* in Vortex. The original `EnginLoc.sga` is restored automatically.

---

### Option B — Manual install (Windows)

1. Extract `wh40k-dow-de-tc-mod-v*.zip` into your game's locale directory:
   ```
   <Steam>\steamapps\common\Dawn of War Definitive Edition\Engine\Locale\Chinese\
   ```
   After extraction you should have `data\font\`, `data\art\`, `data\sound\`, and `Engine.ucs` there.

2. Rename the original archive so the loose files take priority:
   ```
   EnginLoc.sga  →  EnginLoc.sga.disabled
   ```

3. Launch the game.

To uninstall: delete the extracted `data\` folder and `Engine.ucs`, then rename `EnginLoc.sga.disabled` back to `EnginLoc.sga`.

---

### Option C — Script install (Linux / WSL2 / Windows native)

Clone or download the repo, then run one command from the repo root:

**Linux / WSL2:**
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

See **[Option A — Vortex install](#option-a--vortex-mod-manager-recommended)** above for the full walkthrough.

The repo ships a Vortex game extension (`vortex-ext/game-warhammer40kdawnofwar/`) that:
- Registers DoW DE (Steam App 3556750) as a Vortex-managed game
- Sets the correct install path (`Engine/Locale/Chinese/`)
- Automatically disables `EnginLoc.sga` on deploy and re-enables it on purge

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

---

## Known Issues / Troubleshooting

### Tutorial prompt appears after first deploy

**Symptom:** After running `deploy.sh` / `deploy.ps1` for the first time, the
game shows the "Do you want to play the tutorial?" prompt when clicking Campaign.

**Cause:** The game's locale-change detection reads
`Profiles/Profile1/playercfg.lua` and may reset
`Tutorial_DoWDE.HasClickedCampaign` to `false` when it detects modified locale
files. This is game-internal behaviour; no script in this mod writes to
`playercfg.lua`.

**Fix:** Simply dismiss the tutorial prompt — the flag is set back to `true`
immediately. The prompt will not appear again on subsequent launches with the
same locale files.

---

### "緝" character appended to WA campaign subtitles

**Symptom:** Voiced dialogue subtitles in the Winter Assault campaign show an
extra character (緝, U+7DC9) at the end of each line.

**Root cause (investigated and fixed):** `notosanstc-bold.ttf` has a glyph
mapped at codepoint U+0000 (the null terminator). DoW's subtitle renderer reads
the string including the null terminator and renders the font's glyph for that
codepoint. Because `gillsans_11b.fnt` (the dialogue subtitle font) previously
referenced `notosanstc-bold.ttf`, every subtitle ended with 緝.

**Fix applied (commit `7055d8b`):** `gillsans_11b.fnt` and `gillsans_bold_16.fnt`
now reference `notosanstc-medium.ttf`, which does not have a visible glyph at
U+0000. The artifact is gone.

If future font experiments re-introduce this file, avoid `notosanstc-bold.ttf`
for any font definition that is used to render subtitle or in-game dialogue text.
