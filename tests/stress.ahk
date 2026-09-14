#Requires AutoHotkey v2.0
#Include ..\lib\Toastify.ahk

; Stress: eviction, reflow-storm, groups/tags, staggered exits.
out := EnvGet("TEMP") "\toastify_stress_result.txt"
try FileDelete(out)
Log(line) => FileAppend(line "`n", out)
Fail(msg) {
    Log("FAIL: " msg)
    ExitApp(1)
}

Toastify.Start("dark", "top-right")
Toastify.maxToasts := 8

; ── S1: reflow-storm — 10 shows en el mismo tick ──
loop 10
    Toastify.Show("storm " A_Index, "body", [], { duration: 3000 })
Sleep 600
if (Toastify.toasts.Length > Toastify.maxToasts)
    Fail("S1: toasts=" Toastify.toasts.Length " > maxToasts")
Log("S1 ok: len=" Toastify.toasts.Length)
Toastify.KillAll()
Sleep 400
if (Toastify.toasts.Length != 0 || Toastify.exitingToasts.Length != 0)
    Fail("S1: KillAll dejo restos")
Log("S1b ok: KillAll limpio")

; ── S2: eviction por maxToasts — 20 shows, sobreviven 8 ──
loop 20
    Toastify.Show("evict " A_Index, "b", [], { duration: 5000, priority: A_Index })
Sleep 800
if (Toastify.toasts.Length > Toastify.maxToasts)
    Fail("S2: len=" Toastify.toasts.Length)
Log("S2 ok: len=" Toastify.toasts.Length)

; ── S3: tag dedupe case-sensitive ──
Toastify.KillAll()
Sleep 300
Toastify.Show("a", "1", [], { tag: "Alert", duration: 5000 })
Toastify.Show("b", "2", [], { tag: "alert", duration: 5000 })
Sleep 300
n := 0
for t in Toastify.toasts
    if (t.tag = "Alert" || t.tag = "alert")
        n++
if (n != 2)
    Fail("S3: tags case-insensitive, n=" n)
Toastify.Show("c", "3", [], { tag: "Alert", duration: 5000 })
Sleep 300
n := 0
for t in Toastify.toasts
    if (t.tag == "Alert")
        n++
if (n != 1)
    Fail("S3: dedupe no reemplazo, n=" n)
Log("S3 ok: tags case-sensitive + dedupe")

; ── S4: grupos ──
Toastify.DismissGroup("Alert")
Sleep 800
for t in Toastify.toasts
    if (t.tag == "Alert")
        Fail("S4: DismissGroup no saco el tag")
Log("S4 ok: DismissGroup")
Toastify.KillAll()
Sleep 400

; ── S5: 200 ciclos Show/Dismiss, registry vacio al final ──
loop 200 {
    tt := Toastify.Show("s", "b", [], { duration: 50 })
    tt.Dismiss(true)
    if (Mod(A_Index, 25) = 0)
        Sleep 20
}
Sleep 800
if (Toastify.registry.Count != 0)
    Fail("S5: registry=" Toastify.registry.Count)
if (Toastify.toasts.Length != 0 || Toastify.exitingToasts.Length != 0)
    Fail("S5: listas no vacias")
Log("S5 ok: 200 ciclos sin restos")

Log("ALL_OK")
ExitApp(0)
