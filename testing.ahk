#include lib/Toastify.ahk
#Requires AutoHotkey v2.0
#Include lib\Toastify.ahk

Toastify.Start("dark", "bottom-right")
Toastify.SetConfig({ minHeight: 94, repoDuration: 161 })
Toastify.marginX := 33
Toastify.marginY := 32
Toastify.spacing := 29
Toastify.maxToasts := 6
Toastify.hoverPauseEnabled := false

Toastify.Show("New Message", "The new build is ready.", [{ text: "Open Notepad", onClick: (*) => Run("notepad.exe") }, { text: "Close", onClick: (*) => {} }], {
    position: "bottom",
    theme: "error",
    icon: "copy",
    iconScale: 0.82352324462995385,
    iconSize: 48,
    width: 399,
    paddingX: 21,
    paddingY: 10,
    borderRadius: 20,
    borderWidth: 3,
    fontName: "Segoe UI Emoji",
    fontSizeTitle: 22,
    fontSizeBody: 13,
    fontWeightTitle: "Bold",
    fontWeightBody: "Regular",
    animStyle: ["fade", "rotate"],
    animEasing: "easeOut",
    animEntrance: "top",
    renderQuality: "Medium",
    animDuration: 217,
    rotationDegree: 27,
    duration: 3017,
    autoDismiss: true,
    showProgress: false,
    showClose: true,
    opacity: 1,
    opacityOnHover: true,
})