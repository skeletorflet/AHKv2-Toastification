#Requires AutoHotkey v2.0
#Include AHKv2-Gdip\Gdip_All.ahk


class ToastEasing {
    static defaultEasing := "easeOutCubic"


    static linear(t) => t


    static easeInQuad(t) => t * t
    static easeOutQuad(t) => t * (2 - t)
    static easeInOutQuad(t) => (t < 0.5) ? (2 * t * t) : (-1 + (4 - 2 * t) * t)


    static easeInCubic(t) => t * t * t
    static easeOutCubic(t) => (--t) * t * t + 1
    static easeInOutCubic(t) => (t < 0.5) ? (4 * t * t * t) : ((t - 1) * (2 * t - 2) * (2 * t - 2) + 1)


    static easeInQuart(t) => t * t * t * t
    static easeOutQuart(t) => 1 - (--t) * t * t * t
    static easeInOutQuart(t) => (t < 0.5) ? (8 * t * t * t * t) : (1 - 8 * (--t) * t * t * t)


    static easeInBack(t) {
        c1 := 1.70158
        c3 := c1 + 1
        return c3 * t * t * t - c1 * t * t
    }

    static easeOutBack(t) {
        c1 := 1.70158
        c3 := c1 + 1
        return 1 + c3 * ((t - 1) ** 3) + c1 * ((t - 1) ** 2)
    }

    static easeInOutBack(t) {
        c1 := 1.70158
        c2 := c1 * 1.525
        return (t < 0.5)
            ? ((2 * t) ** 2 * ((c2 + 1) * 2 * t - c2)) / 2
        : ((2 * t - 2) ** 2 * ((c2 + 1) * (t * 2 - 2) + c2) + 2) / 2
    }


    static bounce(t) => ToastEasing.bounceOut(t)


    static funcs := 0
    static getEasing(name, t) {
        if (!ToastEasing.funcs) {
            ToastEasing.funcs := Map(
                "linear", ToastEasing.linear,
                "easeInQuad", ToastEasing.easeInQuad,
                "easeOutQuad", ToastEasing.easeOutQuad,
                "easeInOutQuad", ToastEasing.easeInOutQuad,
                "easeInCubic", ToastEasing.easeInCubic,
                "easeOutCubic", ToastEasing.easeOutCubic,
                "easeInOutCubic", ToastEasing.easeInOutCubic,
                "easeInQuart", ToastEasing.easeInQuart,
                "easeOutQuart", ToastEasing.easeOutQuart,
                "easeInOutQuart", ToastEasing.easeInOutQuart,
                "easeInBack", ToastEasing.easeInBack,
                "easeOutBack", ToastEasing.easeOutBack,
                "easeInOutBack", ToastEasing.easeInOutBack,
                "bounce", ToastEasing.bounceOut,
                "bounceOut", ToastEasing.bounceOut,
                "bounceIn", ToastEasing.bounceIn,
                "bounceInOut", ToastEasing.bounceInOut,
                "easeInSine", ToastEasing.easeInSine,
                "easeOutSine", ToastEasing.easeOutSine,
                "easeInOutSine", ToastEasing.easeInOutSine,
                "easeInExpo", ToastEasing.easeInExpo,
                "easeOutExpo", ToastEasing.easeOutExpo,
                "easeInOutExpo", ToastEasing.easeInOutExpo,
                "easeInCirc", ToastEasing.easeInCirc,
                "easeOutCirc", ToastEasing.easeOutCirc,
                "easeInOutCirc", ToastEasing.easeInOutCirc,
                "easeInQuint", ToastEasing.easeInQuint,
                "easeOutQuint", ToastEasing.easeOutQuint,
                "easeInOutQuint", ToastEasing.easeInOutQuint,
                "elasticIn", ToastEasing.elasticIn,
                "elasticOut", ToastEasing.elasticOut,
                "elasticInOut", ToastEasing.elasticInOut,
                "decelerate", ToastEasing.decelerate,
                "ease", ToastEasing.ease,
                "easeIn", ToastEasing.easeIn,
                "easeOut", ToastEasing.easeOut,
                "easeInOut", ToastEasing.easeInOut,
                "fastOutSlowIn", ToastEasing.fastOutSlowIn,
                "slowMiddle", ToastEasing.slowMiddle,
                "easeInToLinear", ToastEasing.easeInToLinear,
                "linearToEaseOut", ToastEasing.linearToEaseOut,
                "fastLinearToSlowEaseIn", ToastEasing.fastLinearToSlowEaseIn,
                "easeInOutCubicEmphasized", ToastEasing.easeInOutCubicEmphasized
            )
        }
        fn := ToastEasing.funcs.Has(name) ? ToastEasing.funcs[name] : 0
        return fn ? fn.Call(ToastEasing, t) : ToastEasing.%ToastEasing.defaultEasing%(t)
    }


    static easeInQuint(t) => t * t * t * t * t
    static easeOutQuint(t) => 1 + (--t) * t * t * t * t
    static easeInOutQuint(t) => (t < 0.5) ? (16 * t * t * t * t * t) : (1 + 16 * (--t) * t * t * t * t)


    static easeInSine(t) => 1 - Cos((t * 3.14159265359) / 2)
    static easeOutSine(t) => Sin((t * 3.14159265359) / 2)
    static easeInOutSine(t) => -(Cos(3.14159265359 * t) - 1) / 2


    static easeInExpo(t) => (t = 0) ? 0 : (2 ** (10 * t - 10))
    static easeOutExpo(t) => (t = 1) ? 1 : (1 - 2 ** (-10 * t))
    static easeInOutExpo(t) {
        if (t = 0)
            return 0
        if (t = 1)
            return 1
        return (t < 0.5) ? (2 ** (20 * t - 10)) / 2 : (2 - 2 ** (-20 * t + 10)) / 2
    }


    static easeInCirc(t) => 1 - Sqrt(1 - (t ** 2))
    static easeOutCirc(t) => Sqrt(1 - ((t - 1) ** 2))
    static easeInOutCirc(t) => (t < 0.5)
        ? (1 - Sqrt(1 - (2 * t) ** 2)) / 2
        : (Sqrt(1 - (-2 * t + 2) ** 2) + 1) / 2


    static elasticIn(t) {
        c4 := (2 * 3.14159265359) / 3
        return (t = 0) ? 0 : (t = 1) ? 1 : -(2 ** (10 * t - 10)) * Sin((t * 10 - 10.75) * c4)
    }

    static elasticOut(t) {
        c4 := (2 * 3.14159265359) / 3
        return (t = 0) ? 0 : (t = 1) ? 1 : (2 ** (-10 * t)) * Sin((t * 10 - 0.75) * c4) + 1
    }

    static elasticInOut(t) {
        c5 := (2 * 3.14159265359) / 4.5
        return (t = 0) ? 0
        : (t = 1) ? 1
        : (t < 0.5) ? -((2 ** (20 * t - 10)) * Sin((20 * t - 11.125) * c5)) / 2
        : ((2 ** (-20 * t + 10)) * Sin((20 * t - 11.125) * c5)) / 2 + 1
    }


    static bounceOut(t) {
        n1 := 7.5625
        d1 := 2.75
        if (t < 1 / d1) {
            return n1 * t * t
        } else if (t < 2 / d1) {
            t -= 1.5 / d1
            return n1 * t * t + 0.75
        } else if (t < 2.5 / d1) {
            t -= 2.25 / d1
            return n1 * t * t + 0.9375
        } else {
            t -= 2.625 / d1
            return n1 * t * t + 0.984375
        }
    }

    static bounceIn(t) => 1 - ToastEasing.bounceOut(1 - t)
    static bounceInOut(t) => (t < 0.5)
        ? (1 - ToastEasing.bounceOut(1 - 2 * t)) / 2
        : (1 + ToastEasing.bounceOut(2 * t - 1)) / 2


    static decelerate(t) => 1 - ((1 - t) * (1 - t))
    static ease(t) => ToastEasing.easeInOutCubic(t)
    static easeIn(t) => ToastEasing.easeInCubic(t)
    static easeOut(t) => ToastEasing.easeOutCubic(t)
    static easeInOut(t) => ToastEasing.easeInOutCubic(t)
    static fastOutSlowIn(t) => ToastEasing.easeInOutCubic(t)
    static slowMiddle(t) {
        if (t < 0.5)
            return ToastEasing.easeInCubic(t * 2) / 2
        return 0.5 + ToastEasing.easeOutCubic((t - 0.5) * 2) / 2
    }
    static easeInToLinear(t) => (t < 0.5) ? ToastEasing.easeInCubic(t * 2) / 2 : 0.5 + (t - 0.5)
    static linearToEaseOut(t) => (t < 0.5) ? t : 0.5 + ToastEasing.easeOutCubic((t - 0.5) * 2) / 2
    static fastLinearToSlowEaseIn(t) {
        linearEnd := 0.5
        if (t < linearEnd)
            return t / linearEnd * 0.5
        return 0.5 + ToastEasing.easeInCubic((t - linearEnd) / (1 - linearEnd)) / 2
    }
    static easeInOutCubicEmphasized(t) {

        c := 1.4
        if (t < 0.5)
            return (c * 4 * t * t * t)
        return 1 - (((-2 * t + 2) ** 3) * c) / 2
    }
}


