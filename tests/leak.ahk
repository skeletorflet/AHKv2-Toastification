#Requires AutoHotkey v2.0
#Include ..\lib\Toastify.ahk

; Leak: GDI + USER handles y memoria antes/despues del peor caso.
out := EnvGet("TEMP") "\toastify_leak_result.txt"
try FileDelete(out)
Log(line) => FileAppend(line "`n", out)
Fail(msg) {
    Log("FAIL: " msg)
    ExitApp(1)
}

GetGdi() => DllCall("GetGuiResources", "ptr", DllCall("GetCurrentProcess", "ptr"), "uint", 0, "uint")
GetUser() => DllCall("GetGuiResources", "ptr", DllCall("GetCurrentProcess", "ptr"), "uint", 1, "uint")
GetWS() {
    pmc := Buffer(48, 0)
    NumPut("uint", 48, pmc, 0)
    if (DllCall("psapi\GetProcessMemoryInfo", "ptr", DllCall("GetCurrentProcess", "ptr"), "ptr", pmc, "uint", 48))
        return NumGet(pmc, 8, "uptr") ; WorkingSetSize (offset 8 en PROCESS_MEMORY_COUNTERS_EX x64)
    return 0
}

Toastify.Start("dark", "top-right")
themes := ["dark", "glass", "neon", "cyberpunk", "minimal"]
styles := [["slide"], ["fade"], ["zoom"], ["rotate"], ["slide", "fade"]]
Sleep 400
g0 := GetGdi(), u0 := GetUser(), w0 := GetWS()

loop 200 {
    i := A_Index
    opts := { theme: themes[Mod(i, themes.Length) + 1]
        , animStyle: styles[Mod(i, styles.Length) + 1]
        , icon: "success", duration: 60
        , showProgress: true, progressStriped: Mod(i, 2) = 0
        , actions: Mod(i, 3) = 0 ? [{ text: "OK", onClick: (*) => {} }] : [] }
    tt := Toastify.Show("leak", "body", opts.actions, opts)
    if (Mod(i, 5) = 0)
        Sleep 10
    tt.Dismiss(true)
    if (Mod(i, 20) = 0)
        Sleep 60
}
Sleep 800
g1 := GetGdi(), u1 := GetUser(), w1 := GetWS()
dg := g1 - g0, du := u1 - u0
Log("GDI " g0 "->" g1 " (delta " dg ")")
Log("USER " u0 "->" u1 " (delta " du ")")
if (w0 > 0 && w1 > 0)
    Log("WS MB " Round(w0 / 1048576, 1) "->" Round(w1 / 1048576, 1))
if (dg > 5)
    Fail("GDI crecio " dg)
if (du > 5)
    Fail("USER crecio " du)
if (w0 > 0 && w1 > 0 && (w1 - w0) > 15 * 1048576)
    Fail("WS crecio >15MB")
if (Toastify.registry.Count != 0)
    Fail("registry no vacio: " Toastify.registry.Count)
Log("ALL_OK")
ExitApp(0)
