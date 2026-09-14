# Toastify — AHKv2 Toast Notifications

A lightweight, GDI+-powered toast notification library for AutoHotkey v2.0. Zero dependencies beyond the vendored GDI+ wrapper.

- Native layered windows, always-on-top, no external DLLs
- GDI+ rendering: gradients, rounded corners, shadows, emoji support
- Per-monitor DPI v2 aware; content scales with the monitor's real DPI
- 60 Hz animation loop, auto power-down to 0% CPU when idle
- 56 built-in themes (28 palettes × dark/light), custom themes supported
- Action buttons, icons, live/indeterminate progress bar, hover interactions
- Per-toast alignment override on top of the global position
- `"auto"` theme follows the Windows light/dark setting
- Reduced-motion and high-contrast awareness; Esc-to-dismiss (opt-in)

## Quick Start

```autohotkey
#Include lib\Toastify.ahk

; Initialize with position
Toastify.Start("dark", Toastify.ALIGN.BOTTOM_RIGHT)

; Show a toast
Toastify.Success("Saved!", "Your changes are safe.")
```

## Requirements

- AutoHotkey v2.0+
- Windows Vista+ (per-monitor DPI needs Windows 10 1703+)
- DPI awareness enabled automatically: at `#Include` time the library sets the
  thread to Per-Monitor v2 (`SetThreadDpiAwarenessContext(-4)`, with v1 and
  system-aware fallbacks), so toasts render at the correct physical size on
  any scaling (100%–200%+). Note: this applies to the whole script thread —
  any other GUIs you create after including Toastify also become per-monitor
  aware and are no longer bitmap-scaled by the OS.

## Global Setup

```autohotkey
Toastify.Start(theme := "dark", position := "top-right")
```

`Start` is idempotent — safe to call repeatedly; it only re-applies theme/position.

```autohotkey
; Global defaults for all toasts
Toastify.SetConfig({
    width: 340,
    designScale: 1,
    animDuration: 300,
    animEasing: "easeOutCubic",
    animStyle: "slide",
    animEntrance: "auto",
    fontName: "Segoe UI Emoji",
    fontSizeTitle: 16,
    fontSizeBody: 13,
    borderRadius: 18,
    borderWidth: 0,
    renderQuality: "High",
    repoDuration: 300,
})
```

| Global property | Default | Purpose |
|---|---|---|
| `Toastify.theme` | `"dark"` | Default theme for new toasts |
| `Toastify.position` | `"top-right"` | Default alignment |
| `Toastify.hoverPauseEnabled` | `true` | Pause auto-dismiss timer while hovered |
| `Toastify.maxToasts` | `8` | Hard cap; lowest-`priority` toast exits when exceeded |
| `designScale` (via SetConfig) | `1` | Global multiplier for all design points |

## Show Methods

| Method | Description |
|---|---|
| `Toastify.Show(title, body?, actions?, opts?)` | Generic toast |
| `Toastify.Success(title, body?, actions?, opts?)` | Green success toast |
| `Toastify.Error(title, body?, actions?, opts?)` | Red error toast |
| `Toastify.Warning(title, body?, actions?, opts?)` | Orange warning toast |
| `Toastify.Info(title, body?, actions?, opts?)` | Blue info toast |
| `Toastify.Custom(opts)` | Full control via one object (`title`, `body`, `actions`, ...) |
| `Toastify.ShowView(viewItems, opts?)` | Custom GDI+ rendered views |
| `Toastify.DismissAll()` | Dismiss all toasts (out animation respected) |
| `Toastify.KillAll()` | Remove all toasts instantly, no animation |

## Per-Toast Alignment Override

The global position from `Start` is only a default. Every toast can override its
final alignment; mixed alignments stack independently per corner and keep their
own order/index:

```autohotkey
; Global is BOTTOM_RIGHT, but this one goes top-left
Toastify.Show("Title", "Body", , {
    position: Toastify.ALIGN.TOP_LEFT,
    duration: 0,
})
```

Constants for `position` / `Toastify.ALIGN`:

| Constant | Value |
|---|---|
| `TOP_LEFT`, `TOP_RIGHT`, `BOTTOM_LEFT`, `BOTTOM_RIGHT` | Corners |
| `TOP`, `BOTTOM` | Centered horizontally |
| `LEFT`, `RIGHT` | Full-height, vertically centered |
| `CENTER` | Center of work area |

