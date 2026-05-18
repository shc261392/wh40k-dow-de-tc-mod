# WH40K: Dawn of War DE - Traditional Chinese Locale Font Fix

> A comprehensive font-size and rendering fix utility for the Traditional Chinese locale in Warhammer 40,000: Dawn of War - Definitive Edition. Resolves text clipping and scaling issues in high-resolution UI elements.

## Overview

This repository contains:

- **Game Files** (`data/`, `Engine.ucs`, `EnginLoc.sga0`): Ready-to-deploy mod content
- **Development Tools** (`scripts/` folder): Utilities for unpacking `.sga` archives, patching `.fnt` files, and repacking
- **Metadata** (`mod/` folder): Vortex and Nexus Mods configuration

The fix is especially critical for **4K and high-resolution displays** where default font sizes cause text to overflow UI elements.

### For End Users (Playing)

- Extract the **entire folder** to `Engine/Locale/Chinese` in your DoW:DE installation
- The game will load `data/` automatically
- Remove or rename the original `EnginLoc.sga` to disable the old archive
- No scripts needed—it's a drop-in mod

### For Developers (Customizing)

- Use the `scripts/` folder to unpack, patch, and repack the locale archive
- Requires Python 3.8+ and the MAK Relic SGA tools

## Features

- ✅ Anti-clipping fallback profile (safer, default)
- ✅ Full scaling profile for stronger visible improvements
- ✅ Microsoft YaHei font replacement option
- ✅ Automated backup and restoration
- ✅ Dry-run mode for preview before applying
- ✅ PowerShell and Python-based (cross-platform compatible)

## Installation

### For Players (End-User Installation)

**Prerequisites:**
- You already have `Engine.ucs` and `EnginLoc.sga` in `Engine/Locale/Chinese/` (from your DoW:DE installation)

**Installation Steps:**

1. **Download/extract this mod to `Engine/Locale/Chinese/`:**
   ```
   Extract repo contents to: %STEAM%\steamapps\common\Dawn of War Definitive Edition\Engine\Locale\Chinese\
   
   This adds: data/, scripts/, mod/ folders and documentation
   ```

2. **Remove or rename the original `EnginLoc.sga` file:**
   ```powershell
   Rename-Item EnginLoc.sga EnginLoc.sga.old
   ```
   This ensures the game loads the patched `data/` folder instead of the original archive.

3. **Launch Dawn of War: Definitive Edition** — Chinese text displays with corrected font sizing ✅

**Using Vortex Mod Manager:**
- Let Vortex download and deploy the mod to `Engine/Locale/Chinese/`
- Then manually rename the original `EnginLoc.sga` to `EnginLoc.sga.old`
- Activate the mod in Vortex

### For Developers (Customizing the Fix)

#### Prerequisites

- **Windows 10+** (PowerShell 5.0+) or **WSL 2** on other platforms
- **Python 3.8+** (will be auto-installed in isolated venv)
- **Dawn of War - Definitive Edition** (Steam)
- Administrator privileges recommended

#### Initial Setup

1. **Install dependencies (one-time):**

   ```powershell
   .\scripts\setup_relic_tool.ps1
   ```

   This creates a local Python virtual environment and installs `relic-tool-sga` for archive manipulation.

## Quick Start (Developers)

### Option A: No-Repack Method (Recommended)

1. **Unpack the locale:**

   ```powershell
   .\scripts\unpack_chinese_locale.ps1
   ```

   - Backs up original `.sga` to `backup/`
   - Extracts contents to a temporary location

2. **Preview the fix (dry-run):**

   ```powershell
   .\.venv-relic\Scripts\python.exe scripts\apply_font_fix.py --dry-run --restore-from-bak --mode fallback-only --size 34
   ```

3. **Apply the fix:**

   ```powershell
   .\.venv-relic\Scripts\python.exe scripts\apply_font_fix.py --restore-from-bak --mode fallback-only --size 34
   ```

