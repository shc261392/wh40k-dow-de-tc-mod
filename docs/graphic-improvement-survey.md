# Graphic Improvement Mod Survey — DoW: Definitive Edition

> **Status**: Research / feasibility survey  
> **Scope**: What visual quality improvements are possible beyond the DE baseline, and how hard is each one.

---

## 1. Baseline: What the DE Already Improved

Relic's Definitive Edition remaster (2022) layered new, higher-priority archives on top of the original data. Understanding this layering is essential before planning any further improvements.

### Module load order (`W40k.module`, first wins)

| Priority | Archive / Folder | Contents |
|----------|-----------------|----------|
| 1 (highest) | `W40kData-SharedTextures-Definitive.sga` | Remaster-quality shared textures |
| 2 | `W40kData-SharedTextures-Full.sga` | Full-res original shared textures |
| 3 | `W40kData-Whm-Definitive.sga` | Remaster-quality unit/building models |
| 4 | `W40kData-Whm-High.sga` | High-quality original models |
| 5 (lowest) | `W40kData.sga` | Base game data (2004) |

The same `Definitive` / `Full` / `High` pattern repeats for `DoWDE`, `DXP2`, `DXP3`, and `WXP` campaign modules.

**Key insight**: A mod only needs to place its files at a higher priority than `*-Definitive.sga` to override DE assets — no patching required. This is done by deploying loose files to the `Data_Shared_Textures\Remaster` or `Data_Whm\Remaster` folder paths, or by registering a mod archive that loads before the DE ones.

### What DE improved vs original (2004):
- Texture resolution: 2–4× upscale on most unit textures and terrain
- Unit models: higher poly counts and additional detail meshes in `*-Definitive.sga`
- Shadow support: added entirely (absent from original)
- Widescreen: proper aspect ratio handling
- Anti-aliasing: MSAA options exposed in settings
- Cutscene FMV: pre-rendered movies at higher resolution

### What DE did NOT improve:
- No ray tracing, no DLSS/FSR (DX9 engine)
- Particle/VFX density and resolution largely unchanged
- Terrain textures partially updated, inconsistent quality
- Shadow map resolution and draw distance capped
- No ambient occlusion
- No screen-space reflections
- Shader pipeline unchanged from 2004 HLSL

---

## 2. Graphics Pipeline Overview

DoW DE runs on the **Relic Essence Engine** (v1/v2), a custom DirectX 9 engine.

| Layer | Technology | Modifiable? |
|-------|-----------|-------------|
| Renderer | DirectX 9 | No (engine binary) |
| Shaders | HLSL `.fx` / compiled `.fxo` | Partial (see §4) |
| Textures | DDS (DXT1/DXT5/BC formats) | Yes |
| Models | `.whm` / `.sgm` | Yes (official tools) |
| Particles / VFX | `.bfx` / `.fx` | Yes (FxTool) |
| Terrain | `.rtx` / Lua atmosphere | Yes |
| UI | `.swf` / `.gfx` (Flash/Scaleform) | Yes |
| Post-processing | None (engine-native) | Via ReShade injection |

---

## 3. Opportunity Areas

### 3.1 ReShade Post-Processing  ⭐ Highest feasibility / impact

**What it is**: ReShade is a generic DX9/DX10/DX11 shader injector. It applies full-screen effects after the renderer outputs its frame. No game files are modified.

**Compatible**: Yes — DoW DE uses DirectX 9; ReShade 5.x supports DX9. Install by copying `dxgi.dll` / `d3d9.dll` and `ReShade.ini` to the game root.

**Effects possible**:
- **SMAA** — better anti-aliasing than the engine's MSAA, especially on foliage and model edges
- **HBAO / SSAO** — ambient occlusion gives depth to units and terrain that the engine completely lacks
- **Bloom / HDR tonemapping** — the engine's bloom is flat; ReShade can give it cinematic quality
- **Sharpening (CAS / LUT)** — compensates for any softness introduced by MSAA or upscaling
- **Color grading** — bring the palette more in line with Warhammer 40k's grimdark aesthetic
- **Depth of field** (subtle) — ground-level or cutscene use

