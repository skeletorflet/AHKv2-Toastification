#Requires AutoHotkey v2.0
#Include lib/Toastification.ahk

; ============================================================================
; Toastification Test & Examples
; ============================================================================
; Hotkeys:
;   F1 - Basic Toast
;   F2 - Success Toast
;   F3 - Error Toast (now Bounce Animation)
;   F4 - Warning Toast (now EaseInOutBack Animation)
;   F5 - Info Toast (now Fast Linear Animation)
;   F6 - Toast with Buttons (now Slow EaseInOut Quart Animation)
;   F7 - Multiple Toasts
;   F8 - Different Positions Demo
;   F9 - Long Content Toast
;   F10 - No Progress Bar
;   1 - Global Config Test
;   2 - Custom Theme Test
;   Delete - Callback Test
;   Esc - Dismiss All Toasts
; ============================================================================

; Initialize Toastification
Toastify.Start("light", "top-left")

; === Hotkey Definitions ===

F1:: {
    Toastify.Show(
        "Hello World! 👋",
        "This is a basic toast notification",
        [], { duration: 4000 }
    )
}

F2:: {
    Toastify.Success(
        "Operation Successful!",
        "Your file has been saved successfully.",
        [], { duration: 3000 }
    )
}

3:: {
    ; Test Bounce Animation
    Toastify.Info(
        "Bounce Animation",
        "This toast uses a bouncing effect!",
        [], {
            animEasing: "bounce",
            animDuration: 500,
            duration: 4000
        }
    )
}

4:: {
    ; Test EaseInOutBack Animation (Overshoot)
    Toastify.Success(
        "EaseInOutBack Animation",
        "This toast has an overshoot effect.",
        [], {
            animEasing: "easeInOutBack",
            animDuration: 400,
            duration: 4000
        }
    )
}

5:: {
    ; Test Fast Animation (Linear)
    Toastify.Warning(
        "Fast Animation",
        "This toast slides in quickly with linear easing.",
        [], {
            animEasing: "linear",
            animDuration: 150,
            duration: 3000
        }
    )
}

6:: {
    ; Test Slow Animation (EaseInOutQuart)
    Toastify.Show(
        "Slow Animation",
        "This toast slides in slowly and smoothly.",
        [], {
            theme: "info",
            animEasing: "easeInOutQuart",
            animDuration: 600,
            duration: 4000
        }
    )
}

F7:: {
    ; Show multiple toasts at once
    Toastify.Success("First", "This is the first toast")
    Sleep(300)
    Toastify.Info("Second", "This is the second toast")
    Sleep(300)
    Toastify.Warning("Third", "This is the third toast")
    Sleep(300)
    Toastify.Error("Fourth", "This is the fourth toast")
}

F8:: {
    ; Cycle through different positions
    static positions := ["top-right", "top-left", "bottom-right", "bottom-left"]
    static currentPos := 1

    pos := positions[currentPos]
    Toastify.Show(
        "Position: " pos,
        "Toast showing at " pos,
        [], { position: pos, duration: 3000 }
    )

    currentPos := Mod(currentPos, positions.Length) + 1
}

F9:: {
    longText :=
        "This is a much longer notification message to demonstrate how the toast handles longer content. The text should wrap properly and the toast should resize to accommodate the content while maintaining good visual design."

    Toastify.Info(
        "Long Content Example",
        longText,
        [], { duration: 6000, width: 400 }
    )
}

F10:: {
    Toastify.Show(
        "No Progress Bar",
        "This toast doesn't show a progress bar",
        [], {
            showProgress: false,
            duration: 4000
        }
    )
}

F11:: {
    ; Custom themed toast
    Toastify.Custom({
        title: "🎨 Custom Theme",
        body: "This toast uses a custom configuration",
        theme: "dark",
        icon: "info",
        duration: 4000,
        width: 360,
        actions: [{ text: "OK", onClick: (*) => ToolTip("Custom action!", , , 1) }, { text: "OK", onClick: (*) =>
            ToolTip("Custom action!", , , 1) }]
    })
}