class Toastify {
    static pToken := 0
    static toasts := []
    static exitingToasts := []
    static marginX := 16
    static marginY := 16
    static spacing := 12
    static position := "top-right"
    static theme := "dark"
    static hoverPauseEnabled := true
    static maxToasts := 8

    static __globalTimer := 0
    static __watchdogTimer := 0
    static __lastTickTime := 0
    static registry := Map()
    static config := ToastConfig()
    animStartX := 0
    animStartY := 0

    static ALIGN := {
        TOP: "top",
        BOTTOM: "bottom",
        LEFT: "left",
        RIGHT: "right",
        CENTER: "center",
        TOP_LEFT: "top-left",
        TOP_RIGHT: "top-right",
        BOTTOM_LEFT: "bottom-left",
        BOTTOM_RIGHT: "bottom-right"
    }

    static THEMES := {
        DARK: "dark",
        LIGHT: "light",
        SUCCESS: "success",
        SUCCESS_LIGHT: "success-light",
        ERROR: "error",
        ERROR_LIGHT: "error-light",
        WARNING: "warning",
        WARNING_LIGHT: "warning-light",
        INFO: "info",
        INFO_LIGHT: "info-light",
        MIDNIGHT: "midnight",
        MIDNIGHT_LIGHT: "midnight-light",
        FOREST: "forest",
        FOREST_LIGHT: "forest-light",
        NEON: "neon",
        NEON_LIGHT: "neon-light",
        VAPOR: "vapor",
        VAPOR_LIGHT: "vapor-light",
        CYBERPUNK: "cyberpunk",
        CYBERPUNK_LIGHT: "cyberpunk-light",
        RETRO: "retro",
        RETRO_LIGHT: "retro-light",
        GLASS: "glass",
        GLASS_LIGHT: "glass-light",
        MINIMAL: "minimal",
        MINIMAL_LIGHT: "minimal-light",
        PASTEL: "pastel",
        PASTEL_LIGHT: "pastel-light",
        FLAT: "flat",
        FLAT_LIGHT: "flat-light"
    }

    static ANIM_STYLE := {
        SLIDE: "slide",
        FADE: "fade",
        ZOOM: "zoom",
        ROTATE: "rotate"
    }

    static ENTRANCE := {
        AUTO: "auto",
        RIGHT: "right",
        LEFT: "left",
        TOP: "top",
        BOTTOM: "bottom"
    }

    static QUALITY := {
        LOW: "Low",
        MEDIUM: "Medium",
        HIGH: "High"
    }

    static EASING := {
        LINEAR: "linear",
        EASE_IN_QUAD: "easeInQuad",
        EASE_OUT_QUAD: "easeOutQuad",
        EASE_IN_OUT_QUAD: "easeInOutQuad",
        EASE_IN_CUBIC: "easeInCubic",
        EASE_OUT_CUBIC: "easeOutCubic",
        EASE_IN_OUT_CUBIC: "easeInOutCubic",
        EASE_IN_QUART: "easeInQuart",
        EASE_OUT_QUART: "easeOutQuart",
        EASE_IN_OUT_QUART: "easeInOutQuart",
        EASE_IN_BACK: "easeInBack",
        EASE_OUT_BACK: "easeOutBack",
        EASE_IN_OUT_BACK: "easeInOutBack",
        BOUNCE: "bounce",
        BOUNCE_OUT: "bounceOut",
        BOUNCE_IN: "bounceIn",
        BOUNCE_IN_OUT: "bounceInOut",
        EASE_IN_SINE: "easeInSine",
        EASE_OUT_SINE: "easeOutSine",
        EASE_IN_OUT_SINE: "easeInOutSine",
        EASE_IN_EXPO: "easeInExpo",
        EASE_OUT_EXPO: "easeOutExpo",
        EASE_IN_OUT_EXPO: "easeInOutExpo",
        EASE_IN_CIRC: "easeInCirc",
        EASE_OUT_CIRC: "easeOutCirc",
        EASE_IN_OUT_CIRC: "easeInOutCirc",
        EASE_IN_QUINT: "easeInQuint",
        EASE_OUT_QUINT: "easeOutQuint",
        EASE_IN_OUT_QUINT: "easeInOutQuint",
        ELASTIC_IN: "elasticIn",
        ELASTIC_OUT: "elasticOut",
        ELASTIC_IN_OUT: "elasticInOut",
        DECELERATE: "decelerate",
        EASE: "ease",
        EASE_IN: "easeIn",
        EASE_OUT: "easeOut",
        EASE_IN_OUT: "easeInOut",
        FAST_OUT_SLOW_IN: "fastOutSlowIn",
        SLOW_MIDDLE: "slowMiddle",
        EASE_IN_TO_LINEAR: "easeInToLinear",
        LINEAR_TO_EASE_OUT: "linearToEaseOut",
        FAST_LINEAR_TO_SLOW_EASE_IN: "fastLinearToSlowEaseIn",
        EASE_IN_OUT_CUBIC_EMPHASIZED: "easeInOutCubicEmphasized"
    }

    static PRIORITY := {
        IDLE: "Idle",
        BELOW_NORMAL: "BelowNormal",
        NORMAL: "Normal",
        ABOVE_NORMAL: "AboveNormal",
        HIGH: "High",
        REALTIME: "Realtime"
    }

    static SetConfig(cfg) {
        static keys := ["fontName", "fontSizeTitle", "fontSizeBody", "fontWeightTitle", "fontWeightBody",
            "width", "borderRadius", "iconSize", "paddingX", "paddingY", "repoDuration",
            "animDuration", "animEasing", "animStyle", "animEntrance", "renderQuality"]
        for key in keys {
            if cfg.HasProp(key)
                Toastify.config.%key% := cfg.%key%
        }
    }

    static RegisterTheme(name, palette) {
        ToastTheme.Register(name, palette)
    }

    static Start(theme := "dark", position := "top-right") {
        if !Toastify.pToken {

            try DllCall("user32\SetProcessDpiAwarenessContext", "ptr", -4, "ptr")
            try DllCall("Shcore\SetProcessDpiAwareness", "int", 2, "ptr", 0)

            pt := Gdip_Startup()
            if !pt {
                MsgBox("GDI+ startup failed")
                return
            }
            Toastify.pToken := pt

            ; ══════════════════════════════════════════════════════════
            ; FIX REAL: ahora InitThemes() es un método normal, que SOLO
            ; corre cuando lo llamamos, y lo llamamos después de tener
            ; GDI+ inicializado. Antes era imposible controlar esto
            ; porque __New() se disparaba solo, antes que cualquier cosa.
            ; ══════════════════════════════════════════════════════════
            ToastTheme.InitThemes()

            OnExit((*) => Toastify.Shutdown())
            OnMessage(0x201, (wParam, lParam, msg, hwnd) => Toastify.__Click(wParam, lParam, msg, hwnd))

            DllCall("Winmm.dll\timeBeginPeriod", "UInt", 2)
            ProcessSetPriority(Toastify.PRIORITY.HIGH)

            Toastify.__globalTimer := ObjBindMethod(Toastify, "__globalTick")
            Toastify.__lastTickTime := A_TickCount
            SetTimer(Toastify.__globalTimer, -16)

            Toastify.__watchdogTimer := ObjBindMethod(Toastify, "__watchdogTick")
            SetTimer(Toastify.__watchdogTimer, 100)

            Toastify.__mouseTimer := ObjBindMethod(Toastify, "__mouseTimerTick")
            SetTimer(Toastify.__mouseTimer, 50)
        }
        Toastify.theme := theme
        Toastify.position := position
    }

    static Shutdown(*) {
        if Toastify.__globalTimer
            SetTimer(Toastify.__globalTimer, 0)
        if Toastify.__watchdogTimer
            SetTimer(Toastify.__watchdogTimer, 0)
        if Toastify.__mouseTimer
            SetTimer(Toastify.__mouseTimer, 0)


        ToastMouseHook.Stop()

        for t in Toastify.toasts {
            t.Destroy()
        }
        for t in Toastify.exitingToasts {
            t.Destroy()
        }


        for hwnd, data in Toastify.registry {
            try DllCall("DestroyWindow", "ptr", hwnd)
        }
        Toastify.registry.Clear()
        Toastify.toasts := []
        Toastify.exitingToasts := []


        DllCall("Winmm.dll\timeEndPeriod", "UInt", 2)


        ProcessSetPriority(Toastify.PRIORITY.NORMAL)

        if Toastify.pToken {
            ToastTheme.Shutdown()
            Gdip_Shutdown(Toastify.pToken)
            Toastify.pToken := 0
        }
    }


    static __watchdogTick(*) {
        Critical()
        now := A_TickCount
        toRemove := []

        for hwnd, data in Toastify.registry.Clone() {
            if (!DllCall("IsWindow", "ptr", hwnd)) {
                toRemove.Push(hwnd)
                continue
            }

            t := (data.HasOwnProp("instance") && data.instance) ? data.instance : 0

            if (t && t.hovered && t.progressPaused && Toastify.hoverPauseEnabled) {
                continue
            }

            if (data.duration > 0 && t) {
                expectedLifetime := t.animDuration + data.duration + 500
                actualLifetime := now - data.startTime

                if (actualLifetime > expectedLifetime) {
                    if (t.animState == "out") {
                        if (actualLifetime > expectedLifetime + t.animDuration + 500) {
                            t.Dismiss(true)   ; ← antes: t.Dismiss()  — ahora explícito instant=true
                            toRemove.Push(hwnd)
                        }
                    } else {
                        t.StartExit()
                    }
                }
            } else if (data.duration > 0 && !t) {
                if (now - data.startTime > data.duration + 1000) {
                    toRemove.Push(hwnd)
                }
            }
        }

        ; Limpiar registry fuera del loop principal
        for hwnd in toRemove {
            if (Toastify.registry.Has(hwnd))
                Toastify.registry.Delete(hwnd)
        }
    }