**Effort**: Low — configure a preset, ship as an optional extra  
**Risk**: None (no game files changed; player can toggle on/off)  
**Deliverable**: A `.ini` ReShade preset file, installation instructions

---

### 3.2 Texture Upscaling Pack  ⭐ High impact, medium effort

**What it is**: Extract textures from SGA archives, run through an AI upscaler, repack and deploy at higher priority than the DE archives.

**Pipeline**:
1. Unpack: `Archive.exe` (bundled) or `relic-tool-sga` to extract `.dds` files
2. Convert: DDS → PNG/TGA for upscaler input (ImageMagick, texconv)
3. Upscale: Real-ESRGAN (4× general-purpose model) or a Warhammer-fine-tuned model
4. Re-compress: PNG → DDS (BC3/BC7 for colour+alpha; BC1 for opaque; texconv.exe)
5. Repack: into a new SGA archive loaded before `*-Definitive.sga`

**Target assets** (highest visual payoff):
- Unit portrait textures (used in HUD — low res, very noticeable at any resolution)
- Shared terrain textures (tiling ground, rock, water — cover the entire battlefield)
- Unit diffuse/specular textures (body armour, weapons)
- Building texture sheets
- Skyboxes / environment maps

**Effort**: Medium-High (hours per faction; automation helps a lot)  
**Risk**: Low — upscaled textures override cleanly; vanilla is a fallback  
**Tools needed**: `Archive.exe` (bundled), Real-ESRGAN, texconv (Microsoft DX SDK, free), ImageMagick

---

### 3.3 Shader & Visual Effects Improvements  ⭐ Medium feasibility

**What it is**: The game ships `.fx` source files (HLSL) for particle systems and object shaders inside the SGA archives. These can be extracted, edited, recompiled with `FxTool.exe` (bundled), and redeployed as a loose-file mod.

**FxTool.exe** is bundled at the game root. It is the official Relic shader/particle editor used in development.

**Target improvements**:
- **Weapon/explosion particles**: increase emitter counts, add sub-emitters for sparks/debris
- **Blood / gore particles**: higher density, longer lifetime
- **Energy weapon glow**: more volumetric bloom on plasma / psychic effects
- **Shadow softening**: edit shadow filter kernel in terrain/model shaders
- **Water shader**: improve reflection, add ripple normal map
- **Fire effects**: more sub-layers, animated noise textures

**Effort**: Medium — shader knowledge required; FxTool has a GUI for particle work  
**Risk**: Low-Medium — incorrect shader compilation crashes the effect (not the game)  
**Blocked on**: Some shaders are pre-compiled `.fxo` in the archive; only `.fx` source files can be edited without a shader decompiler

---

### 3.4 Image-Based Lighting (IBL) Tweaks  ⭐ Low effort, subtle impact

**What it is**: `Tools/ModDocs/DefaultIBL.lua` defines the default environment / ambient light cube used when no map-specific IBL is present. Editing this changes the ambient tint, intensity, and directionality of light across all maps that use the default.

**Possible changes**:
- Shift ambient colour towards a more grimdark orange/red or cold grey tone
- Increase contrast between lit and shadowed faces on models
- Apply per-campaign IBL tweaks (e.g., colder tone for Winter Assault, dry for Dark Crusade)

**Effort**: Very Low — Lua text file, no compilation, immediate effect  
**Risk**: Low — only affects ambient fill; direct lighting is separate

---

### 3.5 Model Improvements  ⭐ Low feasibility (high effort)

**What it is**: Replace `.whm` / `.sgm` model files with higher-poly versions.

**Pipeline**:
1. Extract model from SGA with `Archive.exe`
2. Open in `ObjectEditor.exe` (bundled) and export to FBX or use a third-party importer
3. Edit in Blender / 3ds Max (add geometry, improve silhouette, re-UV)
4. Import back with `FBXtoSGM.exe` (bundled FBX → SGM converter)
5. Repack as an SGA at higher priority than `*-Whm-Definitive.sga`

