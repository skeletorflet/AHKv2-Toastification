#Requires AutoHotkey v2.0

#Include lib\Toastify.ahk

; Stress: 1000 create/destroy mezclando auto-dismiss, ForceClose y DismissAll.
; Verificar en Task Manager que Memoria privada y Handles/GDI vuelven a la
; línea base entre ciclos (sin crecimiento sostenido).

Toastify.Start(, Toastify.ALIGN.BOTTOM_RIGHT)

mygui := Gui(, "Toastify Stress")
mygui.AddText(, "Task Manager > Detalles: anotar Memoria (privada), Handles y GDI.")
mygui.AddButton(, "Iniciar stress").OnEvent("Click", runStress)
mygui.AddButton(, "Salir").OnEvent("Click", (*) => ExitApp())
mygui.Show()
mygui.OnEvent("Close", (*) => ExitApp())
return

runStress(*) {
    base := Toastify.__destroyCount
    loop 5 {
        loop 200 {
            t := Toastify.Show("Stress " A_Index, "cycle " A_Index
                , [{ text: "OK", onClick: (*) => 0 }]
                , { duration: 1, animStyle: "fade" })
            if (Mod(A_Index, 7) = 0)
                t.ForceClose()          ; ruta directa a Destroy
        }
        ; auto-dismiss (duration:1) + ForceClose corren solos; DismissAll barre resto
        Sleep(4000)
        Toastify.DismissAll()
        Sleep(2000)
        MsgBox("Ciclo " A_Index " listo. Destroy count: " (Toastify.__destroyCount - base) ". Memoria debe haber vuelto a base.")
    }
    MsgBox("Total destroys: " Toastify.__destroyCount)
}