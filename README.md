# Toastify — AHKv2 Toast Notifications

A lightweight, GDI+-powered toast notification library for AutoHotkey v2.0. Zero dependencies beyond the vendored GDI+ wrapper.

## Quick Start

```autohotkey
#Include lib\Toastify.ahk

; Initialize with position
Toastify.Start("dark", Toastify.ALIGN.BOTTOM_RIGHT)

; Show a toast
Toastify.Success("Saved!", "Your changes are safe.")
```

## Ergonomic API

Set options on individual toasts via autocomplete-friendly constants:

```autohotkey
Toastify.Show("Hello", "World", , {
    animStyle: [Toastify.ANIM_STYLE.ZOOM, Toastify.ANIM_STYLE.SLIDE],
    animEasing: Toastify.EASING.BOUNCE_OUT,
    animEntrance: Toastify.ENTRANCE.LEFT,
    animDuration: 800,
    duration: 4000,
})
```

### Constants

| Constant | Values |
|---|---|
| `Toastify.ALIGN` | `TOP_LEFT`, `TOP_RIGHT`, `BOTTOM_LEFT`, `BOTTOM_RIGHT`, `LEFT`, `RIGHT`, `TOP`, `BOTTOM`, `CENTER` |
| `Toastify.ANIM_STYLE` | `SLIDE`, `FADE`, `ZOOM`, `ROTATE` |
| `Toastify.ENTRANCE` | `AUTO`, `LEFT`, `RIGHT`, `TOP`, `BOTTOM` |
| `Toastify.EASING` | `LINEAR`, `EASE_OUT_CUBIC`, `BOUNCE_IN`, `BOUNCE_OUT`, `ELASTIC_OUT`, `DECELERATE`, and 30+ more |
| `Toastify.THEMES` | `DARK`, `LIGHT`, `SUCCESS`, `ERROR`, `WARNING`, `INFO`, `NEON`, `VAPOR`, `CYBERPUNK`, `RETRO`, `GLASS`, `MINIMAL`, `PASTEL`, `FLAT`, `MIDNIGHT`, `FOREST` (each with `_LIGHT` variant) |
| `Toastify.QUALITY` | `LOW`, `MEDIUM`, `HIGH` |
| `Toastify.PRIORITY` | `IDLE`, `BELOW_NORMAL`, `NORMAL`, `ABOVE_NORMAL`, `HIGH`, `REALTIME` |

## Global Setup

```autohotkey
Toastify.Start(theme := "dark", position := "top-right")

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
    renderQuality: "High",
})
```

## Show Methods

| Method | Description |
|---|---|
| `Toastify.Show(title, body, actions?, opts?)` | Generic toast |
| `Toastify.Success(title, body?, actions?, opts?)` | Green success toast |
| `Toastify.Error(title, body?, actions?, opts?)` | Red error toast |
| `Toastify.Warning(title, body?, actions?, opts?)` | Orange warning toast |
| `Toastify.Info(title, body?, actions?, opts?)` | Blue info toast |
| `Toastify.Custom(opts)` | Full control via single object |
| `Toastify.ShowView(viewItems, opts?)` | Custom GDI+ rendered views |
| `Toastify.DismissAll()` | Dismiss all visible toasts |

## Per-Toast Options

```autohotkey
Toastify.Show("Title", "Body", [], {
    width: 400,                      ; Toast width
    duration: 3000,                  ; Auto-dismiss time (ms); 0 = permanent
    theme: "success",                ; Theme name
    position: "bottom-right",        ; Screen corner
    icon: "success",                 ; Icon preset ("success", "error", "warning", "info")
    showClose: true,                 ; Show close button
    showProgress: true,              ; Show progress bar
    permanent: false,                ; Never auto-dismiss
    autoDismiss: true,               ; Allow auto-dismiss when progress completes
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

### Animation Mixing

Combine up to 4 animation styles for compound effects:

```autohotkey
animStyle: [Toastify.ANIM_STYLE.SLIDE, Toastify.ANIM_STYLE.FADE, Toastify.ANIM_STYLE.ZOOM, Toastify.ANIM_STYLE.ROTATE]
```

## Actions & Callbacks

```autohotkey
Toastify.Show("Update Available", "v2.1.0 is ready.", [
    {text: "Update", onClick: (*) => Run("updater.exe")},
    {text: "Later", onClick: (*) => MsgBox("Snoozed")},
])
```

## Custom Themes

```autohotkey
Toastify.RegisterTheme("ocean", {
    bg1: 0xEE0F2025,    bg2: 0xEE0A1520,
    fg: 0xFF93C5FD,     accent: 0xFF0EA5E9,
    shadow: 0x66000000,  progress: 0xFF0EA5E9,
})
```

## Hover Behavior

Toast timers pause on hover and resume on leave. Close button highlights on hover. Progress bars are live.

## Requirements

- AutoHotkey v2.0+
- Windows Vista+
- DPI awareness enabled (automatic)

## License

MIT © 2025 Julian — see [LICENSE](LICENSE).
