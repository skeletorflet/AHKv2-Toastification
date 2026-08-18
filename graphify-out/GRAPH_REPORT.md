# Graph Report - .  (2026-08-18)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 252 nodes · 460 edges · 12 communities (6 shown, 6 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `251ccaa8`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Gdip_All.ahk
- Toastify
- Toastify.ahk
- Toastify — AHKv2 Toast Notifications
- theme_generator.ahk
- ToastDPI
- CreatePointF
- CreateRect
- CreateRectF
- Gdip_CreateARGBHBITMAPFromBitmap
- GetMonitorCount
- MDMF_EnumProc

## God Nodes (most connected - your core abstractions)
1. `Gdip_All.ahk script` - 152 edges
2. `Toastify` - 27 edges
3. `theme_generator.ahk script` - 18 edges
4. `Toastify — AHKv2 Toast Notifications` - 15 edges
5. `ToastDPI` - 10 edges
6. `ShowToastFrom()` - 7 edges
7. `ToastTheme` - 6 edges
8. `ShowRandom()` - 6 edges
9. `RandomConfig()` - 6 edges
10. `RandGenerate()` - 5 edges

## Surprising Connections (you probably didn't know these)
- `Gdip_All.ahk script` --calls--> `CreatePointF()`  [EXTRACTED]
  lib/AHKv2-Gdip/Gdip_All.ahk → lib/AHKv2-Gdip/Gdip_All.ahk  _Bridges community 0 → community 6_
- `Gdip_All.ahk script` --calls--> `CreateRect()`  [EXTRACTED]
  lib/AHKv2-Gdip/Gdip_All.ahk → lib/AHKv2-Gdip/Gdip_All.ahk  _Bridges community 0 → community 7_
- `Gdip_All.ahk script` --calls--> `CreateRectF()`  [EXTRACTED]
  lib/AHKv2-Gdip/Gdip_All.ahk → lib/AHKv2-Gdip/Gdip_All.ahk  _Bridges community 0 → community 8_
- `Gdip_All.ahk script` --calls--> `Gdip_CreateARGBHBITMAPFromBitmap()`  [EXTRACTED]
  lib/AHKv2-Gdip/Gdip_All.ahk → lib/AHKv2-Gdip/Gdip_All.ahk  _Bridges community 0 → community 9_
- `Gdip_All.ahk script` --calls--> `GetMonitorCount()`  [EXTRACTED]
  lib/AHKv2-Gdip/Gdip_All.ahk → lib/AHKv2-Gdip/Gdip_All.ahk  _Bridges community 0 → community 10_

## Import Cycles
- None detected.

## Communities (12 total, 6 thin omitted)

### Community 0 - "Gdip_All.ahk"
Cohesion: 0.03
Nodes (140): Gdip_All.ahk script, BitBlt(), CreateCompatibleBitmap(), CreateCompatibleDC(), CreateDIBSection(), CreateSizeF(), DeleteDC(), DeleteObject() (+132 more)

### Community 1 - "Toastify"
Cohesion: 0.09
Nodes (7): Toastify, Toastify.OnExit(), Toastify.__onMouseLeave(), Toastify.__onMouseMove(), Toastify.Shutdown(), Toastify.__toastByHwnd(), Toastify.__trackLeave()

### Community 2 - "Toastify.ahk"
Cohesion: 0.13
Nodes (17): Toastify.ahk script, Toast, ToastConfig, ToastEasing, Toastify.RegisterTheme(), ToastTheme, ToastTheme.DeletePalette(), ToastTheme.InitThemes() (+9 more)

### Community 3 - "Toastify — AHKv2 Toast Notifications"
Cohesion: 0.10
Nodes (19): Actions & Callbacks, Animation, Constants, Controlling Toasts, Custom themes, Demo, Easing curves, Global Setup (+11 more)

### Community 4 - "theme_generator.ahk"
Cohesion: 0.32
Nodes (18): ActionCallback(), theme_generator.ahk script, BuildCode(), CollectConfig(), EnumFontFamProc(), HasValue(), JoinParts(), Pick() (+10 more)

### Community 5 - "ToastDPI"
Cohesion: 0.23
Nodes (7): ToastDPI.ahk script, ToastDPI, ToastDPI._DpiFromMonitor(), ToastDPI.ForPoint(), ToastDPI.Primary(), ToastDPI.Px(), ToastDPI.WorkArea()

## Knowledge Gaps
- **20 isolated node(s):** `Quick Start`, `Requirements`, `Global Setup`, `Show Methods`, `Per-Toast Alignment Override` (+15 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Gdip_All.ahk script` connect `Gdip_All.ahk` to `CreatePointF`, `CreateRect`, `CreateRectF`, `Gdip_CreateARGBHBITMAPFromBitmap`, `GetMonitorCount`, `MDMF_EnumProc`?**
  _High betweenness centrality (0.180) - this node is a cross-community bridge._
- **Why does `Toastify` connect `Toastify` to `Toastify.ahk`?**
  _High betweenness centrality (0.180) - this node is a cross-community bridge._
- **What connects `Quick Start`, `Requirements`, `Global Setup` to the rest of the system?**
  _20 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Gdip_All.ahk` be split into smaller, more focused modules?**
  _Cohesion score 0.028267477203647418 - nodes in this community are weakly interconnected._
- **Should `Toastify` be split into smaller, more focused modules?**
  _Cohesion score 0.08923076923076922 - nodes in this community are weakly interconnected._
- **Should `Toastify.ahk` be split into smaller, more focused modules?**
  _Cohesion score 0.12554112554112554 - nodes in this community are weakly interconnected._
- **Should `Toastify — AHKv2 Toast Notifications` be split into smaller, more focused modules?**
  _Cohesion score 0.1 - nodes in this community are weakly interconnected._