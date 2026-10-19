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
try {
    if !DllCall("SetThreadDpiAwarenessContext", "ptr", -4, "ptr")   ; PMv2, Win10 1703+
        if !DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")   ; PMv1 fallback, Win10 1607+
            DllCall("SetProcessDPIAware")                                ; Win7/8 fallback
}

class ToastDPI {

    ; ── cache hMon → dpi ──
    ;    GetDpiForMonitor es caro para llamarlo en cada toast; el valor solo
    ;    cambia con WM_DPICHANGED, que lo invalida (ver ClearCache).
    static _dpiCache := Map()

    static ClearCache() => ToastDPI._dpiCache.Clear()

    ; ── DPI of the monitor hosting a window ─────────────────
    static ForWindow(hwnd) {
        try
            dpi := DllCall("GetDpiForWindow", "ptr", hwnd, "uint")
        catch
            dpi := 0
        return (dpi > 0) ? dpi : 96
    }

    ; ── DPI of the point (x,y) on screen ────────────────────
    static ForPoint(x, y) {
        x := Integer(Round(x)), y := Integer(Round(y))
        pt := Buffer(8, 0)
        NumPut("int", x, pt, 0), NumPut("int", y, pt, 4)
        hMon := DllCall("MonitorFromPoint", "ptr", pt, "UInt", 2, "Ptr")
        return ToastDPI._DpiFromMonitor(hMon)
    }

    ; ── DPI of the primary monitor ───────────────────────────
    static Primary() {
        pt := Buffer(8, 0)
        hMon := DllCall("MonitorFromPoint", "ptr", pt, "UInt", 1, "Ptr")
        return ToastDPI._DpiFromMonitor(hMon)
    }

    ; ── scale factor (float) ─────────────────────────────────
    ;    scale(96)=1.0  scale(120)=1.25  scale(192)=2.0
    static Factor(dpi) => dpi / 96.0

    ; ── converts design points → physical px ─────────────────
    ;    Always uses Round() to avoid fractional px.
    static Px(designPts, dpi) => Round(designPts * dpi / 96)

    ; ── private: MONITORINFO for the monitor containing (x,y) ──
    ;    Returns {hMon, info}; info is 0 if GetMonitorInfo failed.
    static _GetMonitorInfo(x, y) {
        x := Integer(Round(x)), y := Integer(Round(y))
        pt := Buffer(8, 0)
        NumPut("int", x, pt, 0), NumPut("int", y, pt, 4)
        hMon := DllCall("MonitorFromPoint", "ptr", pt, "UInt", 2, "Ptr")
        info := Buffer(40, 0)
        NumPut("uint", 40, info, 0)     ; cbSize
        if (!DllCall("GetMonitorInfo", "ptr", hMon, "ptr", info))
            return { hMon: hMon, info: 0 }
        return { hMon: hMon, info: info }
    }

    ; ── work area of the monitor containing (x,y) ────────────
    ;    Returns {x,y,w,h} in physical px (global coordinates)
    static WorkArea(x := 0, y := 0) {
        mi := ToastDPI._GetMonitorInfo(x, y)
        if (!mi.info)
            return { x: 0, y: 0, w: A_ScreenWidth, h: A_ScreenHeight }
        info := mi.info
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
        mi := ToastDPI._GetMonitorInfo(x, y)
        if (!mi.info)
            return { x: 0, y: 0, w: A_ScreenWidth, h: A_ScreenHeight }
        info := mi.info
        return {
            x: NumGet(info, 4, "int"),
            y: NumGet(info, 8, "int"),
            w: NumGet(info, 12, "int") - NumGet(info, 4, "int"),
            h: NumGet(info, 16, "int") - NumGet(info, 8, "int")
        }
    }

    ; ── cursor position (fallback anchor when no toast exists yet) ──
    static CursorPoint() {
        pt := Buffer(8, 0)
        try {
            if (DllCall("GetCursorPos", "ptr", pt))
                return { x: NumGet(pt, 0, "int"), y: NumGet(pt, 4, "int") }
        }
        return { x: 0, y: 0 }
    }

    ; ── private: DPI of an HMONITOR ──────────────────────────
    static _DpiFromMonitor(hMon) {
        if (ToastDPI._dpiCache.Has(hMon))
            return ToastDPI._dpiCache[hMon]
        pX := Buffer(4, 0)
        pY := Buffer(4, 0)
        ; MDT_EFFECTIVE_DPI = 0
        try {
            if !DllCall("Shcore\GetDpiForMonitor",
                "ptr", hMon, "uint", 0,
                "ptr", pX.Ptr, "ptr", pY.Ptr, "HRESULT") {
                dpi := NumGet(pX, 0, "uint")
                ToastDPI._dpiCache[hMon] := dpi
                return dpi
            }
        }
        ; fallback
        hdc := DllCall("GetDC", "ptr", 0, "ptr")
        dpi := DllCall("gdi32\GetDeviceCaps", "ptr", hdc, "int", 88, "int")
        DllCall("ReleaseDC", "ptr", 0, "ptr", hdc)
        dpi := (dpi > 0) ? dpi : 96
        ToastDPI._dpiCache[hMon] := dpi
        return dpi
    }
}