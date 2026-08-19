#Requires AutoHotkey v2.0
#Include lib\Toastify.ahk

out := "C:\Users\July\AppData\Local\Temp\toastify_perf_result.txt"
try FileDelete(out)
Log(line) => FileAppend(line "`n", out)
Fail(msg) {
    Log("FAIL: " msg)
    ExitApp(1)
}

GetGdi() => DllCall("GetGuiResources", "ptr", DllCall("GetCurrentProcess", "ptr"), "uint", 0, "uint")

Toastify.Start("dark", "top-right")

; ── B1: ventana destruida externamente → watchdog limpia instancia ──
t := Toastify.Show("dead-hwnd", "leak check", [], { duration: 5000 })
DllCall("DestroyWindow", "ptr", t.hwnd)
Sleep 700
if (Toastify.toasts.Length != 0)
    Fail("B1: toast no salio de toasts (len=" Toastify.toasts.Length ")")
if (Toastify.registry.Count != 0)
    Fail("B1: registry no limpio (count=" Toastify.registry.Count ")")
Log("B1 ok: dead-window limpiado")

; ── Leak stress: GDI handles antes/despues ──
themes := ["dark", "light", "success", "error", "warning", "info", "neon", "glass", "minimal"]
styles := [["slide"], ["fade"], ["zoom"], ["rotate"], ["slide", "fade"], ["zoom", "rotate"]]
Sleep 300
g0 := GetGdi()
loop 60 {
    opts := { theme: themes[Mod(A_Index, themes.Length) + 1]
        , animStyle: styles[Mod(A_Index, styles.Length) + 1]
        , icon: "success", duration: 40, showProgress: Mod(A_Index, 2) = 0
        , actions: Mod(A_Index, 3) = 0 ? [{ text: "A", onClick: (*) => {} }] : [] }
    tt := Toastify.Show("stress", "leak", opts.actions, opts)
    tt.Dismiss(true)
    if (Mod(A_Index, 10) = 0)
        Sleep 50
}
Sleep 500
g1 := GetGdi()
delta := g1 - g0
Log("GDI delta: " delta)
if (delta > 8)
    Fail("leak: GDI crecio " delta " handles")
Log("leak ok: delta " delta)

; ── Tri-estado: toast quieto → semi-idle, sin perf mode ──
Toastify.Show("quiet", "permanent", [], { duration: 0, showProgress: false, autoDismiss: false })
Sleep 400
if (Toastify.__perfFast)
    Fail("tri-state: quiet toast no bajo a semi-idle")
Log("tri-state ok: semi-idle sin perf mode")
Toastify.DismissAll()
Sleep 300

; ── FPS: 3 toasts animando + progress + reflow ──
loop 3
    Toastify.Show("fps " A_Index, "moviendose", [], { animStyle: ["slide", "fade"], animDuration: 900
        , duration: 1800, showProgress: true, position: "top-right" })
Sleep 400
Toastify.__frameStats := []  ; descarta spikes de creación de toasts
Sleep 600
s := Toastify.FPS()
Log("FPS: " s.fps " avg=" s.avg " p95=" s.p95 " max=" s.max " n=" s.samples)
if (s.p95 > 35)
    Fail("fps: p95 " s.p95 " > 35ms")
Log("fps ok: p95 " s.p95 "ms")

Sleep 2500
Log("ALL_OK")
ExitApp(0)