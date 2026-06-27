# AGENTS.md — AHKv2-Toastification

## What this is

AHKv2 toast notification library powered by GDI+. Single-file, no build step, no CI, no linter, no test framework. Users `#Include` one file and call static methods.

## Entrypoints

- **`lib/Toastify.ahk`** — the library. Ships as one file + vendored `lib/AHKv2-Gdip/Gdip_All.ahk`.
- **`simple_test.ahk`** — root-level demo script. Run with `& "path\to\AutoHotkey64.exe" simple_test.ahk`.
- `testing/` — gitignored experimental refactors (multi-instance variant, thread manager). Do not treat as production.

## Run it

No build. Double-click any `.ahk` file, or from CLI:
```
& "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" simple_test.ahk
```

## Architecture (6 classes in `lib/Toastify.ahk`)

| Class | Role |
|---|---|
| `Toastify` | Static singleton. `Start()`, `Show()`/`Success()`/`Error()`/etc., `SetConfig()`, `RegisterTheme()`, `DismissAll()`. |
| `Toast` | Instance per notification. GDI+ rendering, animation, progress bar, hover/click. |
| `ToastConfig` | Default config (fonts, sizes, animation, render quality). |
| `ToastTheme` | Palette registry. 30 built-in themes (dark/light pairs). GDI+ brush/pen caching. |
| `ToastEasing` | 43 easing functions. String-based lookup via `ToastEasing.getEasing(name, t)`. |
| `ToastMouseHook` | Low-level mouse hook for hover detection. |

## Critical ordering: `__createToast`

`__New → Push → __reflow → InitAnimation → Draw → AnimateIn`

`targetX/Y` are set by `__reflow`. `InitAnimation` cannot run before it. New toasts have `_initialized := false` — `__reflow` skips reflow for them so entrance animation controls initial positioning.

## Timers

- 16ms — global animation tick
- 100ms — watchdog, force-kill stale windows
- 50ms — mouse hover detection

## AHK v2 conventions

- Every script starts with `#Requires AutoHotkey v2.0`.
- `#Include` paths are relative (`lib\Toastify.ahk` or `lib/Toastify.ahk`).
- Classes and methods: PascalCase.
- `Map()` for associative arrays, `{key: val}` for structs.
- Function refs: `Func("Name")` or `(*) => expr`. Bound methods: `ObjBindMethod(obj, "method")`.

## Key API patterns

- `animStyle` accepts a string or array: `["slide", "fade", "zoom", "rotate"]`.
- `animEntrance: "auto"` infers direction from toast position.
- `permanent: true` disables auto-dismiss and progress bar.
- `Toastify.RegisterTheme(name, palette)` expects keys: `bg1`, `bg2`, `fg`, `accent`, `shadow`, `progress`. Border/progressBg/brushes are auto-computed.
- Per-toast `opts` override config: `fontName`, `fontSizeTitle`, etc.

## Constants reference

- **`Toastify.ALIGN`**: `TOP`, `BOTTOM`, `LEFT`, `RIGHT`, `CENTER`, `TOP_LEFT`, `TOP_RIGHT`, `BOTTOM_LEFT`, `BOTTOM_RIGHT`
- **`Toastify.THEMES`**: `DARK`, `LIGHT`, `SUCCESS`, `SUCCESS_LIGHT`, `ERROR`, `ERROR_LIGHT`, `WARNING`, `WARNING_LIGHT`, `INFO`, `INFO_LIGHT`, `MIDNIGHT`, `MIDNIGHT_LIGHT`, `FOREST`, `FOREST_LIGHT`, `NEON`, `NEON_LIGHT`, `VAPOR`, `VAPOR_LIGHT`, `CYBERPUNK`, `CYBERPUNK_LIGHT`, `RETRO`, `RETRO_LIGHT`, `GLASS`, `GLASS_LIGHT`, `MINIMAL`, `MINIMAL_LIGHT`, `PASTEL`, `PASTEL_LIGHT`, `FLAT`, `FLAT_LIGHT`
- **`Toastify.ANIM_STYLE`**: `SLIDE`, `FADE`, `ZOOM`, `ROTATE`
- **`Toastify.ENTRANCE`**: `AUTO`, `RIGHT`, `LEFT`, `TOP`, `BOTTOM`
- **`Toastify.QUALITY`**: `LOW`, `MEDIUM`, `HIGH`
- **`Toastify.EASING`**: 43 functions from `LINEAR` to `EASE_IN_OUT_CUBIC_EMPHASIZED`
- **`Toastify.PRIORITY`**: `IDLE`, `BELOW_NORMAL`, `NORMAL`, `ABOVE_NORMAL`, `HIGH`, `REALTIME`
