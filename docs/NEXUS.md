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
   - Description: `Main mod archive — unofficial TC patch (fonts, art, sound, Engine.ucs)`
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
Unofficial Traditional Chinese Patch
```

### Summary (one-liner shown on mod card)

```
Unofficial Traditional Chinese patch for DoW DE — fixes fonts, subtitle artifact, and text corrections. | 非官方繁體中文補丁，修正字型、字幕殘字及文字校正。
```

### Description (BBCode — paste into the Nexus description editor)

```bbcode
[center][size=5][b]Unofficial Traditional Chinese Patch[/b][/size]
[size=3]Font Fixes + Text Corrections for Dawn of War – Definitive Edition[/size][/center]

[hr][/hr]

[size=4][b]What This Mod Fixes[/b][/size]

[list]
[*][b]Font size[/b] — All 13 FNT files corrected. Traditional Chinese glyphs no longer clip or overflow UI elements.
[*][b]Font weight[/b] — Main menu uses lighter NotoSansTC weights. No more bold-on-bold rendering.
[*][b]Subtitle artifact[/b] — The stray 緝 character that appeared at the end of every voiced Winter Assault subtitle line is gone.
[*][b]Text corrections[/b] — Punctuation, typos, and missing sentence endings fixed in [font=Courier New]Engine.ucs[/font].
[/list]

[hr][/hr]

[size=4][b]Compatibility[/b][/size]

This mod only modifies files inside [font=Courier New]Engine\Locale\Chinese\[/font] — specifically font configs, UI art, sound, and [font=Courier New]Engine.ucs[/font]. It should be compatible with any other mod that does [b]not[/b] touch those same files. No formal compatibility testing has been conducted.

If you discover a conflict with another mod, please let me know in the [b]comments or posts[/b] tab below.

[hr][/hr]

[size=4][b]Requirements[/b][/size]

[list]
[*]Warhammer 40,000: Dawn of War – Definitive Edition (Steam App 3556750)
[/list]

[hr][/hr]

[size=4][b]Installation[/b][/size]

[size=3][b]Manual install (Windows)[/b][/size]

[list=1]
[*]Extract the mod zip into your game's locale directory:[code]<Steam install>\steamapps\common\Dawn of War Definitive Edition\Engine\Locale\Chinese\[/code]After extraction you should see [font=Courier New]data\font\[/font], [font=Courier New]data\art\[/font], [font=Courier New]data\sound\[/font], and [font=Courier New]Engine.ucs[/font] inside that folder.
[*]Rename the original archive so the loose files take priority:[code]EnginLoc.sga  →  EnginLoc.sga.disabled[/code]
[*]Launch the game.
[/list]

[b]Uninstall:[/b] Delete the extracted [font=Courier New]data\[/font] folder and [font=Courier New]Engine.ucs[/font], then rename [font=Courier New]EnginLoc.sga.disabled[/font] back to [font=Courier New]EnginLoc.sga[/font].

[size=3][b]Vortex Mod Manager[/b][/size]

Vortex support requires a game extension that currently needs to be installed manually. This will be simplified once the extension is officially listed in Vortex — this section will be updated then.

For now, use the manual install above.

[hr][/hr]

[size=4][b]Known Issues[/b][/size]

[size=3][b]Tutorial prompt on first launch[/b][/size]
After first deploy, the game may show "Do you want to play the tutorial?" when clicking Campaign.
This is game-internal locale-change detection. Just dismiss it — it will not reappear.

[size=3][b]Campaign progress[/b][/size]
This mod does [b]not[/b] modify any save files or campaign progress. Deployment and uninstallation are fully reversible.

[hr][/hr]

[size=4][b]Questions & Support[/b][/size]

Have a question, found a bug, or want to contribute a text correction? Post in the [b]comments[/b] or [b]posts[/b] tab on this page — that's the best way to reach me.