## Per-Toast Options

```autohotkey
Toastify.Show("Title", "Body", [], {
    width: 400,                      ; Toast width
    duration: 3000,                  ; Auto-dismiss time (ms); 0 = permanent
    theme: "success",                ; Theme name
    position: "bottom-right",        ; Per-toast alignment override
    icon: "success",                 ; Icon preset ("success", "error", "warning", "info")
    showClose: true,                 ; Show close button
    showProgress: true,              ; Show progress bar
    progressBarWaitPosition: true,   ; Bar starts after entrance; false = from creation (duration auto-clamped to entrance+exit)
    permanent: false,                ; Never auto-dismiss
    autoDismiss: true,               ; Allow auto-dismiss when progress completes
    opacity: 1.0,                    ; Base opacity (0.0-1.0)
    opacityOnHover: false,           ; Smoothly raise opacity to 100% on hover
    animStyle: ["slide", "fade"],    ; Animation style(s)
    animEasing: "easeOutCubic",      ; Easing curve
    animEntrance: "auto",            ; Entrance direction
    animDuration: 300,               ; Animation duration (ms)
    onClick: (*) => MsgBox("Tapped"),
    onClose: (*) => MsgBox("Closed"),
    fontName: "Segoe UI",
    fontSizeTitle: 16,
    fontSizeBody: 13,
    borderRadius: 18,
    borderWidth: 0,
    paddingX: 16,
    paddingY: 14,
    iconSize: 32,
    renderQuality: "High",
})
```

### Options Quick Reference

| Option | Type | Default | Notes |
|---|---|---|---|
| `duration` | int (ms) | `4000` | `0` = permanent |
| `permanent` | bool | `false` | Forces `duration := 0`, `showProgress := false` |
| `autoDismiss` | bool | `true` | Dismiss when progress reaches 100% |
| `opacity` | float | `1.0` | Base opacity of the toast |
| `opacityOnHover` | bool | `false` | Fade to 100% opacity on hover |
| `showClose` | bool | `true` | X button, top-right |
| `showProgress` | bool | `false` | Thin progress bar at the bottom |
| `progressBarWaitPosition` | bool | `true` | `true`: bar advances once the toast reaches its position (after entrance). `false`: bar runs from creation; `duration` is clamped to `2 × animDuration` (entrance + exit) to avoid flicker |
| `position` | string | global | Per-toast alignment override |
| `icon` | string | `""` | `"success"`, `"error"`, `"warning"`, `"info"` |
| `width` | int | `340` | Toast width (design px at 96 DPI; scaled by monitor DPI) |
| `designScale` | float | `1` | Multiplies all design points. Shrink toasts on small screens, e.g. `0.85` on 1366x768 |
| `animStyle` | array/string | `["slide"]` | 1-4 of the ANIM_STYLE values |
| `animEasing` | string | `"easeOutCubic"` | Any EASING value |
| `animEntrance` | string | `"auto"` | `AUTO` resolves from position |
| `animDuration` | int (ms) | `300` | In/out animation length |
| `repoDuration` | int (ms) | `300` | Reorder animation length |
| `repoEasing` | string | `""` (inherit `animEasing`) | Easing for the reposition slide; empty = use the toast's `animEasing` |
| `onClick` | callback | — | Fires when toast body clicked (not buttons) |
| `onClose` | callback | — | Fires when toast is closed |
| `sound` | string | `""` | System sound alias, e.g. `"SystemAsterisk"`, `"SystemExclamation"` |
| `tag` | string | `""` | Group/dedupe key — same tag replaces the existing toast (case-sensitive) |
| `priority` | int | `0` | Higher priority survives eviction when `maxToasts` or screen space is hit |
| `indeterminate` | bool | `false` | Smooth 0→100% fill loop (1800ms); forces `showProgress`, `autoDismiss := false` |
| `progressHeight` | int | global (`3`) | Progress bar thickness (design px) |
| `progressStriped` | bool | `false` | Animated diagonal stripes over the progress fill |
| `stripeSpeed` | int (px/s) | `40` | Marquee scroll speed of the stripes |
| `stripeWidth` | int (px) | `3` | Stripe thickness (design px) |
| `stripeSpacing` | int (px) | `8` | Distance between stripes (design px) |
| `blurBehind` | bool | `false` | Real backdrop blur: captures the screen behind the window, blurs it (downscale/upscale), clips it to the rounded card. Refreshed ~3×/s while visible |
| `marginX` | int | `-1` | Per-toast horizontal margin; `-1` = global `Toastify.marginX` |
| `marginY` | int | `-1` | Per-toast vertical margin; `-1` = global `Toastify.marginY` |
| `spacing` | int | `-1` | Per-toast stack gap; `-1` = global `Toastify.spacing` |