**Reality check**: The DE already significantly improved model poly counts. Unit models are also shared by multiplayer, so any model change must not alter hitboxes or collision geometry — the engine uses separate collision meshes, but care is still needed.

**Effort**: Very High — each unit is a substantial 3D art task  
**Risk**: Medium — model import can break animations if skeleton/vertex weights change  
**Best candidates**: Hero units (Gabriel Angelos, Gorgutz, Taldeer), where a single high-detail model has significant screen presence

---

### 3.6 UI Visual Overhaul  ⭐ Medium feasibility

**What it is**: The HUD and menus use Scaleform GFX Flash (`.swf` / `.gfx`) files. These can be decompiled with tools like JPEXS Free Flash Decompiler, edited, and repackaged.

**Possible changes**:
- Replace UI frame textures with higher-resolution versions
- Update icon art for units/abilities
- Adjust colour palette for better readability at 4K
- Modernise button layouts

**Effort**: Medium — Flash authoring skills needed; GFX format differs slightly from standard SWF  
**Risk**: Low — UI changes are cosmetic and don't affect gameplay  
**Tools**: JPEXS Free Flash Decompiler (free), Adobe Animate or Ruffle for testing, game-bundled `UIEditor.exe`

---

## 4. Feasibility Matrix

| Technique | Feasibility | Visual Impact | Effort | Risk |
|-----------|------------|---------------|--------|------|
| ReShade preset | ★★★★★ | High | Low | None |
| AI texture upscaling | ★★★★☆ | High | Medium-High | Low |
| IBL / atmosphere tweaks | ★★★★☆ | Low-Med | Very Low | Low |
| Particle / VFX (FxTool) | ★★★☆☆ | Medium | Medium | Low-Med |
| Shader source edits (`.fx`) | ★★★☆☆ | Medium-High | High | Medium |
| UI texture replacement | ★★★☆☆ | Low-Med | Medium | Low |
| Model replacements | ★★☆☆☆ | High | Very High | Medium |

---

## 5. Hard Limits (Cannot Be Modded)

| Feature | Reason |
|---------|--------|
| Ray tracing / path lighting | Requires DX12; engine is DX9 |
| DLSS / FSR upscaling | Requires DX12 / Vulkan integration |
| Deferred rendering / GBuffer | Forward renderer only; architecture is fixed in binary |
| Compiled shader override (`.fxo`) | No source → need decompiler (RenderDoc + SPIRV-Cross or similar) |
| Geometry / tessellation | No DX11 tessellation hardware stage available |

---

## 6. Recommended Starting Point

**Phase 1 — ReShade preset** (1–2 days)
- Achieves the highest visual improvement for the least work
- Zero risk to game stability
- Can be distributed as a simple `.ini` alongside brief install instructions
- Suggested effects: SMAA + HBAO+ + subtle bloom enhancement + sharpening + light color grading

**Phase 2 — Unit portrait texture pack** (1–2 weeks)
- Portrait textures are small (128×128 to 256×256) and very noticeable in-game
- The full set for one faction is manageable in a weekend with automated DDS pipeline
- Deploy loosely into `W40k/Data_Shared_Textures/Remaster/` (already the highest-priority lookup path)

**Phase 3 — Terrain texture upscaling** (ongoing)
- The most impactful for environmental quality
- Large number of assets but all can be processed in bulk with Real-ESRGAN

---

## 7. Community Resources

| Resource | URL |
|----------|-----|
| DoW Modding Wiki | https://dow.fandom.com/wiki/Modding |
| Relic Mod Tools documentation | `Tools/ModDocs/` in game directory |
| relic-tool-sga (Python) | https://github.com/ModernMAK/Relic-Game-Tool |
| Real-ESRGAN upscaler | https://github.com/xinntao/Real-ESRGAN |
| ReShade | https://reshade.me |
| texconv (Microsoft) | https://github.com/Microsoft/DirectXTex |
| JPEXS Flash Decompiler | https://github.com/jindrapetrik/jpexs-decompiler |
