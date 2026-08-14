; ============================================================
;  ToastDPI  –  complete DPI handling
;  Strategy:
;    • The process/thread is declared Per-Monitor v2 aware.
;    • All public config (width, padding, font…) is expressed
;      in "design points" at 96 DPI (1×).
;    • ToastDPI.Px(dpi) converts design points → physical px
;      using the REAL DPI of that monitor.
;    • A_ScreenWidth/Height is replaced by
;      ToastDPI.WorkArea(monitor) → correct physical rect.
;    • GDI+ buffers always work in physical px.
;    • Window positions passed to the Win32 API are always
;      physical px (correct for layered windows).
; ============================================================

; ── DPI awareness: activate Per-Monitor v2 on the thread ──
; AHK64 v2 only declares system-aware in its manifest; without
; this, GetDpiForMonitor returns virtualized DPI (96) and layered
; windows (UpdateLayeredWindow) are not bitmap-scaled by DWM
; → toasts render at design size (tiny on 200%).
; Top-level: runs at #Include time, before any window/GDI+ init.
DllCall("SetThreadDpiAwarenessContext", "ptr", -4, "ptr")   ; PMv2, Win10 1703+
DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")   ; PMv1 fallback, Win10 1607+
DllCall("SetProcessDPIAware")                                ; Win7/8 fallback

class ToastDPI {

    ; ── one-time init ────────────────────────────────────────
    static _ready := false

    static Init() {
        if ToastDPI._ready
            return
        ; Awareness was already enabled above (top-level, at #Include).
        ; Nothing else to do here.
        ToastDPI._ready := true
    }

    ; ── DPI of the monitor hosting a window ─────────────────
    static ForWindow(hwnd) {
        dpi := DllCall("GetDpiForWindow", "ptr", hwnd, "uint")
        return (dpi > 0) ? dpi : 96
    }

    ; ── DPI of the point (x,y) on screen ────────────────────
    static ForPoint(x, y) {
        pt := Buffer(8, 0)
        NumPut("int", x, pt, 0)
        NumPut("int", y, pt, 4)
        hMon := DllCall("MonitorFromPoint", "ptr", pt, "uint", 2, "ptr")
        return ToastDPI._DpiFromMonitor(hMon)
    }

    ; ── DPI of the primary monitor ───────────────────────────
    static Primary() {
        hMon := DllCall("MonitorFromPoint", "ptr", Buffer(8, 0), "uint", 1, "ptr")
        return ToastDPI._DpiFromMonitor(hMon)
    }

    ; ── scale factor (float) ─────────────────────────────────
    ;    scale(96)=1.0  scale(120)=1.25  scale(192)=2.0
    static Factor(dpi) => dpi / 96.0

    ; ── converts design points → physical px ─────────────────
    ;    Always uses Round() to avoid fractional px.
    static Px(designPts, dpi) => Round(designPts * dpi / 96)

    ; ── work area of the monitor containing (x,y) ────────────
    ;    Returns {x,y,w,h} in physical px (global coordinates)
    static WorkArea(x := 0, y := 0) {
        pt := Buffer(8, 0)
        NumPut("int", x, pt, 0)
        NumPut("int", y, pt, 4)
        hMon := DllCall("MonitorFromPoint", "ptr", pt, "uint", 2, "ptr")
        info := Buffer(40, 0)
        NumPut("uint", 40, info, 0)     ; cbSize
        DllCall("GetMonitorInfo", "ptr", hMon, "ptr", info)
        ; rcWork starts at offset 20 (after 16-byte rcMonitor + 4-byte cbSize)
        ; Layout: cbSize(4) rcMonitor(16) rcWork(16) dwFlags(4)
        return {
            x: NumGet(info, 20, "int"),
            y: NumGet(info, 24, "int"),
            w: NumGet(info, 28, "int") - NumGet(info, 20, "int"),
            h: NumGet(info, 32, "int") - NumGet(info, 24, "int")
        }
    }

    ; ── full monitor rect (not work area) ────────────────────
    static MonitorRect(x := 0, y := 0) {
        pt := Buffer(8, 0)
        NumPut("int", x, pt, 0)
        NumPut("int", y, pt, 4)
        hMon := DllCall("MonitorFromPoint", "ptr", pt, "uint", 2, "ptr")
        info := Buffer(40, 0)
        NumPut("uint", 40, info, 0)
        DllCall("GetMonitorInfo", "ptr", hMon, "ptr", info)
        return {
            x: NumGet(info, 4, "int"),
            y: NumGet(info, 8, "int"),
            w: NumGet(info, 12, "int") - NumGet(info, 4, "int"),
            h: NumGet(info, 16, "int") - NumGet(info, 8, "int")
        }
    }

    ; ── private: DPI of an HMONITOR ──────────────────────────
    static _DpiFromMonitor(hMon) {
        dpiX := 0, dpiY := 0
        pX := Buffer(4, 0)
        pY := Buffer(4, 0)
        ; MDT_EFFECTIVE_DPI = 0
        if !DllCall("Shcore\GetDpiForMonitor",
            "ptr", hMon, "uint", 0,
            "ptr", pX, "ptr", pY, "hresult") {
            return NumGet(pX, 0, "uint")
        }
        ; fallback
        hdc := DllCall("GetDC", "ptr", 0, "ptr")
        dpi := DllCall("gdi32\GetDeviceCaps", "ptr", hdc, "int", 88)
        DllCall("ReleaseDC", "ptr", 0, "ptr", hdc)
        return (dpi > 0) ? dpi : 96
    }
}