    static Show(title := "", body := "", actions := [], opts := 0) {
        if !opts
            opts := {}
        return Toastify.__createToast(title, body, actions, opts)
    }

    static Success(title, body := "", actions := [], opts := 0) {
        if !opts
            opts := {}
        opts.theme := "success"
        opts.icon := "success"
        return Toastify.Show(title, body, actions, opts)
    }

    static Error(title, body := "", actions := [], opts := 0) {
        if !opts
            opts := {}
        opts.theme := "error"
        opts.icon := "error"
        return Toastify.Show(title, body, actions, opts)
    }

    static Warning(title, body := "", actions := [], opts := 0) {
        if !opts
            opts := {}
        opts.theme := "warning"
        opts.icon := "warning"
        return Toastify.Show(title, body, actions, opts)
    }

    static Info(title, body := "", actions := [], opts := 0) {
        if !opts
            opts := {}
        opts.theme := "info"
        opts.icon := "info"
        return Toastify.Show(title, body, actions, opts)
    }

    static Custom(opts) {
        title := opts.HasProp("title") ? opts.title : ""
        body := opts.HasProp("body") ? opts.body : ""
        actions := opts.HasProp("actions") ? opts.actions : []
        return Toastify.Show(title, body, actions, opts)
    }

    static ShowView(viewItems, opts := 0) {
        t := Toast("", "", [], opts)
        t.view := viewItems
        Toastify.toasts.Push(t)
        Toastify.__reflow(true)
        t.InitAnimation()
        t.Draw()
        t.AnimateIn()
        return t
    }

    static DismissAll() {
        for t in Toastify.toasts.Clone() {
            t.StartExit()
        }
    }
    static __createToast(title, body, actions, opts) {
        if !opts
            opts := {}

        if !opts.HasProp("theme")
            opts.theme := Toastify.theme
        if !opts.HasProp("position")
            opts.position := Toastify.position

        if (Toastify.toasts.Length >= Toastify.maxToasts) {
            if (Toastify.toasts.Length > 0) {
                oldestToast := Toastify.toasts[1]
                oldestToast.StartExit()
            }
        }

        t := Toast(title, body, actions, opts)
        Toastify.toasts.Push(t)
        Toastify.__reflow(true)

        ; ═══════════════════════════════════════════════════════════════
        ; CAMBIO CLAVE: AnimateIn() antes de Draw()
        ; ═══════════════════════════════════════════════════════════════
        t.InitAnimation()
        t.AnimateIn()  ; Establece _initialized = true y posición inicial
        t.Draw()       ; Ahora sí puede renderizar correctamente

        return t
    }

    static __reflow(animate := true) {
        if (Toastify.toasts.Length = 0)
            return

        ; Agrupar toasts por position
        groups := Map()
        for t in Toastify.toasts {
            pos := t.position
            if !groups.Has(pos)
                groups[pos] := []
            groups[pos].Push(t)
        }

        screenCX := A_ScreenWidth // 2
        screenCY := A_ScreenHeight // 2
        now := A_TickCount

        for pos, group in groups {
            isBottom := InStr(pos, "bottom") || pos = "bottom"
            isMidV := (pos = "left" || pos = "right" || pos = "center")
            total := group.Length

            _getX(t) {
                if (InStr(pos, "right") || pos = "right")
                    return A_ScreenWidth - Toastify.marginX - t.width
                if (InStr(pos, "left") || pos = "left")
                    return Toastify.marginX
                return screenCX - t.width // 2
            }

            targets := []
            if (!isBottom && !isMidV) {
                cursor := Toastify.marginY
                for t in group {
                    targets.Push({ x: _getX(t), y: cursor })
                    cursor += t.height + Toastify.spacing
                }
            } else if (isBottom) {
                cursor := A_ScreenHeight - Toastify.marginY
                loop total {
                    idx := total + 1 - A_Index
                    t := group[idx]
                    cursor -= t.height
                    targets.Push({ x: _getX(t), y: cursor })
                    cursor -= Toastify.spacing
                }
                reversed := []
                loop targets.Length
                    reversed.Push(targets[targets.Length + 1 - A_Index])
                targets := reversed
            } else {
                totalH := 0
                for t in group
                    totalH += t.height + Toastify.spacing
                totalH -= Toastify.spacing
                cursor := screenCY - totalH // 2
                for t in group {
                    targets.Push({ x: _getX(t), y: cursor })
                    cursor += t.height + Toastify.spacing
                }
            }

            for idx, t in group {
                x := targets[idx].x
                y := targets[idx].y
                t.targetX := x
                t.targetY := y

                if (!t._initialized) {
                    t.currentX := x
                    t.currentY := y
                } else if (t.animState == "in") {
                    entrance := t.resolvedEntrance
                    if (entrance = "right" || entrance = "left")
                        t.animStartY := y
                    else
                        t.animStartX := x
                } else if (t.animState == "visible") {
                    if (animate) {
                        if (Abs(t.repoTargetX - x) > 0.5 || Abs(t.repoTargetY - y) > 0.5) {
                            t.repoStartX := t.currentX
                            t.repoStartY := t.currentY
                            t.repoTargetX := x
                            t.repoTargetY := y
                            t.repoStartTime := now
                            t.repoActive := true
                        }
                    } else {
                        t.repoActive := false
                        t.currentX := x
                        t.currentY := y
                        if (t.hwnd && DllCall("IsWindow", "ptr", t.hwnd))
                            t.UpdateWindow(x, y)
                    }
                }
            }
        }
    }

    static __globalTick(*) {
        Critical()

        now := A_TickCount
        elapsed := now - Toastify.__lastTickTime
        Toastify.__lastTickTime := now

        SetTimer(Toastify.__globalTimer, -Max(1, 16 - elapsed))


        while (Toastify.toasts.Length > Toastify.maxToasts) {
            if (Toastify.toasts.Length > 0) {
                t := Toastify.toasts[1]
                t.StartExit()
                if (Toastify.toasts.Length > 0 && Toastify.toasts[1] == t) {
                    Toastify.toasts.RemoveAt(1)
                    local found := false
                    for exiting in Toastify.exitingToasts {
                        if (exiting == t) {
                            found := true
                            break
                        }
                    }
                    if (!found)
                        Toastify.exitingToasts.Push(t)
                }
            } else {
                break
            }
        }

        ; ── Si hay toasts saliendo, recalcular targets en cada tick ──
        ; Esto mantiene el gap-fill sincronizado con la animación de salida
        ; if (Toastify.exitingToasts.Length > 0 && Toastify.toasts.Length > 0)
        ;     Toastify.__reflow(true)

        toastsToExit := []
        for t in Toastify.toasts {
            if (t.animState == "out") {
                toastsToExit.Push(t)
                continue
            }
            t.Tick()
        }
        for t in toastsToExit {
            t.StartExit()
        }


        i := 1
        while (i <= Toastify.exitingToasts.Length) {
            t := Toastify.exitingToasts[i]
            t.Tick()

            if (t.animState == "out" && (A_TickCount - t.animStartTime > t.animDuration)) {
                t.Dismiss(true)   ; ← antes: t.Dismiss()  — ahora explícito instant=true
                Toastify.__reflow(true)
            } else {
                i++
            }
        }
    }

    static __checkHover(t, x, y) {
        if (!t.hwnd)
            return

        wasInside := t.hovered
        isInside := (x >= t.currentX && x <= t.currentX + t.width && y >= t.currentY && y <= t.currentY + t.height)

        if (isInside && !wasInside) {
            relX := x - t.currentX
            relY := y - t.currentY
            t.OnMouseMove(relX, relY)
        } else if (!isInside && wasInside) {
            t.OnMouseLeave()
        } else if (isInside) {
            relX := x - t.currentX
            relY := y - t.currentY
            t.OnMouseMove(relX, relY)
        }
    }

    static __mouseTimerTick(*) {
        Critical()

        MouseGetPos(&x, &y)


        for t in Toastify.toasts {
            Toastify.__checkHover(t, x, y)
        }


        for t in Toastify.exitingToasts {
            Toastify.__checkHover(t, x, y)
        }
    }

    static __mouseMoveHook(x, y, prevX, prevY) {
        for t in Toastify.toasts.Clone()
            Toastify.__checkHover(t, x, y)
        for t in Toastify.exitingToasts
            Toastify.__checkHover(t, x, y)
    }

    static __Click(wParam, lParam, msg, hwnd) {
        for t in Toastify.toasts {
            if (t.hwnd == hwnd) {
                x := lParam & 0xFFFF
                y := (lParam >> 16) & 0xFFFF
                t.OnClick(x, y)
                return
            }
        }
        for t in Toastify.exitingToasts {
            if (t.hwnd == hwnd) {
                x := lParam & 0xFFFF
                y := (lParam >> 16) & 0xFFFF
                t.OnClick(x, y)
                return
            }
        }
    }


}