4. **Remove the original `.sga`** (game loads unpacked folder instead):

   ```powershell
   Remove-Item EnginLoc.sga -Force
   ```

5. **Test in-game** — launch Dawn of War DE and verify Chinese text rendering.

### Option B: Full Repack (Advanced)

If you want to create a new `.sga` archive:

```powershell
.\scripts\repack_chinese_locale.ps1
```

Output: `EnginLoc.new.sga` (can replace original or test as mod override)

## Font Size Tuning

If text still appears too small or clips:

- **Smaller:** `--size 30` or `--size 32`
- **Default:** `--size 34` (recommended baseline)
- **Larger:** `--size 36` or `--size 38`

Try incrementally and preview with `--dry-run` first.

## Advanced: Microsoft YaHei Font Replacement

To replace Noto Sans TC and Gulim fonts with Microsoft YaHei (mainland-standard Chinese font):

1. **Pre-install YaHei fonts** (usually already on Windows):

   ```powershell
   Copy-Item "C:\Windows\Fonts\msyh.ttc" "./data/font/msyh.ttc" -Force
   Copy-Item "C:\Windows\Fonts\msyhbd.ttc" "./data/font/msyhbd.ttc" -Force
   ```

2. **Apply fix with font replacement:**

   ```powershell
   .\.venv-relic\Scripts\python.exe scripts\apply_font_fix.py `
     --restore-from-bak `
     --mode all `
     --size 32 `
     --replace-font-file msyh.ttc `
     --replace-font-match "NotoSansTC|Gulim"
   ```

## Script Reference (Development Tools)

All scripts are in the `scripts/` folder:

| Script | Purpose |
|--------|----------|
| `scripts/setup_relic_tool.ps1` | Create venv and install MAK Relic SGA tools |
| `scripts/unpack_chinese_locale.ps1` | Unpack `.sga` archive with auto-backup |
| `scripts/apply_font_fix.py` | Patch `.fnt` files; supports dry-run, restore, replace |
| `scripts/repack_chinese_locale.ps1` | Repack modified data into new `.sga` archive |

### `apply_font_fix.py` Options

```
--dry-run                    Preview changes without writing
--restore-from-bak           Restore .bak before patching (default: True)
--mode {fallback-only|all}   fallback-only = sizeDefault only (safer)
                             all = all size* keys (stronger effect)
--size SIZE                  Font size value to apply (default: 34)
--replace-font-file FILE     Replace font file references (e.g., msyh.ttc)
--replace-font-match REGEX   Regex to match font names to replace (e.g., "NotoSansTC|Gulim")
```

## Vortex Mod Manager Support

This mod is **Vortex-ready**. The repository can be packaged for Nexus Mods.

### For Players Installing via Vortex

1. **Download** from Nexus Mods: [WH40K DOW DE Chinese Locale Font Fix](https://www.nexusmods.com/warhammer40kdawnofwar/mods/[MOD_ID])
2. **Install via Vortex:**
   - Click "Install" in Vortex
   - Deploy to your DoW:DE installation
3. **Post-deployment (important):**
   - Navigate to `Engine/Locale/Chinese/`
   - Rename or remove `EnginLoc.sga` to `EnginLoc.sga.old`
   - Game will now load the patched `data/` folder
4. **Activate** the mod in Vortex's mod list
5. Launch the game!

**Note:** The mod is a folder overlay; it doesn't replace the original `.sga` file. You must manually disable the `.sga` for the patched data to be used.

### For Developers

The `mod/` folder metadata is Vortex-compatible:

- `modinfo.json` — Vortex mod configuration
- `installInfo.json` — Vortex installer instructions
- `info.json` — Nexus Mods metadata

### Mod Metadata

- **Mod Type:** Utility/Fix
- **Category:** Localization
- **Load Order:** N/A (no loadable assets—unpacking/patching happens offline)
- **Conflicts:** None known
- **Requirements:** Python 3.8+, relic-tool-sga, relic-tool-sga-v2

## File Structure

```
wh40k-dow-de-tc-mod/                  (Git repository)
├── data/                              # PATCHED game locale files (included in repo)
│   ├── art/ui/swf/                    # Font glyph assets
│   ├── font/
│   │   ├── *.fnt                      # Patched font config files
│   │   ├── *.ttc                      # Font files (TrueType collections)
│   │   └── *.ttf                      # Font files (TrueType)
│   └── sound/
│
├── scripts/                           # Development tools (included in repo)
│   ├── setup_relic_tool.ps1           
│   ├── unpack_chinese_locale.ps1      
│   ├── apply_font_fix.py              
│   └── repack_chinese_locale.ps1      
│
├── mod/                               # Vortex metadata (included in repo)
│   ├── modinfo.json                   
│   ├── info.json                      
│   └── installInfo.json               
│
├── .gitignore                         
├── README.md                          
└── FONT_FIX_README.md                 

