#Requires AutoHotkey v2.0

#Include lib\Toastify.ahk

Toastify.Start(, Toastify.ALIGN.BOTTOM_RIGHT)

mygui := Gui(, "Toastify Example")
mygui.AddButton(, 'Show Random Toast').OnEvent('Click', clickHandler)
mygui.AddButton(, 'DismissAll').OnEvent('Click', (*) => Toastify.DismissAll())
mygui.Show()
mygui.OnEvent('Close', (*) => ExitApp())
return

Pick(arr) => arr[Random(1, arr.Length)]

clickHandler(*) {
    actions := [
        { text: "Open Notepad", run: (*) => Run("notepad.exe") },
        { text: "Open Calculator", run: (*) => Run("calc.exe") },
        { text: "Open GitHub", run: (*) => Run("https://github.com") },
        { text: "Say Hello", run: (*) => ComObject("SAPI.SpVoice").Speak("Hello from Toastify") },
        { text: "Copy Link", run: (*) => (A_Clipboard := "https://github.com/ed7n/AHKv2-Toastification") },
        { text: "Open Settings", run: (*) => Run("ms-settings:") },
        { text: "Open Explorer", run: (*) => Run("explorer.exe") },
        { text: "System Info", run: (*) => Run("msinfo32.exe") },
        { text: "Task Manager", run: (*) => Run("taskmgr.exe") },
        { text: "Toggle Mute", run: (*) => Send("{Volume_Mute}") },
        { text: "Current Time", run: (*) => TrayTip("Current Time", FormatTime(, "HH:mm:ss")) },
    ]

    btnCount := Random(1, 3)
    btnActions := []
    avail := actions.Clone()
    loop btnCount {
        if avail.Length = 0
            break
        i := Random(1, avail.Length)
        btnActions.Push(avail[i])
        avail.RemoveAt(i)
    }
    btnActions.Push({ text: "Close", run: (*) => {} })

    buttons := []
    for a in btnActions
        buttons.Push({ text: a.text, onClick: a.run })

    animAvail := [
        Toastify.ANIM_STYLE.SLIDE,
        Toastify.ANIM_STYLE.FADE,
        Toastify.ANIM_STYLE.ZOOM,
        Toastify.ANIM_STYLE.ROTATE,
    ]
    i1 := Random(1, animAvail.Length)
    animStyle := [animAvail[i1]]
    animAvail.RemoveAt(i1)
    loop Random(0, Min(2, animAvail.Length)) {
        j := Random(1, animAvail.Length)
        animStyle.Push(animAvail[j])
        animAvail.RemoveAt(j)
    }

    titles := ["Update Available", "Download Complete", "New Message", "Battery Low", "Backup Finished", "Meeting in 10", "Installation Ready", "Sync Completed"]
    bodies := [
        "v2.1.0 is ready. What would you like to do?",
        "3 files saved to your folder.",
        "You have 1 unread notification.",
        "Plug in your charger soon.",
        "Your project was backed up successfully.",
        "Don't forget to join the call.",
        "The new build is ready to install.",
        "All your files are up to date.",
    ]

    Toastify.Show(Pick(titles), Pick(bodies), buttons, {
        position: Pick([
            Toastify.ALIGN.TOP,
            Toastify.ALIGN.BOTTOM,
            Toastify.ALIGN.LEFT,
            Toastify.ALIGN.RIGHT,
            Toastify.ALIGN.CENTER,
            Toastify.ALIGN.TOP_LEFT,
            Toastify.ALIGN.TOP_RIGHT,
            Toastify.ALIGN.BOTTOM_LEFT,
            Toastify.ALIGN.BOTTOM_RIGHT,
        ]),
        animStyle: animStyle,
        animEasing: Pick([
            Toastify.EASING.BOUNCE_OUT,
            Toastify.EASING.EASE_OUT_BACK,
            Toastify.EASING.ELASTIC_OUT,
            Toastify.EASING.EASE_IN_OUT_CUBIC,
            Toastify.EASING.EASE_OUT_EXPO,
            Toastify.EASING.EASE_OUT_SINE,
        ]),
        animEntrance: Pick([
            Toastify.ENTRANCE.AUTO,
            Toastify.ENTRANCE.RIGHT,
            Toastify.ENTRANCE.LEFT,
            Toastify.ENTRANCE.TOP,
            Toastify.ENTRANCE.BOTTOM,
        ]),
        theme: Pick([
            Toastify.THEMES.DARK,
            Toastify.THEMES.LIGHT,
            Toastify.THEMES.SUCCESS,
            Toastify.THEMES.ERROR,
            Toastify.THEMES.WARNING,
            Toastify.THEMES.INFO,
            Toastify.THEMES.MIDNIGHT,
            Toastify.THEMES.FOREST,
            Toastify.THEMES.NEON,
            Toastify.THEMES.VAPOR,
            Toastify.THEMES.CYBERPUNK,
            Toastify.THEMES.RETRO,
            Toastify.THEMES.GLASS,
            Toastify.THEMES.MINIMAL,
            Toastify.THEMES.PASTEL,
            Toastify.THEMES.FLAT,
        ]),
        duration: Random(0, 1) ? 0 : Random(2500, 8000),
        opacity: Random(10, 90) / 100,
        opacityOnHover: true,
        showProgress: Random(0, 1) ? true : false,
    })
}

esc::Reload