## Constants

| Constant | Values |
|---|---|
| `Toastify.ALIGN` | `TOP_LEFT`, `TOP_RIGHT`, `BOTTOM_LEFT`, `BOTTOM_RIGHT`, `LEFT`, `RIGHT`, `TOP`, `BOTTOM`, `CENTER` |
| `Toastify.ANIM_STYLE` | `SLIDE`, `FADE`, `ZOOM`, `ROTATE` |
| `Toastify.ENTRANCE` | `AUTO`, `LEFT`, `RIGHT`, `TOP`, `BOTTOM` |
| `Toastify.EASING` | `LINEAR`, `EASE_OUT_CUBIC`, `BOUNCE_IN`, `BOUNCE_OUT`, `ELASTIC_OUT`, `DECELERATE`, and 30+ more |
| `Toastify.THEMES` | `AUTO`, `DARK`, `LIGHT`, `SUCCESS`, `ERROR`, `WARNING`, `INFO`, `NEON`, `VAPOR`, `CYBERPUNK`, `RETRO`, `GLASS`, `MINIMAL`, `PASTEL`, `FLAT`, `MIDNIGHT`, `FOREST`, `DRACULA`, `TOKYO_NIGHT`, `CATPPUCCIN_MOCHA`, `CATPPUCCIN_LATTE`, `NORD`, `SOLARIZED`, `GRUVBOX`, `ONE_DARK`, `ONE_LIGHT`, `SYNTHWAVE`, `MONOKAI`, `MATERIAL_YOU`, `CARBON`, `AYU` (each with `_LIGHT` variant) |
| `Toastify.QUALITY` | `LOW`, `MEDIUM`, `HIGH` |
| `Toastify.PRIORITY` | `IDLE`, `BELOW_NORMAL`, `NORMAL`, `ABOVE_NORMAL`, `HIGH`, `REALTIME` |

## Animation

### Mixing styles

Combine up to 4 animation styles for compound effects:

```autohotkey
animStyle: [
    Toastify.ANIM_STYLE.SLIDE,
    Toastify.ANIM_STYLE.FADE,
    Toastify.ANIM_STYLE.ZOOM,
    Toastify.ANIM_STYLE.ROTATE,
]
```

### Easing curves

`Toastify.EASING` exposes 30+ curves: `LINEAR`, `EASE_IN/OUT/IN_OUT_QUAD/CUBIC/QUART/QUINT`,
`EASE_IN/OUT/IN_OUT_BACK/SINE/EXPO/CIRC`, `BOUNCE`, `BOUNCE_IN/OUT/IN_OUT`,
`ELASTIC_IN/OUT/IN_OUT`, `DECELERATE`, `EASE`, `EASE_IN/OUT`, and more.

> **Known issue:** ~~`ROTATE`/`ZOOM` animations may briefly flicker a dark
> background.~~ Fixed: `ResizeBuffer` clears the canvas and invalidates the
> cached alpha before the first transformed frame.

## Actions & Callbacks

```autohotkey
Toastify.Show("Update Available", "v2.1.0 is ready.", [
    {text: "Update", onClick: (*) => Run("updater.exe")},
    {text: "Later", onClick: (*) => MsgBox("Snoozed")},
])
```

Button features:

- Buttons are **auto-sized to their label** — no text wrapping. If the row
  overflows the toast width, the button font shrinks (min 8px) instead.
- Button text color is **auto-contrasted** against the theme accent (WCAG
  luminance pick: white or near-black, whichever has the better ratio).
