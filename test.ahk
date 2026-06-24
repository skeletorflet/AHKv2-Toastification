#Requires AutoHotkey v2.0
#Include lib\Toastification.ahk
CoordMode 'Mouse', 'Screen'
; Initialize Toastification
Toastify.Start("dark", "bottom-left")
f2::Toastify.Show("Hello World","Fast Toastification. Tick Count: " A_TickCount)