F12:: {
    ; Toast without close button
    Toastify.Show(
        "Auto-dismiss Only",
        "This toast has no close button - must wait for auto-dismiss",
        [], {
            showClose: false,
            duration: 3000
        }
    )
}

Delete:: {
    ; Test Callbacks and Close Button
    Toastify.Show(
        "Callback Test",
        "Click me or close me! I have callbacks.",
        [], {
            duration: 8000,
            onClick: (*) => MsgBox("You clicked the toast body!"),
            onClose: (*) => ToolTip("Toast Closed via Callback!", 0, 0, 2)
        }
    )
    SetTimer(() => ToolTip("", , , 2), -2000)
}

1:: {
    ; Test Global Config Change
    Toastify.SetConfig({
        fontName: "Consolas",
        fontSizeTitle: 18,
        borderRadius: 4,
        paddingX: 20
    })

    Toastify.Info(
        "Config Updated",
        "This toast uses Consolas font and sharper corners.",
        [], { duration: 4000 }
    )
}

2:: {
    ; Test Custom Theme (Neon)
    Toastify.RegisterTheme("neon", {
        bg1: 0xFF000000, bg2: 0xFF1a1a1a,
        fg: 0xFF00ff00, accent: 0xFFd600ff,
        shadow: 0x88d600ff, progress: 0xFFd600ff
    })

    Toastify.Show(
        "Neon Theme",
        "This is a custom neon theme!",
        [], {
            theme: "neon",
            icon: "info",
            duration: 5000,
            fontName: "Impact",
            fontSizeTitle: 20
        }
    )
}

Esc:: {
    Toastify.DismissAll()
    ToolTip("All toasts dismissed!", , , 1)
    SetTimer(() => ToolTip("", , , 1), -1000)
}

; === Demonstration Sequence ===
^d:: {  ; Ctrl+D for Demo
    DemoSequence()
}

DemoSequence() {
    ; Automated demo showing all features
    MsgBox("Starting Toastification Demo!`n`nWatch as different toast types appear automatically.", "Demo", "T3")

    ; 1. Success
    Toastify.Success("Demo Started", "Welcome to Toastification demo!")
    Sleep(2000)

    ; 2. Info
    Toastify.Info("Feature Demo", "Showing different toast types...")
    Sleep(2000)

    ; 3. Warning
    Toastify.Warning("Warning Example", "This is what a warning looks like")
    Sleep(2000)

    ; 4. Error
    Toastify.Error("Error Example", "This is what an error looks like")
    Sleep(2000)

    ; 5. Multiple toasts
    Toastify.Info("Stacking", "Multiple toasts stack nicely")
    Sleep(300)
    Toastify.Success("Stack 2", "Second in stack")
    Sleep(300)
    Toastify.Warning("Stack 3", "Third in stack")
    Sleep(3000)

    ; 6. With buttons
    Toastify.Show(
        "Interactive Toast",
        "Click a button to see interaction",
        [{ text: "Action 1", onClick: (*) => ToolTip("Action 1 clicked!", , , 1) }, { text: "Action 2", onClick: (*) =>
            ToolTip("Action 2 clicked!", , , 1) }], { theme: "info", icon: "info", duration: 8000 }
    )

    Sleep(2000)
    MsgBox("Demo complete! Use F1-F12 hotkeys to try different toast types.", "Demo Complete", "T3")
}

; === Welcome Message ===
; Show a welcome toast on startup
ShowWelcome() {
    Toastify.Success(
        "Toastification Ready! ✨",
        "Press hotkeys 1-6 or F1-F12 to test different toasts, Ctrl+D for demo, Esc to dismiss all",
        [], { duration: 6000, width: 420 }
    )
}
SetTimer(ShowWelcome, -500)