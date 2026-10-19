#Requires AutoHotkey v2.0
#Include ..\lib\Toastify.ahk

; API: progress manual/top, ellipsis, overflow sin (0,0), telemetria real.
out := EnvGet("TEMP") "\toastify_api_result.txt"
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

Toastify.Start("dark", "top-right")

; ── Prioridad del host capturada (no se pisa con NORMAL) ──
Assert(Toastify.__origPriority != "", "priority del host detectada: " Toastify.__origPriority)

; ── SetProgress manual ──
t := Toastify.Show("p", "body", [], { duration: 0, indeterminate: true })
tt := Toastify.Show("q", "body", [], { duration: 10000, showProgress: true })
Sleep 300
tt.SetProgress(0.5)
Assert(tt._manualProgress, "SetProgress(0.5) toma control manual")
Assert(tt.HasProgress(), "HasProgress con progreso manual")
Assert(Abs(tt.progress - 0.5) < 0.001, "progress = 0.5")
tt.SetProgress(-1)
Assert(!tt._manualProgress, "SetProgress(-1) devuelve el control automatico")

; ── progressPos: top vs bottom ──
tb := Toastify.Show("top", "b", [], { duration: 10000, showProgress: true, progressPos: "top" })
Sleep 300
mt := tb.__metrics()
Assert(mt.barY < tb.height / 2, "progressPos=top: barY=" Round(mt.barY) " < h/2")
Assert(mt.textTop >= mt.barY + mt.barH, "top: el texto no pisa la barra")
bb := Toastify.Show("bot", "b", [], { duration: 10000, showProgress: true, progressPos: "bottom" })
Sleep 300
mb := bb.__metrics()
Assert(mb.barY > bb.height / 2, "progressPos=bottom: barY=" Round(mb.barY) " > h/2")

; ── Ellipsis en textos que no entran ──
long := "un titulo larguisimo que no entra ni de lejos en la tarjeta ancha"
bmp := Gdip_CreateBitmap(8, 8)
G := Gdip_GraphicsFromImage(bmp)
fit := bb.__fitText(G, long, 60, 20, 20, "Bold")
Assert(SubStr(fit, -1) = "…", "texto recortado termina en … (" fit ")")
Assert(bb.__fitText(G, "ok", 200, 60, 20, "Bold") = "ok", "texto corto sin cambios")
Gdip_DeleteGraphics(G)
Gdip_DisposeImage(bmp)

; ── Overflow: todos los toasts reciben target dentro del monitor ──
Toastify.KillAll()
Sleep 400
savedMin := Toastify.config.minHeight
Toastify.maxToasts := 30
Toastify.config.minHeight := 200
loop 12
    Toastify.Show("ov " A_Index, "b", [], { duration: 5000 })
Sleep 900
Assert(Toastify.toasts.Length <= Toastify.maxToasts, "len=" Toastify.toasts.Length " <= maxToasts")
r0 := Toastify.toasts[1]
wa := ToastDPI.WorkArea(r0.targetX, r0.targetY)
bad := 0
for x in Toastify.toasts {
    if (x.targetX = 0 && x.targetY = 0)
        bad++
    else if (x.targetY + x.height > wa.y + wa.h + 1)
        bad++
}
Assert(bad = 0, "ningun toast fuera de pantalla ni en (0,0) (n=" Toastify.toasts.Length ")")
Toastify.config.minHeight := savedMin
Toastify.maxToasts := 8
Toastify.KillAll()
Sleep 400

; ── Indeterminate (marquee) corre sin errores durante >1 ciclo ──
ind := Toastify.Show("ind", "b", [], { indeterminate: true, duration: 0 })
Sleep 1200
Assert(ind.indeterminate && ind.HasProgress(), "indeterminate activo tras 1.2s")
ind.Dismiss(true)
Sleep 300

; ── Telemetria: coste real del frame + contadores ULW ──
q := Toastify.Show("fps", "b", [], { duration: 6000, animDuration: 150, showProgress: true })
Sleep 900
s := Toastify.FPS()
Assert(s.HasProp("cost") && s.HasProp("costMax"), "FPS() reporta coste real (cost=" s.cost "ms)")
Assert(s.HasProp("ulw") && s.ulw > 0, "FPS() reporta ULW total=" s.ulw)
; Barra determinsta: tras la entrada solo cambia el rect de la barra → la
; composición GDI+ es parcial (el compositor ULW sigue copiando todo).
base := Toastify.__ulwTotal
Sleep 700
Assert(Toastify.__ulwTotal > base, "la barra viva sigue empujando frames: " base " → " Toastify.__ulwTotal)
q.Dismiss(true)
Sleep 400

Toastify.KillAll()
Sleep 400
if (Toastify.registry.Count != 0)
    Fail("registry no vacio: " Toastify.registry.Count)
Log("ALL_OK")
ExitApp(0)
