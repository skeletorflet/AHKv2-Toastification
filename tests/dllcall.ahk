#Requires AutoHotkey v2.0
#Include ..\lib\Toastify.ahk

; DllCall correctness: DPI math, work areas, firmas criticas.
out := EnvGet("TEMP") "\toastify_dllcall_result.txt"
try FileDelete(out)
Log(line) => FileAppend(line "`n", out)
Fail(msg) {
    Log("FAIL: " msg)
    ExitApp(1)
}
Assert(cond, msg) {
    if (!cond)
        Fail(msg)
    Log("ok: " msg)
}

; ── Px table ──
Assert(ToastDPI.Px(100, 96) = 100, "Px 96")
Assert(ToastDPI.Px(100, 120) = 125, "Px 120")
Assert(ToastDPI.Px(100, 144) = 150, "Px 144")
Assert(ToastDPI.Px(100, 192) = 200, "Px 192")
Assert(ToastDPI.Factor(96) = 1.0, "Factor 96")

; ── WorkArea / MonitorRect sanos ──
wa := ToastDPI.WorkArea(0, 0)
Assert(wa.w > 0 && wa.h > 0, "WorkArea(0,0) w/h>0")
cp := ToastDPI.CursorPoint()
wa2 := ToastDPI.WorkArea(cp.x, cp.y)
Assert(wa2.w > 0 && wa2.h > 0, "WorkArea(cursor) w/h>0")
mr := ToastDPI.MonitorRect(cp.x, cp.y)
Assert(mr.w > 0 && mr.h > 0, "MonitorRect w/h>0")

; ── ForPoint == Primary en 1 monitor (o DPI>0 en N) ──
dpi := ToastDPI.ForPoint(cp.x, cp.y)
Assert(dpi >= 96 && dpi <= 768, "ForPoint dpi=" dpi)

; ── Toast real: GetDpiForWindow > 0 ──
Toastify.Start("dark", "top-right")
t := Toastify.Show("dll", "hwnd check", [], { duration: 3000 })
Assert(t.hwnd != 0 && DllCall("IsWindow", "ptr", t.hwnd), "hwnd vivo")
Assert(ToastDPI.ForWindow(t.hwnd) > 0, "GetDpiForWindow>0")

; ── TrackMouseEvent acepta struct sizeof=24 en x64 ──
tr := Buffer(24, 0)
NumPut("uint", 24, tr, 0)
NumPut("uint", 2, tr, 4)
NumPut("ptr", t.hwnd, tr, 8)
NumPut("uint", 0, tr, 16)
Assert(DllCall("TrackMouseEvent", "ptr", tr) != 0, "TrackMouseEvent(24B)")

; ── HIGHCONTRAST 16 bytes ──
hc := Buffer(16, 0)
NumPut("uint", 16, hc, 0)
Assert(DllCall("SystemParametersInfoW", "uint", 0x0042, "uint", 16, "ptr", hc, "uint", 0) != 0, "SPI HIGHCONTRAST")

; ── Easing resolve (sin dispatch dinamico) ──
fn := ToastEasing.resolve("easeOutCubic")
Assert(fn.Call(ToastEasing, 1.0) = 1.0, "easing(1)=1")
fn2 := ToastEasing.resolve("nope-missing")
Assert(fn2.Call(ToastEasing, 0.5) > 0, "easing fallback")

t.Dismiss(true)
Sleep 300
Log("ALL_OK")
ExitApp(0)
