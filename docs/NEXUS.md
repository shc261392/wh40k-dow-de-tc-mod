# Nexus Mods Publishing Guide

This document contains everything needed to publish this mod on Nexus Mods.  
Copy each section into the corresponding Nexus Mods field.

---

## 1 — Upload the Mod File

### What to upload

| File | Where to get it |
|------|----------------|
| `wh40k-dow-de-tc-mod-v1.0.0.zip` | Run `make package` → `.copilot_workspace/dist/` |

**Do NOT upload the Vortex extension zip to Nexus** — that goes separately (see Section 2).

### Steps

1. Go to <https://www.nexusmods.com/warhammerdawnofwardefinitiveedition>
2. Log in → click **Upload a mod**
3. Fill in the fields using the content below
4. Under **Files**, click **Add file** → upload `wh40k-dow-de-tc-mod-v1.0.0.zip`
   - File name: `wh40k-dow-de-tc-mod-v1.0.0`
   - Version: `1.0.0`
   - Description: `Main mod archive — font fix, art, sound, Engine.ucs`
5. Publish the mod
6. Note the mod ID from the URL (e.g. `.../mods/42` → ID is `42`)
7. Update `mod/info.json` with the real mod ID

---

## 2 — Upload the Vortex Extension

The Vortex game extension is hosted on GitHub Releases, not Nexus Mods.  
Users install it by dragging the zip onto Vortex's Extensions tab.

### Steps

1. Go to <https://github.com/shc261392/wh40k-dow-de-tc-mod/releases/latest>
2. Confirm that `vortex-ext-game-warhammer40kdawnofwar-v1.0.0.zip` is attached
3. Link to it from the Nexus mod description (link is already in the BBCode below)

To rebuild the extension zip: `make package-ext`

---

## 3 — Nexus Page Content

### Title

```
WH40K Dawn of War DE — Traditional Chinese Locale Fix
```

### Summary (one-liner shown on mod card)

```
Traditional Chinese font size fix, font weight correction, subtitle artifact fix, and text corrections for DoW DE.
```

### Description (BBCode — paste into the Nexus description editor)

```bbcode
[center][size=5][b]Traditional Chinese Locale Fix[/b][/size]
[size=3]Font + Text Corrections for Dawn of War – Definitive Edition[/size][/center]

[hr][/hr]

[size=4][b]What This Mod Fixes[/b][/size]

[list]
[*][b]Font size[/b] — All 13 FNT files corrected. Traditional Chinese glyphs no longer clip or overflow UI elements.
[*][b]Font weight[/b] — Main menu uses lighter NotoSansTC weights. No more bold-on-bold rendering.
[*][b]Subtitle artifact[/b] — The stray 緝 character that appeared at the end of every voiced Winter Assault subtitle line is gone.
[*][b]Text corrections[/b] — Punctuation, typos, and missing sentence endings fixed in [font=Courier New]Engine.ucs[/font].
[/list]

[hr][/hr]

[size=4][b]Requirements[/b][/size]

[list]
[*]Warhammer 40,000: Dawn of War – Definitive Edition (Steam App 3556750)
[*][url=https://www.nexusmods.com/about/vortex/]Vortex Mod Manager[/url] [i](recommended)[/i] — or follow the manual install below
[/list]

[hr][/hr]

[size=4][b]Installation — Vortex (Recommended)[/b][/size]

[list=1]
[*][b]Install the game extension[/b] — Download [b]vortex-ext-game-warhammer40kdawnofwar-v1.0.0.zip[/b] from the [url=https://github.com/shc261392/wh40k-dow-de-tc-mod/releases/latest]GitHub Releases page[/url], then drag it onto the Vortex [b]Extensions[/b] tab and click Enable.
[size=2][i](This only needs to be done once. It tells Vortex where DoW DE is installed.)[/i][/size]
[*][b]Add the mod[/b] — Click [b]Download with Manager[/b] on this page, or drag [b]wh40k-dow-de-tc-mod-v1.0.0.zip[/b] onto Vortex.
[*][b]Deploy[/b] — Click [b]Deploy Mods[/b] in Vortex.
[size=2][i]Vortex automatically renames [font=Courier New]EnginLoc.sga[/font] → [font=Courier New]EnginLoc.sga.disabled[/font] so the patched files take priority over the original archive.[/i][/size]
[*][b]Launch the game[/b] — Chinese text should now render correctly.
[/list]

[b]Uninstall:[/b] Click [b]Purge Mods[/b] in Vortex. The original [font=Courier New]EnginLoc.sga[/font] is restored automatically.

[hr][/hr]

[size=4][b]Installation — Manual (Windows)[/b][/size]

[list=1]
[*]Extract the mod zip into your game's locale directory:[code]<Steam install>\steamapps\common\Dawn of War Definitive Edition\Engine\Locale\Chinese\[/code]After extraction you should see [font=Courier New]data\font\[/font], [font=Courier New]data\art\[/font], [font=Courier New]data\sound\[/font], and [font=Courier New]Engine.ucs[/font] inside that folder.
[*]Rename the original archive so the loose files take priority:[code]EnginLoc.sga  →  EnginLoc.sga.disabled[/code]
[*]Launch the game.
[/list]

[b]Uninstall:[/b] Delete the extracted [font=Courier New]data\[/font] folder and [font=Courier New]Engine.ucs[/font], then rename [font=Courier New]EnginLoc.sga.disabled[/font] back to [font=Courier New]EnginLoc.sga[/font].

[hr][/hr]

[size=4][b]Known Issues[/b][/size]

[size=3][b]Tutorial prompt on first launch[/b][/size]
After first deploy, the game may show "Do you want to play the tutorial?" when clicking Campaign.
This is game-internal locale-change detection. Just dismiss it — it will not reappear.

[size=3][b]Campaign progress[/b][/size]
This mod does [b]not[/b] modify any save files or campaign progress. Deployment and uninstallation are fully reversible.

[hr][/hr]

[size=4][b]Source Code[/b][/size]

[url=https://github.com/shc261392/wh40k-dow-de-tc-mod]github.com/shc261392/wh40k-dow-de-tc-mod[/url]

Bug reports and text correction contributions welcome via GitHub Issues.
```

---

## 4 — After Publishing

Once the mod is live, update `mod/info.json` with the real mod ID:

1. Find the mod ID in the Nexus URL, e.g.:  
   `https://www.nexusmods.com/warhammerdawnofwardefinitiveedition/mods/42` → ID is `42`

2. Edit `mod/info.json`:
   ```json
   "nexusMods": {
     "modId": 42,
     ...
   },
   "source": {
     ...
     "nexusMods": "https://www.nexusmods.com/warhammerdawnofwardefinitiveedition/mods/42"
   }
   ```

3. Commit and push:
   ```bash
   git add mod/info.json
   git commit -m "chore(mod): set Nexus Mods ID to 42"
   git push
   ```
