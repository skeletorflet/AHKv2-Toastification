# Toastification – A Modern Toast Notification Library for AutoHotkey v2

> **Quickly add beautiful, animated toast notifications to your AHK scripts**

---

## 📦 What is Toastification?

Toastification is a lightweight, dependency‑free AutoHotkey v2 library that provides a fully‑featured toast notification system built on GDI+. It supports:

- Multiple themes (light, dark, success, error, warning, info)
- Customizable position (`top‑right`, `bottom‑right`, `top‑left`, `bottom‑left`)
- Adjustable duration, size, fonts and animation curves
- Action buttons, progress bar, close button, and hover‑pause
- Automatic handling of max toast count and graceful exit animations

---

## 🚀 Quick Start

1. **Include the library** in your script (the library files are located in `lib/`):
   ```ahk
   #Include lib/Toastification.ahk
   ```
2. **Initialize** the system (once per script):
   ```ahk
   Toastify.Start("dark", "top-right")   ; theme, position
   ```
3. **Show a toast**:
   ```ahk
   Toastify.Success("Upload complete", "Your files have been uploaded.")
   ```
   That's it – a dark‑themed success toast will appear in the top‑right corner.

---

## 📚 API Overview

### Core Methods
| Method | Description |
|--------|-------------|
| `Toastify.Show(title, body, actions?, opts?)` | Create a generic toast. |
| `Toastify.Success(title, body?, actions?, opts?)` | Shortcut for a success‑styled toast. |
| `Toastify.Error(title, body?, actions?, opts?)` | Shortcut for an error‑styled toast. |
| `Toastify.Warning(title, body?, actions?, opts?)` | Shortcut for a warning‑styled toast. |
| `Toastify.Info(title, body?, actions?, opts?)` | Shortcut for an info‑styled toast. |
| `Toastify.Custom(opts)` | Full control – pass an options map with any properties. |
| `Toastify.DismissAll()` | Close every active toast immediately. |
| `Toastify.ShowView(viewItems, opts?)` | Display a custom view (e.g., a list) inside a toast. |

### Options (`opts` map)
| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `theme` | string | current theme | Overrides the toast theme (`"dark"`, `"light"`, `"success"`, …). |
| `position` | string | current position | Overrides screen position (`"top-right"`, `"bottom-left"`, …). |
| `duration` | integer | `3000` ms | How long the toast stays before auto‑dismiss. |
| `width` | integer | `340` px | Width of the toast window. |
| `icon` | string | `""` | Path to a custom icon (overrides theme icon). |
| `showClose` | boolean | `true` | Show the close‑button. |
| `showProgress` | boolean | `true` | Show a progress bar that fills over `duration`. |
| `animDuration` | integer | `300` ms | Length of entrance/exit animation. |
| `animEasing` | string | `"easeOutCubic"` | Name of an easing function from `ToastEasing`. |
| `onClick` | function | `null` | Callback when the toast body is clicked. |
| `onClose` | function | `null` | Callback when the close‑button is clicked. |

### Configuration
You can change the global defaults via `Toastify.SetConfig(cfg)` where `cfg` is an instance of `ToastConfig`. Example:
```ahk
cfg := ToastConfig()
cfg.fontName := "Inter"
cfg.fontSizeTitle := 18
cfg.fontSizeBody := 14
cfg.animDuration := 400
Toastify.SetConfig(cfg)
```
All properties listed in the `ToastConfig` class are configurable (fonts, sizes, padding, etc.).

### Theming
Register custom palettes with `Toastify.RegisterTheme(name, palette)`. A palette is a map with the following keys:
- `bg1`, `bg2` – gradient background colors
- `fg` – text color
- `accent` – border / button color
- `shadow` – window shadow color
- `progress` – progress‑bar color

```ahk
myPalette := {bg1: 0xEE2A2A2A, bg2: 0xEE1F1F1F, fg: 0xFFFFFFFF, accent: 0xFF00C0FF, shadow: 0x55000000, progress: 0xFF00C0FF}
Toastify.RegisterTheme("myTheme", myPalette)
Toastify.Start("myTheme")
```

---

## 🛠️ Advanced Usage

- **Action Buttons** – Pass an array of objects `{label: "Retry", onClick: Func("RetryHandler")}` as the `actions` argument.
- **Custom Views** – Use `Toastify.ShowView(viewItems)` to embed a ListView, Grid, or any custom UI inside a toast.
- **Hover Pause** – Set `Toastify.hoverPauseEnabled := true` (default) to pause the progress bar while the mouse hovers over the toast.

---

## 📦 Installation

1. Clone the repository or copy the `lib/` folder into your project.
2. Ensure you have **AutoHotkey v2** installed.
3. Include the main file as shown in the Quick Start.

---

## 📜 License

Toastification is released under the MIT License. Feel free to use, modify, and distribute it in both personal and commercial projects.

---

## 🙋‍♀️ Support & Contributions

If you encounter bugs or have feature ideas, open an issue on the GitHub repo. Pull requests are welcome!
