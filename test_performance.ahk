#Requires AutoHotkey v2.0
#Include lib\Toastification.ahk

; ============================================================================
; Performance Test - Stress test with many simultaneous toasts
; ============================================================================

; Spam many toasts rapidly
global __stressTimer := 0
global __stressRemaining := 0

StressTest() {
    global __stressTimer, __stressRemaining
    if (__stressTimer)
        SetTimer(__stressTimer, 0) ; stop previous spawner
    __stressRemaining := 60

    Toastify.DismissAll()
    Toastify.Start("dark", "topright", "bottom")

    __stressTimer := (*) => StressSpawnTick()
    SetTimer(__stressTimer, 12) ; ~83 spawns/sec, non-blocking
}

StressSpawnTick() {
    global __stressRemaining, __stressTimer
    if (__stressRemaining <= 0) {
        SetTimer(__stressTimer, 0)
        __stressTimer := 0
        return
    }

    idx := 61 - __stressRemaining  ; Fixed: Start from 1
    themes := ["success", "info", "warning", "error"]
    theme := themes[1 + Mod(idx - 1, themes.Length)]
    icon := themes[1 + Mod(idx - 1, themes.Length)]

    Toastify.Show("Toast #" idx, "Performance test toast with some body text", [], {
        theme: theme,
        icon: icon,
        duration: 8000,
        animStyle: ["slide", "fade"],
        animEasing: "easeOutCubic",
        alignment: "topright"
    })

    __stressRemaining--
}

; Moderate test - 20 toasts with continuous spawning
global __moderateTimer := 0
global __moderateRemaining := 0

ModerateTest() {
    global __moderateTimer, __moderateRemaining
    if (__moderateTimer)
        SetTimer(__moderateTimer, 0)
    __moderateRemaining := 25

    Toastify.DismissAll()
    Toastify.Start("dark", "center", "bottom")

    __moderateTimer := (*) => ModerateSpawnTick()
    SetTimer(__moderateTimer, 150)
}

ModerateSpawnTick() {
    global __moderateRemaining, __moderateTimer
    if (__moderateRemaining <= 0) {
        SetTimer(__moderateTimer, 0)
        __moderateTimer := 0
        return
    }
    idx := 26 - __moderateRemaining
    Toastify.Success("Toast " idx, "Continuous spawn test", [], {
        duration: 6000,
        animStyle: ["zoom", "fade"],
        animEasing: "easeOutBack",
        alignment: "center"
    })
    __moderateRemaining--
}

; Different alignments test
MultiAlignmentTest() {
    Toastify.DismissAll()
    Sleep(200)
    Toastify.Start("dark", "center", "auto")

    ; Spawn at all 9 positions simultaneously
    alignments := ["topleft", "top", "topright", "centerleft", "center", "centerright", "bottomleft", "bottom",
        "bottomright"]

    loop 6 {
        for align in alignments {
            theme := ["success", "info", "warning"][Mod(A_Index - 1, 3) + 1]
            Toastify.Show(align " #" A_Index, "Multi-alignment performance test", [], {
                alignment: align,
                theme: theme,
                duration: 8000,
                animStyle: ["slide", "fade"]
            })
        }
        Sleep(300)
    }
}

; Menu
ShowMenu() {
    menu := Gui("+AlwaysOnTop", "Performance Test Suite")
    menu.SetFont("s11", "Segoe UI")

    menu.AddText("w350", "Choose a performance test:")
    menu.AddText("w350", "_______________________________________")

    menu.AddButton("w350 h45", "🚀 STRESS TEST (60 toasts instantly)").OnEvent("Click", (*) => StressTest())
    menu.AddButton("w350 h45", "⚡ Moderate Test (25 toasts continuous)").OnEvent("Click", (*) => ModerateTest())
    menu.AddButton("w350 h45", "📊 Multi-Alignment (9 positions x 6 waves)").OnEvent("Click", (*) => MultiAlignmentTest())
    menu.AddText("w350", "_______________________________________")
    menu.AddButton("w350 h35", "Exit").OnEvent("Click", (*) => ExitApp())

    menu.Show()
}

ShowMenu()