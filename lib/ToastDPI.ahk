; ============================================================
;  ToastDPI  –  reemplazo completo del handling de DPI
;  Estrategia:
;    • El proceso se declara Per-Monitor v2 aware.
;    • Toda la configuración pública (width, padding, font…)
;      se expresa en "puntos de diseño" a 96 DPI (1×).
;    • ToastDPI.Scale(monitor) convierte puntos → px físicos
;      usando el DPI real de ESE monitor.
;    • A_ScreenWidth/Height se reemplaza por
;      ToastDPI.WorkArea(monitor) → rect físico correcto.
;    • Los buffers GDI+ siempre trabajan en px físicos.
;    • Las posiciones de ventana que se pasan a la API de Win32
;      son siempre px físicos (correcto para layered windows).
; ============================================================

class ToastDPI {

    ; ── inicialización única ────────────────────────────────
    static _ready := false

    static Init() {
        if ToastDPI._ready
            return
        ; AHK64 tiene manifest propio que ya declara DPI awareness.
        ; No intentar sobreescribir - falla silenciosamente y causa
        ; que GetDpiForWindow devuelva valores incorrectos.
        ToastDPI._ready := true
    }


    ; ── DPI de un monitor dado el HWND de una ventana ──────
    static ForWindow(hwnd) {
        dpi := DllCall("GetDpiForWindow", "ptr", hwnd, "uint")
        return (dpi > 0) ? dpi : 96
    }

    ; ── DPI del punto (x,y) en pantalla ────────────────────
    static ForPoint(x, y) {
        pt := Buffer(8, 0)
        NumPut("int", x, pt, 0)
        NumPut("int", y, pt, 4)
        hMon := DllCall("MonitorFromPoint", "ptr", pt, "uint", 2, "ptr")
        return ToastDPI._DpiFromMonitor(hMon)
    }

    ; ── DPI del monitor primario ────────────────────────────
    static Primary() {
        hMon := DllCall("MonitorFromPoint", "ptr", Buffer(8, 0), "uint", 1, "ptr")
        return ToastDPI._DpiFromMonitor(hMon)
    }

    ; ── factor de escala (float) ────────────────────────────
    ;    scale(96)=1.0  scale(120)=1.25  scale(192)=2.0
    static Factor(dpi) => dpi / 96.0

    ; ── convierte puntos de diseño → px físicos ─────────────
    ;    Siempre usa Round() para evitar px fraccionarios.
    static Px(designPts, dpi) => Round(designPts * dpi / 96)

    ; ── área de trabajo del monitor que contiene (x,y) ──────
    ;    Devuelve {x,y,w,h} en px físicos (coordenadas globales)
    static WorkArea(x := 0, y := 0) {
        pt := Buffer(8, 0)
        NumPut("int", x, pt, 0)
        NumPut("int", y, pt, 4)
        hMon := DllCall("MonitorFromPoint", "ptr", pt, "uint", 2, "ptr")
        info := Buffer(40, 0)
        NumPut("uint", 40, info, 0)     ; cbSize
        DllCall("GetMonitorInfo", "ptr", hMon, "ptr", info)
        ; rcWork empieza en offset 20 (tras rcMonitor de 16 bytes + cbSize de 4)
        ; Layout: cbSize(4) rcMonitor(16) rcWork(16) dwFlags(4)
        return {
            x: NumGet(info, 20, "int"),
            y: NumGet(info, 24, "int"),
            w: NumGet(info, 28, "int") - NumGet(info, 20, "int"),
            h: NumGet(info, 32, "int") - NumGet(info, 24, "int")
        }
    }

    ; ── rect completo del monitor (no work area) ────────────
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

    ; ── privado: DPI de un HMONITOR ────────────────────────
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