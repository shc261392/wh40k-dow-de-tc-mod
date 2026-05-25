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

### Description (Markdown — paste into the Nexus description editor)

---

# Unofficial Traditional Chinese Patch

Font fixes and text corrections for Warhammer 40,000: Dawn of War – Definitive Edition.

---

## What This Mod Fixes

- **Font size** — All 13 font files corrected. Traditional Chinese characters no longer clip or overflow the UI.
- **Font weight** — Main menu uses lighter fonts. No more bold-on-bold text.
- **Subtitle artifact** — A stray character (緝) that appeared at the end of every voiced subtitle in Winter Assault is removed.
- **Text corrections** — Punctuation, typos, and missing sentence endings fixed.

---

## Compatibility

This mod only changes files inside `Engine\Locale\Chinese\`. It should be compatible with any other mod that doesn't touch those same files. No formal compatibility testing has been done.

If you find a conflict with another mod, let me know in the **comments** below.

---

## Requirements

- Warhammer 40,000: Dawn of War – Definitive Edition (Steam App 3556750)

---

## How to Install

### Manual (Windows)

1. Download the mod zip from this page.
2. Extract it into this folder:
   ```
   [Steam]\steamapps\common\Dawn of War Definitive Edition\Engine\Locale\Chinese\
   ```
3. In that same folder, find `EnginLoc.sga` and rename it to `EnginLoc.sga.disabled`.
4. Start the game. Done!

**To uninstall:**
1. Go back to the same `Chinese\` folder.
2. Delete the `data\` folder and `Engine.ucs` (the files from this mod).
3. Rename `EnginLoc.sga.disabled` back to `EnginLoc.sga`.

### Vortex Mod Manager

Vortex support requires a game extension that currently needs to be set up manually.
Once the extension is officially listed in Vortex, setup will be much simpler — instructions will be updated then.

For now, use the manual install above.

---

## Known Issues

**Tutorial prompt on first launch**
After installing, the game may ask "Do you want to play the tutorial?" when you click Campaign. Just dismiss it — this only happens once.

**Campaign progress**
This mod does **not** touch any save files or campaign progress. You can install and uninstall safely.

---

## Questions & Support

Have a question or found an issue? Post in the **comments** on this page.

*(Source: [github.com/shc261392/wh40k-dow-de-tc-mod](https://github.com/shc261392/wh40k-dow-de-tc-mod))*

---
---

# 繁體中文說明

《戰鎚40,000：破曉之戰 決定版》非官方繁體中文補丁。

---

## 修正內容

- **字型大小** — 修正全部 13 個字型設定檔，繁體中文字形不再被截斷或溢出介面。
- **字重** — 主選單改用較細字重，消除雙重加粗現象。
- **字幕殘字** — 修正《冬季攻擊》劇情語音字幕末尾出現多餘「緝」字的問題。
- **文字校正** — 修正標點符號、錯字及缺少句末標記等問題。

---

## 相容性

本模組只修改 `Engine\Locale\Chinese\` 資料夾內的檔案。凡是不修改相同路徑的模組，理論上皆可與本模組相容。目前尚未進行正式的相容性測試。

若您發現與其他模組的衝突，歡迎在下方**留言區**告知。

---

## 需求

- 《戰鎚40,000：破曉之戰 決定版》Steam 版（App ID：3556750）

---

## 安裝方式

### 手動安裝（Windows）

1. 從本頁面下載模組壓縮檔。
2. 解壓縮至以下資料夾：
   ```
   [Steam]\steamapps\common\Dawn of War Definitive Edition\Engine\Locale\Chinese\
   ```
3. 在同一個資料夾內，找到 `EnginLoc.sga`，將它重新命名為 `EnginLoc.sga.disabled`。
4. 啟動遊戲，完成！

**解除安裝：**
1. 回到相同的 `Chinese\` 資料夾。
2. 刪除 `data\` 資料夾以及 `Engine.ucs`（本模組的檔案）。
3. 將 `EnginLoc.sga.disabled` 重新命名回 `EnginLoc.sga`。

### Vortex Mod Manager

Vortex 支援需要手動安裝遊戲擴充套件，待擴充套件正式列入 Vortex 名單後，步驟將更簡單，屆時說明會一併更新。

目前請使用上方的手動安裝方式。

---

## 已知問題

**首次啟動出現教學提示**
安裝後首次點選「戰役」，遊戲可能詢問「是否要進行教學？」，忽略即可，只會出現一次。

**戰役進度**
本模組**不會**修改任何存檔或戰役進度，可安心安裝與解除安裝。

---

## 問題與回饋

有任何問題或發現錯誤？請在本頁面的**留言區**留言。

*（原始碼：[github.com/shc261392/wh40k-dow-de-tc-mod](https://github.com/shc261392/wh40k-dow-de-tc-mod)）*

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
