#Requires AutoHotkey v2.0

#Include lib\Toastify.ahk


Toastify.Start(, Toastify.ALIGN.BOTTOM_RIGHT)


mygui := Gui(, "Toastify Example")

mygui.AddButton(, 'Show').OnEvent('Click', clickHandler)
mygui.AddButton(, 'DismissAll').OnEvent('Click', (*) => Toastify.DismissAll())

mygui.Show()

return

clickHandler(*) {
    perm := Random(0, 1)
    Toastify.Show("Update Available", "v2.1.0 is ready.", [{ text: "Update", onClick: (*) => Run("updater.exe") }, { text: "Later", onClick: (*) => MsgBox("Snoozed") },
    ], {
        animStyle: [Toastify.ANIM_STYLE.ZOOM, Toastify.ANIM_STYLE.SLIDE],
        animEasing: Toastify.EASING.BOUNCE_OUT,
        theme: "cyberpunk",
        duration: 5000,
    })
}

esc::Reload