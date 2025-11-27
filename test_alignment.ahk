#Requires AutoHotkey v2.0
#Include lib\Toastification.ahk

; ============================================================================
; Comprehensive Test for Toast Alignment and Stack Direction
; ============================================================================

; Test all 9 alignments with auto stack direction
TestAllAlignments() {
    alignments := ["topleft", "top", "topright", "centerleft", "center", "centerright", "bottomleft", "bottom",
        "bottomright"]

    for idx, align in alignments {
        Toastify.Start("dark", align, "auto")

        Toastify.Success("Alignment: " align, "Stack Direction: auto`nToast 1/3", [], {
            duration: 8000,
            animStyle: ["slide", "fade"],
            animEasing: "easeOutCubic"
        })

        Sleep(500)

        Toastify.Info("Alignment: " align, "Stack Direction: auto`nToast 2/3", [], {
            duration: 8000,
            animStyle: ["slide", "fade"]
        })

        Sleep(500)

        Toastify.Warning("Alignment: " align, "Stack Direction: auto`nToast 3/3", [], {
            duration: 8000,
            animStyle: ["slide", "fade"]
        })

        ; Wait to see the stacking
        Sleep(2000)

        ; Clear all before next test
        ; Toastify.DismissAll()
        ; Sleep(1000)
    }
}

; Test specific alignment with all stack directions
TestStackDirections() {
    stackDirections := ["top", "bottom", "left", "right", "center"]

    for idx, stackDir in stackDirections {
        Toastify.Start("dark", "center", stackDir)

        loop 3 {
            Toastify.Show("Stack: " stackDir, "Toast " A_Index "/3", [], {
                theme: (A_Index == 1) ? "success" : (A_Index == 2) ? "info" : "warning",
                icon: (A_Index == 1) ? "success" : (A_Index == 2) ? "info" : "warning",
                duration: 8000,
                animStyle: ["zoom", "fade"],
                animEasing: "easeOutBack"
            })
            Sleep(500)
        }

        Sleep(2000)
        Toastify.DismissAll()
        Sleep(1000)
    }
}

; Test per-toast alignment override
TestPerToastAlignment() {
    Toastify.Start("dark", "topright", "auto")

    ; Global alignment (topright)
    Toastify.Success("Global", "Using default topright alignment", [], {
        duration: 8000,
        animStyle: ["slide", "fade"]
    })

    Sleep(500)

    ; Override to center
    Toastify.Info("Override", "This one goes to center!", [], {
        duration: 8000,
        alignment: "center",
        stackDirection: "bottom",
        animStyle: ["zoom", "fade"],
        animEasing: "elasticOut"
    })

    Sleep(500)

    ; Override to bottomleft
    Toastify.Warning("Override", "This one to bottomleft!", [], {
        duration: 8000,
        alignment: "bottomleft",
        stackDirection: "top",
        animStyle: ["slide", "fade"],
        animEasing: "easeOutQuad"
    })

    Sleep(500)

    ; Another global
    Toastify.Error("Global", "Back to topright", [], {
        duration: 8000,
        animStyle: ["slide", "fade"]
    })

    Sleep(2000)
}

; Quick demo of all alignments
QuickDemo() {
    Toastify.Start("dark", "topright", "bottom")

    ; Show toasts at all 9 positions simultaneously
    alignments := Map(
        "topleft", "→ Top Left",
        "top", "↓ Top Center",
        "topright", "← Top Right",
        "centerleft", "→ Center Left",
        "center", "◉ Center",
        "centerright", "← Center Right",
        "bottomleft", "→ Bottom Left",
        "bottom", "↑ Bottom Center",
        "bottomright", "← Bottom Right"
    )

    for align, label in alignments {
        Toastify.Show(label, "Alignment demo", [], {
            alignment: align,
            theme: "dark",
            duration: 6000,
            animStyle: ["slide", "fade"],
            animEasing: "easeOutCubic"
        })
        Sleep(100)
    }
}

; ============================================================================
; Interactive Menu
; ============================================================================

ShowMenu() {
    menu := Gui("+AlwaysOnTop", "Toast Alignment Test Suite")
    menu.SetFont("s10", "Segoe UI")

    menu.AddText("w300", "Choose a test to run:")
    menu.AddButton("w300 h40", "Quick Demo (All 9 Positions)").OnEvent("Click", (*) => (menu.Hide(), QuickDemo()))
    menu.AddButton("w300 h40", "Test All Alignments (Detailed)").OnEvent("Click", (*) => (menu.Hide(),
    TestAllAlignments()))
    menu.AddButton("w300 h40", "Test Stack Directions").OnEvent("Click", (*) => (menu.Hide(), TestStackDirections()))
    menu.AddButton("w300 h40", "Test Per-Toast Override").OnEvent("Click", (*) => (menu.Hide(), TestPerToastAlignment()))
    menu.AddButton("w300 h40", "Exit").OnEvent("Click", (*) => ExitApp())

    menu.Show()
}

; Start the menu
ShowMenu()