class ToastMouseHook {
    static mouseHook := 0
    static mouseProc := 0
    static lastX := 0
    static lastY := 0
    static callback := 0

    static Start(callback) {
        ToastMouseHook.callback := callback
        if (!ToastMouseHook.mouseProc) {
            ToastMouseHook.mouseProc := CallbackCreate((nCode, wParam, lParam) => ToastMouseHook.__MouseLLProc(nCode,
                wParam, lParam), "int, UPtr, Ptr")
        }
        if (!ToastMouseHook.mouseHook) {
            ToastMouseHook.mouseHook := DllCall("user32\SetWindowsHookEx", "int", 14, "ptr", ToastMouseHook.mouseProc,
                "ptr", 0, "uint", 0, "ptr")
        }
        MouseGetPos(&x, &y)
        ToastMouseHook.lastX := x
        ToastMouseHook.lastY := y
    }

    static Stop() {
        if (ToastMouseHook.mouseHook) {
            DllCall("user32\UnhookWindowsHookEx", "ptr", ToastMouseHook.mouseHook)
            ToastMouseHook.mouseHook := 0
        }
        if (ToastMouseHook.mouseProc) {
            CallbackFree(ToastMouseHook.mouseProc)
            ToastMouseHook.mouseProc := 0
        }
        ToastMouseHook.callback := 0
    }

    static __MouseLLProc(nCode, wParam, lParam) {
        if (nCode >= 0 && wParam == 0x0200) {
            x := NumGet(lParam, 0, "int")
            y := NumGet(lParam, 4, "int")
            prevX := ToastMouseHook.lastX
            prevY := ToastMouseHook.lastY
            ToastMouseHook.lastX := x
            ToastMouseHook.lastY := y

            if (ToastMouseHook.callback)
                try ToastMouseHook.callback(x, y, prevX, prevY)
        }
        return DllCall("user32\CallNextHookEx", "ptr", 0, "int", nCode, "UPtr", wParam, "ptr", lParam, "ptr")
    }
}

class ToastTheme {
    static themes := Map()

    ; Ya NO se llama __New() — así no se ejecuta automáticamente
    ; antes de que exista contexto GDI+.
    static InitThemes() {
        if (ToastTheme.themes.Count > 0)
            return  ; ya inicializado, evita duplicar/leakear handles

        ToastTheme.Register("error", {
            bg1: 0xEE2D1517, bg2: 0xEE1A0D10,
            fg: 0xFFFCA5A5, accent: 0xFFEF4444,
            shadow: 0x66EF4444, progress: 0xFFDC2626
        })
        ToastTheme.Register("error-light", {
            bg1: 0xFFFEF2F2, bg2: 0xFFFEE2E2,
            fg: 0xFF991B1B, accent: 0xFFDC2626,
            shadow: 0x22DC2626, progress: 0xFFEF4444
        })
        ToastTheme.Register("warning", {
            bg1: 0xEE2D1B0E, bg2: 0xEE1A1008,
            fg: 0xFFFCD34D, accent: 0xFFF97316,
            shadow: 0x66F97316, progress: 0xFFEA580C
        })
        ToastTheme.Register("warning-light", {
            bg1: 0xFFFFFBEB, bg2: 0xFFFEF3C7,
            fg: 0xFF92400E, accent: 0xFFD97706,
            shadow: 0x22D97706, progress: 0xFFF59E0B
        })
        ToastTheme.Register("success", {
            bg1: 0xEE0A2312, bg2: 0xEE06140B,
            fg: 0xFF6EE7B7, accent: 0xFF10B981,
            shadow: 0x6610B981, progress: 0xFF059669
        })
        ToastTheme.Register("success-light", {
            bg1: 0xFFF0FDF4, bg2: 0xFFDCFCE7,
            fg: 0xFF065F46, accent: 0xFF059669,
            shadow: 0x22059669, progress: 0xFF10B981
        })
        ToastTheme.Register("info", {
            bg1: 0xEE0F2035, bg2: 0xEE0A1525,
            fg: 0xFF93C5FD, accent: 0xFF3B82F6,
            shadow: 0x663B82F6, progress: 0xFF2563EB
        })
        ToastTheme.Register("info-light", {
            bg1: 0xFFEFF6FF, bg2: 0xFFDBEAFE,
            fg: 0xFF1E40AF, accent: 0xFF2563EB,
            shadow: 0x222563EB, progress: 0xFF3B82F6
        })

        ; ── BASE ────────────────────────────────────────────────────
        ToastTheme.Register("dark", {
            bg1: 0xEE1F2937, bg2: 0xEE111827,
            fg: 0xFFF9FAFB, accent: 0xFF60A5FA,
            shadow: 0x66000000, progress: 0xFF3B82F6
        })
        ToastTheme.Register("light", {
            bg1: 0xFFFFFFFF, bg2: 0xFFF8F9FA,
            fg: 0xFF1F2937, accent: 0xFF3B82F6,
            shadow: 0x33000000, progress: 0xFF3B82F6
        })

        ; ── ESPECIALES ──────────────────────────────────────────────
        ToastTheme.Register("midnight", {
            bg1: 0xEE0F172A, bg2: 0xEE1E293B,
            fg: 0xFFE2E8F0, accent: 0xFF38BDF8,
            shadow: 0x660F172A, progress: 0xFF0EA5E9
        })
        ToastTheme.Register("midnight-light", {
            bg1: 0xFFE0F2FE, bg2: 0xFFBAE6FD,
            fg: 0xFF0369A1, accent: 0xFF0284C7,
            shadow: 0x220369A1, progress: 0xFF0EA5E9
        })
        ToastTheme.Register("forest", {
            bg1: 0xEE052E16, bg2: 0xEE064E3B,
            fg: 0xFFD1FAE5, accent: 0xFF34D399,
            shadow: 0x66064E3B, progress: 0xFF10B981
        })
        ToastTheme.Register("forest-light", {
            bg1: 0xFFECFDF5, bg2: 0xFFD1FAE5,
            fg: 0xFF065F46, accent: 0xFF059669,
            shadow: 0x22065F46, progress: 0xFF10B981
        })
        ToastTheme.Register("neon", {
            bg1: 0xEE0F0518, bg2: 0xEE1A0B2E,
            fg: 0xFFE9D5FF, accent: 0xFFD946EF,
            shadow: 0x88D946EF, progress: 0xFFC026D3
        })
        ToastTheme.Register("neon-light", {
            bg1: 0xFFFDF5FF, bg2: 0xFFF3E8FF,
            fg: 0xFF6B21A8, accent: 0xFF9333EA,
            shadow: 0x229333EA, progress: 0xFFA855F7
        })
        ToastTheme.Register("vapor", {
            bg1: 0xEE10002B, bg2: 0xEE240046,
            fg: 0xFFE0AAFF, accent: 0xFF00FFFF,
            shadow: 0x6600FFFF, progress: 0xFF9D4EDD
        })
        ToastTheme.Register("vapor-light", {
            bg1: 0xFFFFF0F5, bg2: 0xFFE0F7FA,
            fg: 0xFF5D3FD3, accent: 0xFF00CED1,
            shadow: 0x2200CED1, progress: 0xFFDA70D6
        })
        ToastTheme.Register("cyberpunk", {
            bg1: 0xEE000000, bg2: 0xEE050505,
            fg: 0xFFFCEE0A, accent: 0xFF00F0FF,
            shadow: 0x66FCEE0A, progress: 0xFFFF003C
        })
        ToastTheme.Register("cyberpunk-light", {
            bg1: 0xFFFCEE0A, bg2: 0xFFFFF566,
            fg: 0xFF000000, accent: 0xFF000000,
            shadow: 0x44000000, progress: 0xFF000000
        })
        ToastTheme.Register("retro", {
            bg1: 0xEE000000, bg2: 0xEE000000,
            fg: 0xFF33FF00, accent: 0xFF33FF00,
            shadow: 0x0033FF00, progress: 0xFF33FF00
        })
        ToastTheme.Register("retro-light", {
            bg1: 0xFFF4E4BC, bg2: 0xFFE6D6AC,
            fg: 0xFF4B3621, accent: 0xFF6F4E37,
            shadow: 0x224B3621, progress: 0xFF8B4513
        })
        ToastTheme.Register("glass", {
            bg1: 0xAA1F2937, bg2: 0xAA111827,
            fg: 0xFFFFFFFF, accent: 0x88FFFFFF,
            shadow: 0x22000000, progress: 0xAAFFFFFF
        })
        ToastTheme.Register("glass-light", {
            bg1: 0xAAFFFFFF, bg2: 0xAAF8F9FA,
            fg: 0xFF000000, accent: 0x88000000,
            shadow: 0x11000000, progress: 0xAA000000
        })
        ToastTheme.Register("minimal", {
            bg1: 0xFF000000, bg2: 0xFF000000,
            fg: 0xFFFFFFFF, accent: 0xFFFFFFFF,
            shadow: 0x00000000, progress: 0xFF888888
        })
        ToastTheme.Register("minimal-light", {
            bg1: 0xFFFFFFFF, bg2: 0xFFFFFFFF,
            fg: 0xFF000000, accent: 0xFF000000,
            shadow: 0x22000000, progress: 0xFF888888
        })
        ToastTheme.Register("pastel", {
            bg1: 0xEE2D2D2D, bg2: 0xEE252525,
            fg: 0xFFFFD1DC, accent: 0xFFAEC6CF,
            shadow: 0x44000000, progress: 0xFFB39EB5
        })
        ToastTheme.Register("pastel-light", {
            bg1: 0xFFFFF9FB, bg2: 0xFFFDF0F5,
            fg: 0xFF6B5B95, accent: 0xFFFFB347,
            shadow: 0x22000000, progress: 0xFFFF6961
        })
        ToastTheme.Register("flat", {
            bg1: 0xFF2C3E50, bg2: 0xFF2C3E50,
            fg: 0xFFECF0F1, accent: 0xFFBDC3C7,
            shadow: 0x00000000, progress: 0xFF95A5A6
        })
        ToastTheme.Register("flat-light", {
            bg1: 0xFFECF0F1, bg2: 0xFFECF0F1,
            fg: 0xFF2C3E50, accent: 0xFF95A5A6,
            shadow: 0x00000000, progress: 0xFF7F8C8D
        })
    }

