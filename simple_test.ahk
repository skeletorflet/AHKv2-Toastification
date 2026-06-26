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
    Toastify.Show(
        'Example',
        perm == 1 ? 'This is a Permanent Toastify' : 'This is a Normal Toastify', , {
            animStyle: [Toastify.ANIM_STYLE.ZOOM, Toastify.ANIM_STYLE.SLIDE, Toastify.ANIM_STYLE.FADE],
            permanent: perm == 1 ? true : false,
            animEntrance: Toastify.ENTRANCE.LEFT,
            animEasing: Toastify.EASING.BOUNCE_OUT,
            animDuration: Random(200, 3000),
            duration: 4000,
        }
    )
}