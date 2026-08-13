# Toastify — AHKv2 Toast Notifications

A lightweight, GDI+-powered toast notification library for AutoHotkey v2.0. Zero dependencies beyond the vendored GDI+ wrapper.

- Native layered windows, always-on-top, no external DLLs
- GDI+ rendering: gradients, rounded corners, shadows, emoji support
- Per-monitor DPI aware (content unscaled — DWM handles scaling)
- 60 Hz animation loop, auto power-down to 0% CPU when idle
- 30 built-in themes, custom themes supported
- Action buttons, icons, live progress bar, hover interactions
- Per-toast alignment override on top of the global position

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
- DPI awareness enabled automatically

## Global Setup

```autohotkey
Toastify.Start(theme := "dark", position := "top-right")
```

`Start` is idempotent — safe to call repeatedly; it only re-applies theme/position.

```autohotkey
; Global defaults for all toasts
Toastify.SetConfig({
    width: 340,
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
| `Toastify.maxToasts` | `8` | Hard cap; oldest toast exits when exceeded |

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
| `Toastify.DismissAll()` | Dismiss all visible toasts |

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
| `position` | string | global | Per-toast alignment override |
| `icon` | string | `""` | `"success"`, `"error"`, `"warning"`, `"info"` |
| `width` | int | `340` | Toast width |
| `animStyle` | array/string | `["slide"]` | 1-4 of the ANIM_STYLE values |
| `animEasing` | string | `"easeOutCubic"` | Any EASING value |
| `animEntrance` | string | `"auto"` | `AUTO` resolves from position |
| `animDuration` | int (ms) | `300` | In/out animation length |
| `repoDuration` | int (ms) | `300` | Reorder animation length |
| `onClick` | callback | — | Fires when toast body clicked (not buttons) |
| `onClose` | callback | — | Fires when toast is closed |

## Constants

| Constant | Values |
|---|---|
| `Toastify.ALIGN` | `TOP_LEFT`, `TOP_RIGHT`, `BOTTOM_LEFT`, `BOTTOM_RIGHT`, `LEFT`, `RIGHT`, `TOP`, `BOTTOM`, `CENTER` |
| `Toastify.ANIM_STYLE` | `SLIDE`, `FADE`, `ZOOM`, `ROTATE` |
| `Toastify.ENTRANCE` | `AUTO`, `LEFT`, `RIGHT`, `TOP`, `BOTTOM` |
| `Toastify.EASING` | `LINEAR`, `EASE_OUT_CUBIC`, `BOUNCE_IN`, `BOUNCE_OUT`, `ELASTIC_OUT`, `DECELERATE`, and 30+ more |
| `Toastify.THEMES` | `DARK`, `LIGHT`, `SUCCESS`, `ERROR`, `WARNING`, `INFO`, `NEON`, `VAPOR`, `CYBERPUNK`, `RETRO`, `GLASS`, `MINIMAL`, `PASTEL`, `FLAT`, `MIDNIGHT`, `FOREST` (each with `_LIGHT` variant) |
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

> **Known issue:** `ROTATE`/`ZOOM` animations may briefly flicker a dark background.
> Caused by a misconfigured container-window size during the transform frames.

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
t.position := Toastify.ALIGN.TOP_LEFT   ; Move it live (reflow applies)
```

## Hover Behavior

- Auto-dismiss timers **pause while hovered** and resume on leave
  (`Toastify.hoverPauseEnabled`, default `true`).
- With `opacityOnHover: true`, a semi-transparent toast (`opacity: 0.5`)
  smoothly fades to 100% while hovered and back on leave. Direction changes
  are evaluated every frame — no stutter on fast in/out.
- Close button shows a highlight halo on hover.
- A periodic rect check clears stuck hover state (WM_MOUSELEAVE on layered
  windows is unreliable).

## Themes

30 built-in themes, each with a `_LIGHT` variant:

`dark`, `light`, `success`, `error`, `warning`, `info`, `midnight`, `forest`,
`neon`, `vapor`, `cyberpunk`, `retro`, `glass`, `minimal`, `pastel`, `flat`.

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

Button label contrast and progress-bar track/fill contrast are computed
automatically for every theme, including custom ones.

## Demo

`simple_test.ahk` shows a fully randomized demo: every toast gets random
Windows actions (Notepad, Calculator, voice, clipboard, Settings, Explorer,
Task Manager, mute, ...), random buttons, animation, easing, entrance, theme,
alignment (including per-toast overrides), duration, and opacity.

## License

MIT © 2025 Julian — see [LICENSE](LICENSE).