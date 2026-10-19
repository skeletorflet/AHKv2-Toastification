#Requires AutoHotkey v2.0
Persistent

/*
OnMouseMove - VERSIÓN FINAL (rendimiento + robustez)
=====================================================
Cambios respecto a la versión original:

1. Fast + Critical -1 en un hook WH_MOUSE_LL es un patrón conocido como
   inestable: el hook puede dispararse en medio de CUALQUIER hilo del
   script (no solo el hilo inactivo), y "Fast" no aísla el estado del
   hilo, así que un Critical -1 puede "filtrarse" a un hilo tuyo que no
   tenía nada que ver. Por defecto ahora se usa el modo NO-Fast (AHK
   aísla el estado automáticamente), con la opción de volver a Fast
   para quien quiera el último 1% de rendimiento y entienda el riesgo.
2. Se valida el resultado de SetWindowsHookExW y CallbackCreate: si
   falla, se lanza un error en vez de fallar en silencio.
3. Se ignoran los eventos de mouse INYECTADOS (por SendInput/MouseMove
   del propio script u otro proceso) para evitar bucles de feedback,
   con opción para desactivarlo si de verdad los quieres capturar.
4. Se descartan eventos con las mismas coordenadas que el último
   (WM_MOUSEMOVE puede llegar duplicado sin movimiento real).
5. Intervalo mínimo de despacho configurable (throttle opcional).
6. Los errores dentro de los callbacks del usuario ya no se tragan en
   silencio: se registran con OutputDebug para poder depurarlos.
7. Un solo registro de OnExit (antes se acumulaba en cada Start tras
   un Off).
8. No se agregan callbacks duplicados.
9. Nueva función OnMouseMove_IsActive().
*/

; === ESTADO GLOBAL ===
global _OMM_Hook := 0
global _OMM_Proc := 0
global _OMM_X := 0
global _OMM_Y := 0
global _OMM_PrevX := 0
global _OMM_PrevY := 0
global _OMM_Pending := 0
global _OMM_Callbacks := []
global _OMM_Dispatcher := 0
global _OMM_IgnoreInjected := true
global _OMM_DispatchDelay := -1     ; -1 = lo antes posible (siguiente ciclo idle)
global _OMM_ExitRegistered := false

; === PRE-CACHE DE FUNCIONES DLL ===
global _OMM_pSetWindowsHookEx := DllCall("GetProcAddress", "ptr", DllCall("GetModuleHandle", "str", "user32", "ptr"),
    "astr", "SetWindowsHookExW", "ptr")
global _OMM_pUnhookWindowsHookEx := DllCall("GetProcAddress", "ptr", DllCall("GetModuleHandle", "str", "user32", "ptr"),
    "astr", "UnhookWindowsHookEx", "ptr")
global _OMM_pCallNextHookEx := DllCall("GetProcAddress", "ptr", DllCall("GetModuleHandle", "str", "user32", "ptr"),
    "astr", "CallNextHookEx", "ptr")

; === API PÚBLICA ===

; callback:        función opcional a registrar de una (x, y, prevX, prevY)
; ignoreInjected:   ignora movimientos generados por SendInput/MouseMove (true por defecto)
; minIntervalMs:    intervalo mínimo entre despachos, en ms (0 = tan rápido como se pueda)
; fast:             true = CallbackCreate "Fast" (más veloz, menos seguro ante hilos concurrentes)
OnMouseMove_Start(callback := 0, ignoreInjected := true, minIntervalMs := 0, fast := false) {
    global

    if callback && !_OMM_Callbacks.Has(callback)
        _OMM_Callbacks.Push(callback)

    _OMM_IgnoreInjected := ignoreInjected
    _OMM_DispatchDelay := -Max(1, minIntervalMs)

    if !_OMM_Dispatcher
        _OMM_Dispatcher := _OMM_Dispatch

    if !_OMM_Proc {
        _OMM_Proc := CallbackCreate(_OMM_HookProc, fast ? "Fast" : "", 3)
        if !_OMM_Proc
            throw Error("OnMouseMove: CallbackCreate falló.")
    }

    if !_OMM_Hook {
        _OMM_Hook := DllCall(_OMM_pSetWindowsHookEx, "int", 14, "ptr", _OMM_Proc, "ptr", 0, "uint", 0, "ptr")
        if !_OMM_Hook {
            err := A_LastError
            CallbackFree(_OMM_Proc)
            _OMM_Proc := 0
            throw OSError(err, -1, "OnMouseMove: SetWindowsHookExW falló.")
        }
        if !_OMM_ExitRegistered {
            OnExit((*) => OnMouseMove_Off())
            _OMM_ExitRegistered := true
        }
    }

    MouseGetPos(&x, &y)
    _OMM_X := x, _OMM_Y := y
}

OnMouseMove_Off(*) {
    global
    if _OMM_Hook {
        DllCall(_OMM_pUnhookWindowsHookEx, "ptr", _OMM_Hook)
        _OMM_Hook := 0
    }
    if _OMM_Proc {
        CallbackFree(_OMM_Proc)
        _OMM_Proc := 0
    }
    if _OMM_Dispatcher
        SetTimer(_OMM_Dispatcher, 0)
    _OMM_Pending := 0
}

OnMouseMove_Remove(callback) {
    global _OMM_Callbacks
    loop _OMM_Callbacks.Length {
        if (_OMM_Callbacks[A_Index] = callback) {
            _OMM_Callbacks.RemoveAt(A_Index)
            return true
        }
    }
    return false
}

OnMouseMove_GetXY() => [_OMM_X, _OMM_Y]

OnMouseMove_IsActive() => !!_OMM_Hook

; === HOOK PROCEDURE ===
_OMM_HookProc(nCode, wParam, lParam) {
    global
    Critical -1

    if (nCode >= 0 && wParam = 0x200) {
        ; offset 12 en MSLLHOOKSTRUCT = flags; bit 0 = LLMHF_INJECTED
        if (_OMM_IgnoreInjected && (NumGet(lParam + 12, "uint") & 1))
            return DllCall(_OMM_pCallNextHookEx, "ptr", 0, "int", nCode, "uptr", wParam, "ptr", lParam, "ptr")

        newX := NumGet(lParam + 0, "int")
        newY := NumGet(lParam + 4, "int")

        if (newX != _OMM_X || newY != _OMM_Y) {
            _OMM_PrevX := _OMM_X, _OMM_PrevY := _OMM_Y
            _OMM_X := newX, _OMM_Y := newY

            if !_OMM_Pending {
                _OMM_Pending := 1
                SetTimer(_OMM_Dispatcher, _OMM_DispatchDelay)
            }
        }
    }

    return DllCall(_OMM_pCallNextHookEx, "ptr", 0, "int", nCode, "uptr", wParam, "ptr", lParam, "ptr")
}

; === DISPATCHER ASÍNCRONO ===
_OMM_Dispatch() {
    global
    _OMM_Pending := 0

    x := _OMM_X, y := _OMM_Y, px := _OMM_PrevX, py := _OMM_PrevY

    loop _OMM_Callbacks.Length {
        try
            _OMM_Callbacks[A_Index](x, y, px, py)
        catch as e
            OutputDebug("OnMouseMove: error en callback #" A_Index ": " e.Message "`n")
    }
}
