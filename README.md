# WH40K: Dawn of War DE - Traditional Chinese Locale Font Fix

> A comprehensive font-size and rendering fix utility for the Traditional Chinese locale in Warhammer 40,000: Dawn of War - Definitive Edition. Resolves text clipping and scaling issues in high-resolution UI elements.

## Overview

This mod provides automated scripting to:
- **Unpack** the Chinese locale `.sga` archive
- **Patch** font configuration files (`.fnt`) to fix text clipping and scaling
- **Replace** Chinese fonts with Microsoft YaHei for improved rendering (optional)
- **Repack** the locale archive (optional)

The fix is especially critical for **4K and high-resolution displays** where default font sizes cause text to overflow UI elements.

## Features

- ✅ Anti-clipping fallback profile (safer, default)
- ✅ Full scaling profile for stronger visible improvements
- ✅ Microsoft YaHei font replacement option
- ✅ Automated backup and restoration
- ✅ Dry-run mode for preview before applying
- ✅ PowerShell and Python-based (cross-platform compatible)

## Installation

### Prerequisites
- **Windows 10+** (PowerShell 5.0+) or **WSL 2** on other platforms
- **Python 3.8+** (will be auto-installed in isolated venv)
- **Dawn of War - Definitive Edition** (Steam)
- Administrator privileges recommended

### Setup

1. **Extract this mod to the locale folder:**
   ```
   %STEAM%\steamapps\common\Dawn of War Definitive Edition\Engine\Locale\Chinese
   ```

2. **Install dependencies (one-time):**
   ```powershell
   .\setup_relic_tool.ps1
   ```
   This creates a local Python virtual environment and installs `relic-tool-sga` for archive manipulation.

## Quick Start

### Option A: No-Repack Method (Recommended)

1. **Unpack the locale:**
   ```powershell
   .\unpack_chinese_locale.ps1
   ```
   - Backs up original `.sga` to `backup/`
   - Extracts contents to `data/`

2. **Preview the fix (dry-run):**
   ```powershell
   .\.venv-relic\Scripts\python.exe apply_font_fix.py --dry-run --restore-from-bak --mode fallback-only --size 34
   ```

3. **Apply the fix:**
   ```powershell
   .\.venv-relic\Scripts\python.exe apply_font_fix.py --restore-from-bak --mode fallback-only --size 34
   ```

4. **Remove the original `.sga`** (game loads unpacked `data/` folder instead):
   ```powershell
   Remove-Item EnginLoc.sga -Force  # or rename to .bak
   ```

5. **Test in-game** — launch Dawn of War DE and check Chinese text rendering.

### Option B: Full Repack (Advanced)

If you want to create a new `.sga` archive:

```powershell
.\repack_chinese_locale.ps1
```

Output: `EnginLoc.new.sga` (replace original or test as mod override)

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
   Copy-Item "C:\Windows\Fonts\msyh.ttc" ".\data\font\msyh.ttc" -Force
   Copy-Item "C:\Windows\Fonts\msyhbd.ttc" ".\data\font\msyhbd.ttc" -Force
   ```

2. **Apply fix with font replacement:**
   ```powershell
   .\.venv-relic\Scripts\python.exe apply_font_fix.py `
     --restore-from-bak `
     --mode all `
     --size 32 `
     --replace-font-file msyh.ttc `
     --replace-font-match "NotoSansTC|Gulim"
   ```

## Script Reference

| Script | Purpose |
|--------|---------|
| `setup_relic_tool.ps1` | Create venv and install MAK Relic SGA tools |
| `unpack_chinese_locale.ps1` | Unpack `.sga` → `data/` with auto-backup |
| `apply_font_fix.py` | Patch `.fnt` files; supports dry-run, restore, replace |
| `repack_chinese_locale.ps1` | Repack `data/` → new `.sga` archive |

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

This mod is **Vortex-ready**. To install:

1. **Download** from Nexus Mods: [WH40K DOW DE Chinese Locale Font Fix](https://www.nexusmods.com/warhammer40kdawnofwar/mods/[MOD_ID])
2. **Install via Vortex:**
   - Click "Install" in Vortex
   - Deploy to your DoW:DE installation
3. **Activate** the mod in Vortex's mod list

**Important:** After installing via Vortex, **run `setup_relic_tool.ps1`** once (if not already done) to install SGA tools, then use the scripts as normal.

### Mod Metadata

- **Mod Type:** Utility/Fix
- **Category:** Localization
- **Load Order:** N/A (no loadable assets—unpacking/patching happens offline)
- **Conflicts:** None known
- **Requirements:** Python 3.8+, relic-tool-sga, relic-tool-sga-v2

## File Structure

```
wh40k-dow-de-tc-mod/
├── setup_relic_tool.ps1           # Install tooling
├── unpack_chinese_locale.ps1      # Unpack .sga
├── apply_font_fix.py              # Font patching logic
├── repack_chinese_locale.ps1      # Repack to .sga
├── FONT_FIX_README.md             # Original technical doc
├── Engine.ucs                     # Resource file (not modified)
├── EnginLoc.sga0                  # Original backup (reference)
├── .gitignore
├── README.md
├── modinfo.json                   # Vortex metadata
├── info.json                      # Nexus Mods metadata
└── data/
    ├── art/ui/swf/                # Font glyph assets (UI references)
    ├── font/
    │   ├── *.fnt                  # Font config files (to be patched)
    │   └── *.ttc                  # Font files (TrueType collections)
    └── sound/
```

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