- Clicking any action button runs its callback, then the toast exits.
- A "Close" button is just `{text: "Close", onClick: (*) => {}}` — the toast
  closes after the callback.

## Controlling Toasts

`Show`/`ShowView`/`Custom` return the `Toast` object:

```autohotkey
t := Toastify.Show("Hello", "World")

t.Close()          ; Force close (user-initiated exit)
t.StartExit()      ; Begin exit animation
t.Dismiss(true)    ; Instant removal (no animation)
t.Invalidate()     ; Re-measure + redraw (after live style edits)
t.position := Toastify.ALIGN.TOP_LEFT   ; Move it live (reflow applies)
```

Batch and group control:

```autohotkey
Toastify.DismissAll()            ; Respects out animations on every toast
Toastify.KillAll()               ; Instant removal of all toasts, including mid-exit ones
Toastify.DismissGroup("batch-1") ; Graceful exit for every toast with tag "batch-1"
Toastify.KillGroup("batch-1")    ; Instant removal for a tag group
```

Global behavior flags (set before/after `Start`):

| Flag | Default | Effect |
|---|---|---|
| `Toastify.escEnabled` | `false` | Opt-in global `Esc` hotkey dismisses the newest toast (`Toastify.SetEscEnabled(true)` toggles it live, even after `Start`) |
| `Toastify.reducedMotion` | auto | Read from Windows `SPI_GETCLIENTAREAANIMATION`; toasts land instantly when animations are off |
| `Toastify.highContrast` | auto | Read from `SPI_GETHIGHCONTRAST`; default theme becomes `"minimal"` while active |

## Hover Behavior

- Auto-dismiss timers **pause while hovered** and resume on leave
  (`Toastify.hoverPauseEnabled`, default `true`).
- With `opacityOnHover: true`, a semi-transparent toast (`opacity: 0.5`)
  smoothly fades to 100% while hovered and back on leave. Direction changes
  are evaluated every frame — no stutter on fast in/out.
- Close button shows a highlight halo on hover.
- A periodic rect check clears stuck hover state (WM_MOUSELEAVE on layered
  windows is unreliable).

## Progress Bar Timing

By default (`progressBarWaitPosition: true`) the progress bar starts advancing
only after the entrance animation completes — it sits at 0 while the toast
slides/fades in.

With `progressBarWaitPosition: false` the bar starts advancing the moment the
toast is created, so it is already partway when the toast lands. To avoid a
visible flicker (bar finishing before the toast has even settled, or cutting
into the exit), `duration` is automatically raised to at least
`2 × animDuration` (entrance + exit) whenever the requested value is shorter.

```autohotkey
; Bar runs from creation; 200ms becomes 600ms (2 × 300ms anim)
Toastify.Show("Title", "Body", , {
    showProgress: true,
    progressBarWaitPosition: false,
    animDuration: 300,
    duration: 200,
})
```

## Themes

56 built-in themes (28 palettes × dark/light) plus `"auto"`, which follows
the Windows app theme (`AppsUseLightTheme`):

`dark`, `light`, `success`, `error`, `warning`, `info`, `midnight`, `forest`,
`neon`, `vapor`, `cyberpunk`, `retro`, `glass`, `minimal`, `pastel`, `flat`,
`dracula`, `tokyo-night`, `catppuccin-mocha`, `catppuccin-latte`, `nord`,
`solarized`, `gruvbox`, `one-dark`, `one-light`, `synthwave`, `monokai`,
`material-you`, `carbon`, `ayu`.

Neon-themed palettes (`neon`, `vapor`, `cyberpunk`, `synthwave`) enable an
outer glow by default (`glow: true` → wider shadow spread).

### Custom themes

```autohotkey
Toastify.RegisterTheme("ocean", {
    bg1: 0xEE0F2025,    bg2: 0xEE0A1520,
    fg: 0xFF93C5FD,     accent: 0xFF0EA5E9,
    shadow: 0x66000000,  progress: 0xFF0EA5E9,
})
```