    static Register(name, palette) {
        if !palette.HasOwnProp("border") {
            ; ══════════════════════════════════════════════════════════
            ; FIX: el borde ahora usa el accent del tema (contextualizado),
            ; en vez de solo blanco/negro según luminosidad del fondo.
            ; Se le aplica una opacidad fuerte para que se note bien
            ; (ej: error -> rojo intenso, success -> verde intenso).
            ; ══════════════════════════════════════════════════════════
            accentRGB := palette.accent & 0xFFFFFF
            palette.border := 0xCC000000 | accentRGB   ; 0xCC = ~80% opacidad
        }
        if !palette.HasOwnProp("progressBg") {
            c := palette.bg1 & 0xFFFFFF
            lum := ((c >> 16) & 0xFF) * 0.299 + ((c >> 8) & 0xFF) * 0.587 + (c & 0xFF) * 0.114
            palette.progressBg := lum < 128 ? 0x55FFFFFF : 0x33000000
        }

        ; ══════════════════════════════════════════════════════════════
        ; FIX: ancho de borde configurable por tema (default 1.5, pero
        ; cada palette puede sobreescribir con borderWidth si quiere).
        ; ══════════════════════════════════════════════════════════════
        if !palette.HasOwnProp("borderWidth")
            palette.borderWidth := 1.5

        palette.shadowBrush := Gdip_BrushCreateSolid(palette.shadow)
        palette.borderPen := Gdip_CreatePen(palette.border, palette.borderWidth)
        ; MsgBox("borderPen: " palette.borderPen "`n")
        palette.accentBrush := Gdip_BrushCreateSolid(palette.accent)
        palette.btnBorderPen := Gdip_CreatePen(0x44FFFFFF, 1)
        palette.btnFillBrush := Gdip_BrushCreateSolid(0x33000000)
        palette.progressBgBrush := Gdip_BrushCreateSolid(palette.progressBg)
        palette.progressFillBrush := Gdip_BrushCreateSolid(palette.progress)
        palette.iconWhiteBrush := Gdip_BrushCreateSolid(0xFFFFFFFF)
        palette.iconWhitePen := Gdip_CreatePen(0xFFFFFFFF, 3)
        palette.iconWhitePen2 := Gdip_CreatePen(0xFFFFFFFF, 2)
        ToastTheme.themes[name] := palette

    }

    static palette(theme) {
        if (ToastTheme.themes.Has(theme))
            return ToastTheme.themes[theme]
        return ToastTheme.themes["dark"]
    }

    static Shutdown() {

        for name, pal in ToastTheme.themes {
            try Gdip_DeleteBrush(pal.shadowBrush)
            try Gdip_DeletePen(pal.borderPen)
            try Gdip_DeleteBrush(pal.accentBrush)
            try Gdip_DeletePen(pal.btnBorderPen)
            try Gdip_DeleteBrush(pal.btnFillBrush)
            try Gdip_DeleteBrush(pal.progressBgBrush)
            try Gdip_DeleteBrush(pal.progressFillBrush)
            try Gdip_DeleteBrush(pal.iconWhiteBrush)
            try Gdip_DeletePen(pal.iconWhitePen)
            try Gdip_DeletePen(pal.iconWhitePen2)
        }
    }
}

class ToastConfig {
    fontName := "Segoe UI Emoji"
    fontSizeTitle := 16
    fontSizeBody := 13
    fontWeightTitle := "Bold"
    fontWeightBody := "Normal"

    width := 340
    minHeight := 120
    paddingX := 16
    paddingY := 14
    iconSize := 32
    borderRadius := 18
    borderWidth := 0


    animDuration := 300
    animEasing := "easeOutCubic"
    animStyle := "slide"
    animEntrance := "auto"

    repoDuration := 300


    renderQuality := "High"

}


class Toast {
    title := ""
    body := ""
    actions := []
    width := 340
    height := 120
    duration := 3000
    theme := "dark"
    position := "top-right"
    icon := ""
    showClose := true
    showProgress := true
    hwnd := 0
    gui := 0
    hbm := 0
    hdc := 0
    obm := 0
    G := 0
    ; ── Posición de salida fija (no cambia por reflow) ──
    exitTargetX := 0
    exitTargetY := 0
    exitStartX := 0
    exitStartY := 0

