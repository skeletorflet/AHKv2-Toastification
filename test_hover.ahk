#Requires AutoHotkey v2.0
#Include lib\Toastification.ahk

; Initialize Toastification
Toastify.Start("dark", "top-right")

; Test hover pause
Toastify.Show("Test Hover",
    "Move your mouse over this toast to pause the progress bar.`nIt should pause when hovering.", [], {
        duration: 10000,
        showProgress: true
    })

Sleep(500)

Toastify.Show("Another Test", "This is a second toast for testing", [], {
    duration: 8000,
    showProgress: true
})