| Key | Required | Purpose |
|---|---|---|
| `bg1`, `bg2` | yes | Gradient background |
| `fg` | yes | Title/body text color |
| `accent` | yes | Buttons, progress fill, highlights |
| `shadow` | yes | Drop shadow color |
| `progress` | no | Progress bar fill; defaults to accent |
| `progressBg` | no | Progress bar track; auto-derived if omitted (33% white on dark, 20% black on light) |
| `border` | no | Border color; defaults to accent at 80% |
| `borderWidth` | no | Border thickness; `0` for glass/minimal/flat |
| `gradientType` | no | `"linear"` (default) or `"radial"` (baked concentric rings) |
| `gradientAngle` | no | Linear gradient angle in degrees; `90` = top→bottom |
| `glow` | no | `true` → wider soft shadow spread (neon look) |

Button label contrast and progress-bar track/fill contrast are computed
automatically for every theme, including custom ones.

### Indeterminate progress

With `indeterminate: true` the bar fills smoothly 0→100% in a loop and never
completes; `autoDismiss` is forced off. Combine with `progressStriped` for a
scrolling marquee effect.

## Demo

`simple_test.ahk` shows a fully randomized demo: every toast gets random
Windows actions (Notepad, Calculator, voice, clipboard, Settings, Explorer,
Task Manager, mute, ...), random buttons, animation, easing, entrance, theme,
alignment (including per-toast overrides), duration, and opacity.

## Tests

Automated harnesses in `tests/` (run with `AutoHotkeyUX.exe tests\<name>.ahk`;
each writes `%TEMP%\toastify_<name>_result.txt` and exits `0`/`1`):

| Harness | What it checks |
|---|---|
| `stress.ahk` | Reflow storms, `maxToasts` eviction, case-sensitive tag dedupe, `DismissGroup`, 200 `Show`/`Dismiss` cycles with empty registry |
| `leak.ahk` | GDI + USER handle deltas and working set over 200 worst-case cycles (icons, striped progress, actions) |
| `dllcall.ahk` | DPI math tables, work-area rects, live `GetDpiForWindow`, `TrackMouseEvent`/`HIGHCONTRAST` struct sizes, easing resolver |
| `bench.ahk` | Entrance-animation fps/avg/p95 across the Low/Medium/High × 1/3-toast matrix (fails on p95 > 35ms), CSV report |

## Changelog

### Unreleased — reliability hardening

- **Correctness.** Fixed `TRACKMOUSEEVENT` struct size (24 bytes on x64),
  `HIGHCONTRASTW` (16 bytes), `SetWindowLongPtr` return check with
  `SW_RESTORE` fallback, `PlaySoundW` Unicode alias, DPI helper signatures
  (real `POINT` structs, explicit out-pointers, declared return types), and
  return-value checks on `GetMonitorInfo`/`SystemParametersInfo`.
- **Zero leaks.** `ResizeBuffer` now rebuilds every derivative cache (no more
  stale-size bitmaps after `WM_DPICHANGED`); removed dead brushes, pens, and
  fields; `Shutdown` unregisters `OnMessage` handlers and the `Esc` hotkey,
  clears the theme map, and never throws from `OnExit`; 1s sweep reaps
  externally-destroyed windows while suspended; `try/finally` on snapshots.
- **Races and state.** `StartExit` kills the repo animation (no 1-frame
  jitter); clone-and-try enumeration in the tick and click paths; case-sensitive
  tags; `SetEscEnabled()` live toggle; unified QPC progress clock (no more
  phantom 60Hz redraws); button div/0 guards; stagger-aware progress start.
- **Multi-monitor / DPI.** Cursor-anchored fallback instead of assuming `(0,0)`,
  per-toast DPI correction after layout, exit anchored to the target monitor,
  guarded DPI-awareness init, close-button theme invalidation, `Invalidate`
  shrink support.
- **Performance.** Easing `Func` resolved once per toast, inline hover cubic,
  cached stripe pen, `SetInterpolationMode` set once, static cursor buffers,
  quickselect p95 in telemetry. Steady ~64fps entrance animation.
- **Themes and tools.** Strict `RegisterTheme` validation with
  `ParseARGB("#RGB/#RRGGBB/#AARRGGBB")`, unknown-theme debug notice,
  `ShowView` unified through the standard creation path (dedupe, eviction,
  DPI, stagger), `theme_generator` codegen fixes.

## License

MIT © 2025 Julian — see [LICENSE](LICENSE).