    ; Static key lists at class level (can't use static inside if-blocks in AHKv2)
    static _cfgKeys := ["width", "fontName", "fontSizeTitle", "fontSizeBody", "fontWeightTitle", "fontWeightBody",
        "paddingX", "paddingY", "iconSize", "borderRadius", "borderWidth", "animDuration", "animEasing",
        "animStyle", "animEntrance", "renderQuality", "repoDuration"]
    static _styleKeys := ["fontName", "fontSizeTitle", "fontSizeBody", "fontWeightTitle", "fontWeightBody",
        "paddingX", "paddingY", "iconSize", "borderRadius", "borderWidth", "animDuration", "renderQuality"]


    pBitmapCache := 0
    GCache := 0
    cacheDirty := true


    targetX := 0
    targetY := 0
    currentX := 0
    currentY := 0


    repoStartX := 0
    repoStartY := 0
    repoTargetX := 0
    repoTargetY := 0
    repoStartTime := 0
    repoDuration := 250
    repoActive := false


    animState := "idle"
    animStartTime := 0
    animDuration := 300
    animEasing := "easeOutCubic"
    animStyle := ["fade"]
    animEntrance := "auto"


    opacity := 1.0
    scale := 1.0
    rotation := 0.0
    resolvedEntrance := "right"


    _hasSlide := false
    _hasFade := false
    _hasZoom := false
    _hasRotate := false


    bufferWidth := 0
    bufferHeight := 0


    progress := 0.0
    progressStartTime := 0
    progressPaused := false
    progressPauseTime := 0
    lastProgress := 0.0


    creationTime := 0


    clickRegions := []
    hovered := false
    closeHovered := false
    onClickCallback := 0
    onCloseCallback := 0
    userInitiatedExit := false


    autoDismiss := true


    progressCompleteTime := 0
    static progressGracePeriod := 300


    fontName := "Segoe UI"
    fontSizeTitle := 16
    fontSizeBody := 11
    fontWeightTitle := "Bold"
    fontWeightBody := "Normal"
    paddingX := 16
    paddingY := 14
    iconSize := 32
    borderRadius := 18
    borderWidth := 0
    renderQuality := "High"


    _windowShown := false
    _initialized := false

    __New(title, body, actions, opts) {
        this.title := title
        this.body := body
        this.actions := actions

        cfg := Toastify.config
        for key in Toast._cfgKeys {
            if cfg.HasProp(key)
                this.%key% := cfg.%key%
        }

        if IsObject(opts) {
            try {
                if opts.HasProp("width")
                    this.width := opts.width
                if opts.HasProp("duration")
                    this.duration := opts.duration
                if opts.HasProp("theme")
                    this.theme := opts.theme
                if opts.HasProp("position")
                    this.position := opts.position
                if opts.HasProp("icon")
                    this.icon := opts.icon
                if opts.HasProp("showClose")
                    this.showClose := opts.showClose
                if opts.HasProp("showProgress")
                    this.showProgress := opts.showProgress
                if opts.HasProp("onClick")
                    this.onClickCallback := opts.onClick
                if opts.HasProp("onClose")
                    this.onCloseCallback := opts.onClose
            }

            for key in Toast._styleKeys {
                try {
                    if opts.HasProp(key)
                        this.%key% := opts.%key%
                }
            }

            this.progressPaused := false

            try {
                if opts.HasProp("animStyle")
                    this.animStyle := opts.animStyle
                else
                    this.animStyle := Toastify.config.animStyle
            }

            if Type(this.animStyle) == "String" {
                this.animStyle := [this.animStyle]
            } else if !HasProp(this.animStyle, "Length") {
                this.animStyle := ["fade"]
            }

            try {
                if opts.HasProp("animEasing")
                    this.animEasing := opts.animEasing
                else
                    this.animEasing := Toastify.config.animEasing
            }

            try {
                if opts.HasProp("animEntrance")
                    this.animEntrance := opts.animEntrance
                else
                    this.animEntrance := Toastify.config.animEntrance
            }

            try {
                if opts.HasProp("autoDismiss")
                    this.autoDismiss := !!opts.autoDismiss
            }

            isPermanent := false
            try {
                if opts.HasProp("permanent")
                    isPermanent := !!opts.permanent
            }
            if (isPermanent) {
                this.autoDismiss := false
                if !opts.HasProp("duration")
                    this.duration := 0
                if !opts.HasProp("showProgress")
                    this.showProgress := false
            }
        }

        this.creationTime := A_TickCount
        this.__createWindow()
    }

    __createWindow() {
        this.gui := Gui("-Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs")
        this.hwnd := this.gui.Hwnd
        this._windowShown := false


        this.hbm := CreateDIBSection(this.width, this.height)
        this.hdc := CreateCompatibleDC()
        this.obm := SelectObject(this.hdc, this.hbm)
        this.G := Gdip_GraphicsFromHDC(this.hdc)
        Gdip_SetSmoothingMode(this.G, 4)

        ; Usar tamaño exacto. El clip en RenderToWindow evita que se vea negro.
        this.bufferWidth := this.width
        this.bufferHeight := this.height


        this.pBitmapCache := Gdip_CreateBitmap(this.width, this.height)
        this.GCache := Gdip_GraphicsFromImage(this.pBitmapCache)

        this.__applyRenderQuality(this.GCache, true)


        Toastify.registry[this.hwnd] := {
            startTime: A_TickCount,
            duration: this.autoDismiss ? this.duration : 0,
            instance: this
        }
    }

    ; Applies GDI+ render quality settings to a Graphics context.
    ; isCache=true uses text rendering hint (for off-screen cache), false skips it.
    __applyRenderQuality(G, isCache := false) {
        if (this.renderQuality = "Low") {
            Gdip_SetSmoothingMode(G, 1)
            if isCache
                Gdip_SetTextRenderingHint(G, 3)
            DllCall("gdiplus\GdipSetPixelOffsetMode", "ptr", G, "int", 1)
            DllCall("gdiplus\GdipSetCompositingQuality", "ptr", G, "int", 1)
            if !isCache
                Gdip_SetInterpolationMode(G, 5)
        } else if (this.renderQuality = "Medium") {
            Gdip_SetSmoothingMode(G, 4)
            if isCache
                Gdip_SetTextRenderingHint(G, 4)
            DllCall("gdiplus\GdipSetPixelOffsetMode", "ptr", G, "int", 2)
            DllCall("gdiplus\GdipSetCompositingQuality", "ptr", G, "int", 2)
            if !isCache
                Gdip_SetInterpolationMode(G, 6)
        } else {
            Gdip_SetSmoothingMode(G, 4)
            if isCache
                Gdip_SetTextRenderingHint(G, 5)
            DllCall("gdiplus\GdipSetPixelOffsetMode", "ptr", G, "int", 2)
            DllCall("gdiplus\GdipSetCompositingQuality", "ptr", G, "int", 2)
            if !isCache
                Gdip_SetInterpolationMode(G, 7)
        }
    }

    Draw() {
        if (!this._initialized)
            return

        ; Solo redibujar el cache estático si algo cambió (texto, progreso, hover)
        if (this.cacheDirty) {
            this.__drawCache()
            this.cacheDirty := false
        }

        ; Siempre actualizar la ventana (posición, escala, rotación, opacidad)
        this.RenderToWindow()
    }

    __drawCache() {
        pal := ToastTheme.palette(this.theme)
        this.clickRegions := []

        Gdip_GraphicsClear(this.GCache)

        Gdip_FillRoundedRectangle(this.GCache, pal.shadowBrush, 4, 4, this.width, this.height, this.borderRadius)

        pBrush := Gdip_CreateLineBrushFromRect(0, 0, this.width, this.height, pal.bg1, pal.bg2, 1, 1)
        Gdip_FillRoundedRectangle(this.GCache, pBrush, 0, 0, this.width, this.height, this.borderRadius)
        Gdip_DeleteBrush(pBrush)

        ; ══════════════════════════════════════════════════════════════════
        ; FIX: si el toast define un borderWidth propio (>0), se crea un pen
        ; temporal con ese ancho. Si no, se usa el pen cacheado del tema
        ; (más eficiente, sin alloc por frame).
        ; ══════════════════════════════════════════════════════════════════
        if (this.borderWidth > 0) {
            customBorderPen := Gdip_CreatePen(pal.border, this.borderWidth)
            Gdip_DrawRoundedRectangle(this.GCache, customBorderPen, 2, 2, this.width - 4, this.height - 4, this.borderRadius - 1)
            Gdip_DeletePen(customBorderPen)
        } else {
            Gdip_DrawRoundedRectangle(this.GCache, pal.borderPen, 2, 2, this.width - 4, this.height - 4, this.borderRadius - 1)
        }
        ; Gdip_DrawRoundedRectangle(this.GCache, pal.borderPen, 2, 2, this.width - 4, this.height - 4, this.borderRadius - 1)

        iconX := this.paddingX
        iconY := this.paddingY
        iconSize := this.iconSize
        textStartX := this.paddingX

        if (this.icon != "") {
            this.DrawIcon(iconX, iconY, iconSize, this.icon, pal)
            textStartX := iconX + iconSize + 12
        }

        if (this.showClose) {
            this.DrawCloseButton(pal)
        }

        font := this.fontName
        titleWidth := this.width - textStartX - (this.showClose ? 40 : this.paddingX)

        if (this.title != "") {
            titleOpts := "x" textStartX " y" this.paddingY " w" titleWidth " c" Format("{:x}", pal.fg) " r4 s" this.fontSizeTitle " " this.fontWeightTitle
            Gdip_TextToGraphics(this.GCache, this.title, titleOpts, font, this.width, this.height)
        }

        if (this.body != "") {
            bodyY := (this.title != "") ? (this.paddingY + this.fontSizeTitle * 1.5 + 4) : this.paddingY
            availableHeight := this.height - bodyY - this.paddingY
            if (this.actions.Length > 0)
                availableHeight -= 38
            if (this.showProgress && this.duration > 0)
                availableHeight -= 12

            bodyHeight := Max(20, availableHeight)
            bodyOpts := "x" textStartX " y" bodyY " w" titleWidth " h" bodyHeight " c" Format("{:x}", pal.fg) " r4 s" this.fontSizeBody " " this.fontWeightBody
            Gdip_TextToGraphics(this.GCache, this.body, bodyOpts, font, this.width, this.height)
        }

        if (this.actions.Length) {
            btnW := (this.width - 32 - (this.actions.Length - 1) * 8) // this.actions.Length
            y := this.height - (this.showProgress ? 50 : 40)
            x := 16
            for idx, act in this.actions {
                rectX := x, rectY := y, rectW := btnW, rectH := 28
                Gdip_FillRoundedRectangle(this.GCache, pal.accentBrush, rectX, rectY, rectW, rectH, 6)
                Gdip_DrawRoundedRectangle(this.GCache, pal.btnBorderPen, rectX, rectY, rectW, rectH, 6)
                txtOpts := "x" (rectX + 10) " y" (rectY + 6) " w" (rectW - 20) " cFFFFFFFF r4 s" this.fontSizeBody " Centre Bold"
                Gdip_TextToGraphics(this.GCache, act.HasProp("text") ? act.text : act[1], txtOpts, font, this.width, this.height)
                this.clickRegions.Push({ x: rectX, y: rectY, w: rectW, h: rectH, cb: (act.HasProp("onClick") ? act.onClick : act[2]), type: "button" })
                x += btnW + 8
            }
        }

        if (this.showProgress && this.duration > 0) {
            this.DrawProgressBar(pal)
        }
    }

    RenderToWindow() {
        ; Limpiar buffer con transparente absoluto
        Gdip_GraphicsClear(this.G, 0x00000000)

        ; Calcular offset para centrar el dibujo en el buffer
        drawX := (this.bufferWidth - this.width) / 2
        drawY := (this.bufferHeight - this.height) / 2

        if (this.scale != 1.0 || this.rotation != 0) {
            ; Si la escala es casi invisible, ocultar para ahorrar CPU
            if (this.scale < 0.01) {
                this.UpdateWindow(this.currentX, this.currentY, 0)
                return
            }

            this.__applyRenderQuality(this.G, false)

            Gdip_ResetWorldTransform(this.G)
            bufCX := this.bufferWidth / 2
            bufCY := this.bufferHeight / 2

            ; Aplicar transformaciones (Rotar/Escalar)
            Gdip_TranslateWorldTransform(this.G, bufCX, bufCY, 0)
            if (this.rotation != 0)
                Gdip_RotateWorldTransform(this.G, this.rotation, 0)
            if (this.scale != 1.0)
                Gdip_ScaleWorldTransform(this.G, this.scale, this.scale, 0)
            Gdip_TranslateWorldTransform(this.G, -bufCX, -bufCY, 0)

            ; ═══════════════════════════════════════════════════════════
            ; EL FATAL ERROR ESTABA AQUÍ: Antes tenía un 4 (XOR).
            ; Con 0 (REPLACE) recorta los bordes excesivos del Zoom/Rotate,
            ; pero SIN borrar el dibujo principal.
            ; ═══════════════════════════════════════════════════════════
            Gdip_SetClipRect(this.G, drawX, drawY, this.width, this.height, 0)

            Gdip_DrawImage(this.G, this.pBitmapCache, drawX, drawY, this.width, this.height, 0, 0, this.width, this.height)

            ; Limpiar Clip y Transformaciones
            Gdip_ResetClip(this.G)
            Gdip_ResetWorldTransform(this.G)
        } else {
            this.__applyRenderQuality(this.G, false)
            Gdip_DrawImage(this.G, this.pBitmapCache, drawX, drawY, this.width, this.height, 0, 0, this.width, this.height)
        }

        ; ACTUALIZAR VENTANA
        this.UpdateWindow(this.currentX, this.currentY, Floor(this.opacity * 255))
    }

    ResizeBuffer(w, h) {
        ; Obsoleto: El uso de Clipping en RenderToWindow hace innecesario redimensionar.
        return
    }
    ShrinkBuffer() {

        if (this.animState == "in" || this.animState == "out")
            return

        if (this.bufferWidth <= this.width && this.bufferHeight <= this.height)
            return

        SelectObject(this.hdc, this.obm)
        DeleteObject(this.hbm)
        Gdip_DeleteGraphics(this.G)

        this.bufferWidth := this.width
        this.bufferHeight := this.height

        this.hbm := CreateDIBSection(this.width, this.height)
        this.obm := SelectObject(this.hdc, this.hbm)
        this.G := Gdip_GraphicsFromHDC(this.hdc)
        Gdip_SetSmoothingMode(this.G, 4)
    }

    UpdateWindow(x, y, alpha := 255) {
        ; ═══════════════════════════════════════════════════════════════
        ; VALIDACIÓN: Verificar que la ventana y el gui son válidos
        ; ═══════════════════════════════════════════════════════════════
        if (!this.hwnd)
            return

        if (!DllCall("IsWindow", "ptr", this.hwnd))
            return

        ; Verificar que gui sea un objeto válido
        if (!IsObject(this.gui))
            return

        w := this.bufferWidth
        h := this.bufferHeight

        if (!this._windowShown) {
            this._windowShown := true
            try {
                this.gui.Show("NA")
            } catch {
                this._windowShown := false
                return
            }
        }

        UpdateLayeredWindow(this.hwnd, this.hdc, x, y, w, h, alpha)
    }

    DrawIcon(x, y, size, iconType, pal) {
        ; Use cached GDI+ objects from the theme palette - no per-frame alloc
        switch iconType {
            case "success":
                Gdip_FillEllipse(this.GCache, pal.accentBrush, x, y, size, size)
                points := x "," (y + size / 2) "|" (x + size / 3) "," (y + size * 2 / 3) "|" (x + size * 4 / 5) "," (y +
                    size / 4)
                Gdip_DrawLines(this.GCache, pal.iconWhitePen, points)
            case "error":
                Gdip_FillEllipse(this.GCache, pal.accentBrush, x, y, size, size)
                Gdip_DrawLine(this.GCache, pal.iconWhitePen, x + size / 4, y + size / 4, x + size * 3 / 4, y + size * 3 / 4)
                Gdip_DrawLine(this.GCache, pal.iconWhitePen, x + size * 3 / 4, y + size / 4, x + size / 4, y + size * 3 / 4)
            case "warning":
                points := (x + size / 2) "," y "|" x "," (y + size) "|" (x + size) "," (y + size)
                Gdip_FillPolygon(this.GCache, pal.accentBrush, points)
                Gdip_DrawLine(this.GCache, pal.iconWhitePen2, x + size / 2, y + size / 4, x + size / 2, y + size / 2)
                Gdip_FillEllipse(this.GCache, pal.iconWhiteBrush, x + size / 2 - 2, y + size * 2 / 3, 4, 4)
            case "info":
                Gdip_FillEllipse(this.GCache, pal.accentBrush, x, y, size, size)
                Gdip_FillEllipse(this.GCache, pal.iconWhiteBrush, x + size / 2 - 2, y + size / 4, 4, 4)
                Gdip_DrawLine(this.GCache, pal.iconWhitePen2, x + size / 2, y + size / 2.5, x + size / 2, y + size * 3 / 4)
        }
    }

    DrawCloseButton(pal) {
        closeSize := 20
        closeX := this.width - this.paddingX - closeSize
        closeY := this.paddingY - 4

        this.clickRegions.Push({
            x: closeX, y: closeY, w: closeSize, h: closeSize,
            cb: (*) => this.ForceClose(),
            type: "close"
        })

        if (this.closeHovered) {
            pBrushHover := Gdip_BrushCreateSolid(0x33FFFFFF)
            Gdip_FillEllipse(this.GCache, pBrushHover, closeX - 2, closeY - 2, closeSize + 4, closeSize + 4)
            Gdip_DeleteBrush(pBrushHover)
        }

        color := this.closeHovered ? 0xFFFFFFFF : 0xAAFFFFFF
        pPen := Gdip_CreatePen(color, 2)
        offset := 6
        Gdip_DrawLine(this.GCache, pPen, closeX + offset, closeY + offset, closeX + closeSize - offset, closeY +
            closeSize -
            offset)
        Gdip_DrawLine(this.GCache, pPen, closeX + closeSize - offset, closeY + offset, closeX + offset, closeY +
            closeSize -
            offset)
        Gdip_DeletePen(pPen)
    }

    DrawProgressBar(pal) {
        barHeight := 3
        barY := this.height - barHeight - 7
        barX := 14
        barWidth := this.width - 28

        Gdip_FillRoundedRectangle(this.GCache, pal.progressBgBrush, barX, barY, barWidth, barHeight, 2)

        if (this.progress > 0) {
            fillWidth := barWidth * this.progress
            Gdip_FillRoundedRectangle(this.GCache, pal.progressFillBrush, barX, barY, fillWidth, barHeight, 2)
        }
    }

    HasAnim(name) {
        for style in this.animStyle {
            if (style == name)
                return true
        }
        return false
    }

    InitAnimation() {

        this._hasSlide := this.HasAnim("slide")
        this._hasFade := this.HasAnim("fade")
        this._hasZoom := this.HasAnim("zoom")
        this._hasRotate := this.HasAnim("rotate")


        this.opacity := 1.0
        this.scale := 1.0
        this.rotation := 0.0


        entrance := this.animEntrance
        if (entrance == "auto") {
            if (this.position == "top-right" || this.position == "bottom-right")
                entrance := "right"
            else if (this.position == "top-left" || this.position == "bottom-left")
                entrance := "left"
            else if (this.position == "top-center")
                entrance := "top"
            else
                entrance := "bottom"
        }
        this.resolvedEntrance := entrance

        if (this._hasFade) {
            this.opacity := 0.0
        }

        if (this._hasZoom) {
            this.scale := 0.0
        }


        if (this._hasRotate) {
            this.rotation := -90.0

            diag := Sqrt(this.width ** 2 + this.height ** 2)
            this.ResizeBuffer(Ceil(diag), Ceil(diag))
        }


        startX := this.targetX
        startY := this.targetY

        if (this._hasSlide) {
            entrance := this.resolvedEntrance

            if (entrance == "right")
                startX := A_ScreenWidth
            else if (entrance == "left")
                startX := -this.width
            else if (entrance == "top")
                startY := -this.height
            else if (entrance == "bottom")
                startY := A_ScreenHeight
        } else {

            startX := this.targetX
            startY := this.targetY
        }

        this.currentX := startX
        this.currentY := startY

        this._initialized := true

    }

    AnimateIn() {
        ; Resolver dirección de entrada
        this.resolvedEntrance := this.animEntrance

        if (this.resolvedEntrance == "auto") {
            pos := Toastify.position
            if (InStr(pos, "right") || pos == "right")
                this.resolvedEntrance := "right"
            else if (InStr(pos, "left") || pos == "left")
                this.resolvedEntrance := "left"
            else if (InStr(pos, "top") || pos == "top")
                this.resolvedEntrance := "top"
            else
                this.resolvedEntrance := "right"
        }

        ; Configurar posición de inicio basada en dirección
        switch this.resolvedEntrance {
            case "right":
                this.animStartX := A_ScreenWidth + 20
                this.animStartY := this.targetY
            case "left":
                this.animStartX := -this.width - 20
                this.animStartY := this.targetY
            case "top":
                this.animStartX := this.targetX
                this.animStartY := -this.height - 20
            case "bottom":
                this.animStartX := this.targetX
                this.animStartY := A_ScreenHeight + 20
            default:
                this.animStartX := A_ScreenWidth + 20
                this.animStartY := this.targetY
        }

        this.currentX := this.animStartX
        this.currentY := this.animStartY

        ; Configurar flags de animación
        this._hasSlide := false
        this._hasFade := false
        this._hasZoom := false
        this._hasRotate := false

        for style in this.animStyle {
            switch style {
                case "slide": this._hasSlide := true
                case "fade": this._hasFade := true
                case "zoom": this._hasZoom := true
                case "rotate": this._hasRotate := true
            }
        }

        ; Valores iniciales de animación
        this.opacity := this._hasFade ? 0 : 1
        this.scale := this._hasZoom ? 0.5 : 1
        this.rotation := this._hasRotate ? 10 : 0

        this.animState := "in"
        this.animStartTime := A_TickCount
        this._initialized := true
    }

    Tick() {
        now := A_TickCount

        ; ── Animación de reposicionamiento (Reflow) ──
        if (this.repoActive) {
            elapsed := now - this.repoStartTime
            progress := Min(1.0, elapsed / Max(1, this.repoDuration))
            eased := ToastEasing.getEasing("easeOutCubic", progress)

            this.currentX := this.repoStartX + (this.repoTargetX - this.repoStartX) * eased
            this.currentY := this.repoStartY + (this.repoTargetY - this.repoStartY) * eased

            if (progress >= 1.0) {
                this.repoActive := false
                this.currentX := this.repoTargetX
                this.currentY := this.repoTargetY
                this.Draw()
                this.UpdateWindow(this.currentX, this.currentY)
                return
            }
            this.Draw()
            return
        }


        ; ── Animación de entrada ──
        if (this.animState == "in") {
            elapsed := now - this.animStartTime
            progress := Min(1.0, elapsed / Max(1, this.animDuration))
            eased := ToastEasing.getEasing(this.animEasing, progress)

            if (this._hasSlide) {
                this.currentX := this.animStartX + (this.targetX - this.animStartX) * eased
                this.currentY := this.animStartY + (this.targetY - this.animStartY) * eased
            } else {
                this.currentX := this.targetX
                this.currentY := this.targetY
            }

            this.opacity := this._hasFade ? eased : 1.0
            this.scale := this._hasZoom ? (0.5 + 0.5 * eased) : 1.0
            this.rotation := this._hasRotate ? ((1 - eased) * 10 * (this.resolvedEntrance == "left" ? -1 : 1)) : 0

            if (progress >= 1.0) {
                this.animState := "visible"
                this.currentX := this.targetX   ; <-- targetX puede haber cambiado por reflow
                this.currentY := this.targetY   ; <-- ídem
                this.opacity := 1.0
                this.scale := 1.0
                this.rotation := 0
                this.progressStartTime := now
                this.repoActive := false          ; cancelar cualquier repo pendiente
            }
            this.Draw()
            return
        }

        ; ── Animación de salida ──
        if (this.animState == "out") {
            elapsed := now - this.animStartTime
            progress := Min(1.0, elapsed / Max(1, this.animDuration))
            eased := ToastEasing.getEasing(this.animEasing, progress)

            ; Usar coordenadas de salida absolutas
            if (this._hasSlide) {
                this.currentX := this.exitStartX + (this.exitTargetX - this.exitStartX) * eased
                this.currentY := this.exitStartY + (this.exitTargetY - this.exitStartY) * eased
            }

            this.opacity := this._hasFade ? (1.0 - eased) : 1.0
            this.scale := this._hasZoom ? (1.0 - 0.5 * eased) : 1.0
            this.rotation := this._hasRotate ? (eased * 10 * (this.resolvedEntrance == "left" ? 1 : -1)) : 0

            this.Draw()
            return
        }

        ; ── Estado visible: actualizar progreso ──
        if (this.animState == "visible") {
            if (this.showProgress && this.duration > 0 && !this.progressPaused) {
                elapsed := now - this.progressStartTime
                this.progress := Min(1.0, elapsed / this.duration)

                ; Solo redibujar la barra si el progreso cambió visualmente
                if (Abs(this.progress - this.lastProgress) > 0.005) {
                    this.cacheDirty := true
                    this.lastProgress := this.progress
                }

                this.Draw()

                if (this.progress >= 1.0) {
                    if (this.autoDismiss) {
                        if (!this.progressCompleteTime)
                            this.progressCompleteTime := now
                        else if (now - this.progressCompleteTime > Toast.progressGracePeriod)
                            this.StartExit()
                    }
                }
            }
        }
    }

    StartExit() {
        if (this.animState == "out")
            return

        ; ═══════════════════════════════════════════════════════════════
        ; FIJAR POSICIÓN DE SALIDA basada en dirección de entrada
        ; Esto evita que el reflow cambie la dirección de salida
        ; ═══════════════════════════════════════════════════════════════
        this.exitStartX := this.currentX
        this.exitStartY := this.currentY

        switch this.resolvedEntrance {
            case "right":
                this.exitTargetX := A_ScreenWidth + 20
                this.exitTargetY := this.currentY
            case "left":
                this.exitTargetX := -this.width - 20
                this.exitTargetY := this.currentY
            case "top":
                this.exitTargetX := this.currentX
                this.exitTargetY := -this.height - 20
            case "bottom":
                this.exitTargetX := this.currentX
                this.exitTargetY := A_ScreenHeight + 20
            default:
                this.exitTargetX := A_ScreenWidth + 20
                this.exitTargetY := this.currentY
        }

        this.animState := "out"
        this.animStartTime := A_TickCount

        ; Remover de toasts activos
        for i, t in Toastify.toasts {
            if (t == this) {
                Toastify.toasts.RemoveAt(i)
                break
            }
        }

        ; Agregar a toasts saliendo
        local found := false
        for t in Toastify.exitingToasts {
            if (t == this) {
                found := true
                break
            }
        }
        if (!found)
            Toastify.exitingToasts.Push(this)

        ; Toastify.__reflow(true)
    }

    ForceClose() {
        this.userInitiatedExit := true
        this.hovered := false
        this.progressPaused := false
        this.StartExit()
    }

    Close() {
        this.ForceClose()
    }

    OnMouseMove(x, y) {
        if (this.userInitiatedExit || this.animState == "out")
            return
        wasHovered := this.hovered
        this.hovered := true

        wasCloseHovered := this.closeHovered
        this.closeHovered := false

        for r in this.clickRegions {
            if (r.type = "close" && x >= r.x && x <= r.x + r.w && y >= r.y && y <= r.y + r.h) {
                this.closeHovered := true
                break
            }
        }

        if (wasCloseHovered != this.closeHovered) {
            this.Draw()


        }

        if (!wasHovered && Toastify.hoverPauseEnabled && this.autoDismiss) {
            this.progressPaused := true
            this.progressPauseTime := A_TickCount
        }
    }

    OnMouseLeave() {
        if (this.hovered) {
            this.hovered := false
            this.closeHovered := false

            if (this.autoDismiss) {
                if (this.progressPaused) {
                    this.progressPaused := false
                    pausedDuration := A_TickCount - this.progressPauseTime
                    this.progressStartTime += pausedDuration


                    if (this.hwnd && Toastify.registry.Has(this.hwnd)) {
                        Toastify.registry[this.hwnd].duration += pausedDuration
                    }
                }
            } else {

                this.progressPaused := false
            }

            this.Draw()
            this.UpdateWindow(this.currentX, this.currentY)
        }
    }

    OnClick(x, y) {
        offsetX := (this.bufferWidth > this.width) ? (this.bufferWidth - this.width) / 2 : 0
        offsetY := (this.bufferHeight > this.height) ? (this.bufferHeight - this.height) / 2 : 0
        cx := x - offsetX
        cy := y - offsetY
        clickedRegion := false
        for r in this.clickRegions {
            if (cx >= r.x && cx <= r.x + r.w && cy >= r.y && cy <= r.y + r.h) {
                clickedRegion := true
                if r.cb {
                    try r.cb()
                }
                if (r.type = "button") {
                    this.StartExit()
                } else if (r.type = "close") {
                    this.ForceClose()
                }
                break
            }
        }

        if (!clickedRegion && this.onClickCallback) {
            try this.onClickCallback()
        }
    }

    Dismiss(instant := false) {
        ; ══════════════════════════════════════════════════════════════
        ; FIX: si no es instantáneo y el toast todavía no está saliendo,
        ; disparamos la animación de salida y dejamos que el propio loop
        ; de animación (__globalTick) llame a Dismiss(true) cuando termine.
        ; ══════════════════════════════════════════════════════════════
        if (!instant && this.animState != "out") {
            this.StartExit()
            return
        }

        ; ── Remoción real (instantánea, o ya terminó de animar) ──
        for i, t in Toastify.exitingToasts {
            if (t == this) {
                Toastify.exitingToasts.RemoveAt(i)
                break
            }
        }

        for i, t in Toastify.toasts {
            if (t == this) {
                Toastify.toasts.RemoveAt(i)
                break
            }
        }

        if (this.hwnd && Toastify.registry.Has(this.hwnd))
            Toastify.registry.Delete(this.hwnd)

        this.Destroy()
    }


    Destroy() {
        if (!this.hwnd)
            return

        ; Limpiar recursos GDI+ primero
        if (this.GCache) {
            Gdip_DeleteGraphics(this.GCache)
            this.GCache := 0
        }
        if (this.pBitmapCache) {
            Gdip_DisposeImage(this.pBitmapCache)
            this.pBitmapCache := 0
        }
        if (this.G) {
            Gdip_DeleteGraphics(this.G)
            this.G := 0
        }
        if (this.hbm) {
            SelectObject(this.hdc, this.obm)
            DeleteObject(this.hbm)
            this.hbm := 0
        }
        if (this.hdc) {
            DeleteDC(this.hdc)
            this.hdc := 0
        }

        ; Destruir GUI de forma segura
        hwnd := this.hwnd
        this.hwnd := 0
        this.gui := 0  ; ← Importante: invalidar referencia antes de destruir

        if (DllCall("IsWindow", "ptr", hwnd))
            DllCall("DestroyWindow", "ptr", hwnd)
    }
}