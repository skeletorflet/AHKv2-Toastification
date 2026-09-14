#Requires AutoHotkey v2.0
#Include ..\lib\Toastify.ahk

; Bench: matriz calidad x cantidad. Reporta fps/avg/p95, falla si p95>35ms.
out := EnvGet("TEMP") "\toastify_bench_result.txt"
try FileDelete(out)
Log(line) => FileAppend(line "`n", out)
Fail(msg) {
    Log("FAIL: " msg)
    ExitApp(1)
}

Toastify.Start("dark", "top-right")
csv := EnvGet("TEMP") "\toastify_bench.csv"
try FileDelete(csv)
FileAppend("quality,count,fps,avg,p95,max`n", csv)

for q in ["Low", "Medium", "High"] {
    for n in [1, 3] {
        Toastify.KillAll()
        Sleep 300
        ; Measure the ENTRANCE phase (steady 60Hz animation). Determinate
        ; progress ticks at ~30Hz by design and layered-window ULW on some
        ; machines paces ~47ms there on ALL versions — not animation perf.
        loop n
            Toastify.Show("bench", "q=" q " n=" n, [],
                { animStyle: ["slide", "fade"], animDuration: 1500, duration: 0
                , showProgress: false, renderQuality: q })
        Sleep 300
        Toastify.__frameStats := []
        Sleep 700
        s := Toastify.FPS()
        Log(q " x" n ": fps=" s.fps " avg=" s.avg " p95=" s.p95 " max=" s.max)
        FileAppend(q "," n "," s.fps "," s.avg "," s.p95 "," s.max "`n", csv)
        if (s.samples < 5)
            Fail("sin muestras " q " x" n)
        if (s.p95 > 35)
            Fail("p95 " s.p95 " > 35ms (" q " x" n ")")
    }
}
Toastify.KillAll()
Sleep 300

; Tri-estado post-bench: quieto → sin perf mode
Toastify.Show("quiet", "idle", [], { duration: 0, showProgress: false, autoDismiss: false })
Sleep 400
if (Toastify.__perfFast)
    Fail("tri-state: perf mode pegado")
Log("tri-state ok")
Toastify.KillAll()
Sleep 300
Log("ALL_OK")
ExitApp(0)