Engine/Locale/Chinese/ (Deployment directory - local only, not in repo)
├── Engine.ucs                         # Original game file (from DoW:DE install)
├── EnginLoc.sga                       # Original .sga (from DoW:DE install)
├── data/                              # Extracted from repo
├── scripts/                           # Extracted from repo
├── mod/                               # Extracted from repo
└── backup/                            # Local backups (git-ignored)
```

### What's in the Git Repository

Only the **minimal changes needed for deployment**:
- ✅ `data/` — Patched font configuration and UI files
- ✅ `scripts/` — Development/customization tools
- ✅ `mod/` — Vortex and Nexus Mods metadata
- ✅ Documentation and config files

### What's NOT in Git

- ❌ `Engine.ucs` — Original game file (already in your DoW:DE installation)
- ❌ `EnginLoc.sga` — Original game archive (already in your DoW:DE installation)
- ❌ `backup/` — Local backups (git-ignored)

## Troubleshooting

### Issue: "Cannot find relic.exe"

**Solution:** Run `.\setup_relic_tool.ps1` first to install tools.

### Issue: "No .sga file found"

**Solution:** Ensure you're in the correct locale folder and the `.sga` hasn't been renamed or moved.

### Issue: Text still clips after patching

**Solutions:**

- Try `--size 32` or `--size 30` (smaller value)
- Use `--mode all` instead of `fallback-only`
- Check if you need to remove the original `.sga` (game loads unpacked `data/` folder instead)

### Issue: Font replacement didn't work

**Ensure:**

- YaHei fonts exist in `data/font/` (check with `dir data\font\msyh.ttc`)
- Regex pattern matches existing font names in `.fnt` files
- File names in `.fnt` entries use correct case/spelling

## Notes

- **Backups:** Every `.fnt` file gets a `.bak` backup before patching. The unpacked `.sga` also gets backed up in `backup/`.
- **Syntax Support:** `.fnt` files with unknown syntax are skipped and reported; common formats (INI-style key=value) are supported.
- **Patch Modes:**
  - `fallback-only` (default): Changes only `sizeDefault` — safest, minimal clipping risk
  - `all`: Changes all `size*` keys — stronger visual effect, higher clipping risk if size too high
- **No Repack Recommended:** The game can load unpacked folders directly from the locale folder, avoiding the need to repack. This is faster for iteration and testing.

## Compatibility

| Game Version | Status |
|---|---|
| DoW:DE v2.02.0+ | ✅ Tested |
| Steam (all platforms) | ✅ Verified |
| Epic Games Store | ⚠️ Untested |

## Contributing

Found a bug or have a suggestion? Please open an issue on the mod's GitHub repository.

## License

This mod is provided **as-is** for the WH40K modding community. Redistribution and modification are allowed with attribution.

---

**Last Updated:** 2026-05-18  
**Version:** 1.0.0  
**Mod Database:** Nexus Mods ID: [TBD]  
**GitHub:** [github.com/[USER]/wh40k-dow-de-tc-mod](https://github.com/[USER]/wh40k-dow-de-tc-mod)