[size=2][i](Source code also available at [url=https://github.com/shc261392/wh40k-dow-de-tc-mod]github.com/shc261392/wh40k-dow-de-tc-mod[/url] for reference.)[/i][/size]

[hr][/hr]
[hr][/hr]

[center][size=5][b]繁體中文說明[/b][/size][/center]

[hr][/hr]

[size=4][b]修正內容[/b][/size]

[list]
[*][b]字型大小[/b] — 修正全部 13 個 FNT 字型設定檔，繁體中文字形不再被截斷或溢出介面元素。
[*][b]字重[/b] — 主選單改用較細的 NotoSansTC 字重，消除雙重加粗現象。
[*][b]字幕殘字[/b] — 修正《冬季攻擊》劇情語音字幕末尾出現多餘「緝」字的問題。
[*][b]文字校正[/b] — 修正 [font=Courier New]Engine.ucs[/font] 中的標點符號、錯字及缺少句末標記等問題。
[/list]

[hr][/hr]

[size=4][b]相容性[/b][/size]

本模組只修改 [font=Courier New]Engine\Locale\Chinese\[/font] 資料夾內的檔案（字型設定、介面圖片、音效及 [font=Courier New]Engine.ucs[/font]）。凡是不修改上述同一路徑的模組，理論上皆可與本模組相容。目前尚未進行正式的相容性測試。

若您發現與其他模組的衝突，歡迎在下方的[b]留言區或討論區[/b]告知。

[hr][/hr]

[size=4][b]需求[/b][/size]

[list]
[*]《戰鎚40,000：戰爭黎明 決定版》Steam 版（App ID：3556750）
[/list]

[hr][/hr]

[size=4][b]安裝方式[/b][/size]

[size=3][b]手動安裝（Windows）[/b][/size]

[list=1]
[*]將模組 zip 解壓縮至遊戲的語言資料夾：[code]<Steam 安裝路徑>\steamapps\common\Dawn of War Definitive Edition\Engine\Locale\Chinese\[/code]解壓縮後應可看到 [font=Courier New]data\font\[/font]、[font=Courier New]data\art\[/font]、[font=Courier New]data\sound\[/font] 及 [font=Courier New]Engine.ucs[/font]。
[*]重新命名原始封存檔，讓散開的補丁檔案取得優先權：[code]EnginLoc.sga  →  EnginLoc.sga.disabled[/code]
[*]啟動遊戲。
[/list]

[b]解除安裝：[/b]刪除解壓縮的 [font=Courier New]data\[/font] 資料夾及 [font=Courier New]Engine.ucs[/font]，再將 [font=Courier New]EnginLoc.sga.disabled[/font] 重新命名為 [font=Courier New]EnginLoc.sga[/font]。

[size=3][b]Vortex Mod Manager[/b][/size]

Vortex 支援需要手動安裝遊戲擴充套件，步驟說明將在擴充套件正式列入 Vortex 支援名單後更新。

目前請使用上方的手動安裝方式。

[hr][/hr]

[size=4][b]已知問題[/b][/size]

[size=3][b]首次啟動出現教學提示[/b][/size]
首次部署後，點選「戰役」可能出現「是否要進行教學？」的提示。這是遊戲內部偵測到語系切換的正常反應，忽略即可，之後不會再次出現。

[size=3][b]戰役進度[/b][/size]
本模組 [b]不會[/b] 修改任何存檔或戰役進度，部署與解除安裝皆可完全還原。

[hr][/hr]

[size=4][b]問題與回饋[/b][/size]

有任何問題、發現錯誤，或想貢獻文字校正？請在本頁面的[b]留言區或討論區[/b]發文，這是聯繫我最好的方式。

[size=2][i]（原始碼亦可在 [url=https://github.com/shc261392/wh40k-dow-de-tc-mod]github.com/shc261392/wh40k-dow-de-tc-mod[/url] 取得，供參考。）[/i][/size]
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
