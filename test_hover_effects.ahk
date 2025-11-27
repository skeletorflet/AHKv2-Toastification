#Requires AutoHotkey v2.0
#Include lib\Toastification.ahk

; Initialize Toastification
Toastify.Start("dark", "topright", "bottom")

; 1. Standard Toast (Test Close Button)
Toastify.Show("Close Button Test", "Hover over the [X] to see the new red glow and larger hit area.", [], {
    duration: 5000
})

Sleep(500)

; 2. Zoom Effect
Toastify.Show("Zoom Effect", "Hover me! I will grow larger.", [], {
    hoverStyle: ["zoom"],
    hoverScale: 1.1,
    duration: 5000
})

Sleep(500)

; 3. Brightness Effect
Toastify.Show("Brightness Effect", "Hover me! I will light up.", [], {
    hoverStyle: ["brightness"],
    hoverBrightness: 0.2,
    duration: 5000
})

Sleep(500)

; 4. Rotate Effect
Toastify.Show("Rotate Effect", "Hover me! I will tilt.", [], {
    hoverStyle: ["rotate"],
    hoverRotation: 5.0,
    duration: 5000
})

Sleep(500)

; 5. Combined Effects
Toastify.Show("Combined Effects", "Zoom + Brightness + Rotate!", [], {
    hoverStyle: ["zoom", "brightness", "rotate"],
    hoverScale: 1.1,
    hoverBrightness: 0.2,
    hoverRotation: -3.0,
    duration: 8000
})

; Keep script alive
return

Esc:: ExitApp