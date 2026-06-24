#Requires AutoHotkey v2.0
#Include AHKv2-Gdip\Gdip_All.ahk

; ============================================================================
; ToastEasing - Matemáticas puras de animación (Cero dependencias)
; ============================================================================
class ToastEasing {
    static defaultEasing := "easeOutCubic"
    static funcs := 0

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
    static easeInQuint(t) => t * t * t * t * t
    static easeOutQuint(t) => 1 + (--t) * t * t * t * t
    static easeInOutQuint(t) => (t < 0.5) ? (16 * t * t * t * t * t) : (1 + 16 * (--t) * t * t * t * t)
    static easeInSine(t) => 1 - Cos((t * 3.14159265359) / 2)
    static easeOutSine(t) => Sin((t * 3.14159265359) / 2)
    static easeInOutSine(t) => -(Cos(3.14159265359 * t) - 1) / 2
    static easeInExpo(t) => (t = 0) ? 0 : (2 ** (10 * t - 10))
    static easeOutExpo(t) => (t = 1) ? 1 : (1 - 2 ** (-10 * t))
    static easeInOutExpo(t) => (t = 0) ? 0 : (t = 1) ? 1 : (t < 0.5) ? (2 ** (20 * t - 10)) / 2 : (2 - 2 ** (-20 * t + 10)) / 2
    static easeInCirc(t) => 1 - Sqrt(1 - (t ** 2))
    static easeOutCirc(t) => Sqrt(1 - ((t - 1) ** 2))
    static easeInOutCirc(t) => (t < 0.5) ? (1 - Sqrt(1 - (2 * t) ** 2)) / 2 : (Sqrt(1 - (-2 * t + 2) ** 2) + 1) / 2
    static decelerate(t) => 1 - ((1 - t) * (1 - t))
    static ease(t) => ToastEasing.easeInOutCubic(t)
    static easeIn(t) => ToastEasing.easeInCubic(t)
    static easeOut(t) => ToastEasing.easeOutCubic(t)
    static easeInOut(t) => ToastEasing.easeInOutCubic(t)
    static fastOutSlowIn(t) => ToastEasing.easeInOutCubic(t)

    static easeInBack(t) {
        c1 := 1.70158, c3 := c1 + 1
        return c3 * t * t * t - c1 * t * t
    }
    static easeOutBack(t) {
        c1 := 1.70158, c3 := c1 + 1
        return 1 + c3 * ((t - 1) ** 3) + c1 * ((t - 1) ** 2)
    }
    static easeInOutBack(t) {
        c1 := 1.70158, c2 := c1 * 1.525
        return (t < 0.5) ? ((2 * t) ** 2 * ((c2 + 1) * 2 * t - c2)) / 2 : ((2 * t - 2) ** 2 * ((c2 + 1) * (t * 2 - 2) + c2) + 2) / 2
    }
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
        return (t = 0) ? 0 : (t = 1) ? 1 : (t < 0.5) ? -((2 ** (20 * t - 10)) * Sin((20 * t - 11.125) * c5)) / 2 : ((2 ** (-20 * t + 10)) * Sin((20 * t - 11.125) * c5)) / 2 + 1
    }
    static bounceOut(t) {
        n1 := 7.5625, d1 := 2.75
        if (t < 1 / d1)
            return n1 * t * t
        else if (t < 2 / d1) {
            t -= 1.5 / d1
            return n1 * t * t + 0.75
        }
        else if (t < 2.5 / d1) {
            t -= 2.25 / d1
            return n1 * t * t + 0.9375
        }
        else {
            t -= 2.625 / d1
            return n1 * t * t + 0.984375
        }
    }
    static bounceIn(t) => 1 - ToastEasing.bounceOut(1 - t)
    static bounceInOut(t) => (t < 0.5) ? (1 - ToastEasing.bounceOut(1 - 2 * t)) / 2 : (1 + ToastEasing.bounceOut(2 * t - 1)) / 2
    static bounce(t) => ToastEasing.bounceOut(t)
    static slowMiddle(t) => (t < 0.5) ? ToastEasing.easeInCubic(t * 2) / 2 : 0.5 + ToastEasing.easeOutCubic((t - 0.5) * 2) / 2
    static easeInToLinear(t) => (t < 0.5) ? ToastEasing.easeInCubic(t * 2) / 2 : 0.5 + (t - 0.5)
    static linearToEaseOut(t) => (t < 0.5) ? t : 0.5 + ToastEasing.easeOutCubic((t - 0.5) * 2) / 2
    static fastLinearToSlowEaseIn(t) {
        linearEnd := 0.5
        return (t < linearEnd) ? t / linearEnd * 0.5 : 0.5 + ToastEasing.easeInCubic((t - linearEnd) / (1 - linearEnd)) / 2
    }
    static easeInOutCubicEmphasized(t) {
        c := 1.4
        return (t < 0.5) ? (c * 4 * t * t * t) : 1 - (((-2 * t + 2) ** 3) * c) / 2
    }

    ; FIX CRÍTICO: Se eliminó ToastEasing del .Call()
    static getEasing(name, t) {
        if (!ToastEasing.funcs) {
            ToastEasing.funcs := Map(
                "linear", ToastEasing.linear, "easeInQuad", ToastEasing.easeInQuad,
                "easeOutQuad", ToastEasing.easeOutQuad, "easeInOutQuad", ToastEasing.easeInOutQuad,
                "easeInCubic", ToastEasing.easeInCubic, "easeOutCubic", ToastEasing.easeOutCubic,
                "easeInOutCubic", ToastEasing.easeInOutCubic, "easeInQuart", ToastEasing.easeInQuart,
                "easeOutQuart", ToastEasing.easeOutQuart, "easeInOutQuart", ToastEasing.easeInOutQuart,
                "easeInBack", ToastEasing.easeInBack, "easeOutBack", ToastEasing.easeOutBack,
                "easeInOutBack", ToastEasing.easeInOutBack, "bounce", ToastEasing.bounceOut,
                "bounceOut", ToastEasing.bounceOut, "bounceIn", ToastEasing.bounceIn,
                "bounceInOut", ToastEasing.bounceInOut, "easeInSine", ToastEasing.easeInSine,
                "easeOutSine", ToastEasing.easeOutSine, "easeInOutSine", ToastEasing.easeInOutSine,
                "easeInExpo", ToastEasing.easeInExpo, "easeOutExpo", ToastEasing.easeOutExpo,
                "easeInOutExpo", ToastEasing.easeInOutExpo, "easeInCirc", ToastEasing.easeInCirc,
                "easeOutCirc", ToastEasing.easeOutCirc, "easeInOutCirc", ToastEasing.easeInOutCirc,
                "easeInQuint", ToastEasing.easeInQuint, "easeOutQuint", ToastEasing.easeOutQuint,
                "easeInOutQuint", ToastEasing.easeInOutQuint, "elasticIn", ToastEasing.elasticIn,
                "elasticOut", ToastEasing.elasticOut, "elasticInOut", ToastEasing.elasticInOut,
                "decelerate", ToastEasing.decelerate, "ease", ToastEasing.ease,
                "easeIn", ToastEasing.easeIn, "easeOut", ToastEasing.easeOut,
                "easeInOut", ToastEasing.easeInOut, "fastOutSlowIn", ToastEasing.fastOutSlowIn,
                "slowMiddle", ToastEasing.slowMiddle, "easeInToLinear", ToastEasing.easeInToLinear,
                "linearToEaseOut", ToastEasing.linearToEaseOut, "fastLinearToSlowEaseIn", ToastEasing.fastLinearToSlowEaseIn,
                "easeInOutCubicEmphasized", ToastEasing.easeInOutCubicEmphasized
            )
        }
        fn := ToastEasing.funcs.Has(name) ? ToastEasing.funcs[name] : 0
        return fn ? fn.Call(t) : ToastEasing.%ToastEasing.defaultEasing%(t)
    }
}

; ============================================================================
; ToastTheme - Gestión de paletas y CACHEO DE OBJETOS GDI+ (Zero Leaks)
; ============================================================================
class ToastTheme {
    static themes := Map()

    static __New() {
        ToastTheme.Register("light", { bg1: 0xFFFFFFFF, bg2: 0xFFF8F9FA, fg: 0xFF1F2937, accent: 0xFF3B82F6, shadow: 0x44000000, progress: 0xFF3B82F6 })
        ToastTheme.Register("dark", { bg1: 0xEE1F2937, bg2: 0xEE111827, fg: 0xFFF9FAFB, accent: 0xFF60A5FA, shadow: 0x66000000, progress: 0xFF60A5FA })
        ToastTheme.Register("success", { bg1: 0xEE1C2B23, bg2: 0xEE14191A, fg: 0xFFFFFFFF, accent: 0xFF34D399, shadow: 0x66000000, progress: 0xFF10B981 })
        ToastTheme.Register("error", { bg1: 0xEE2D1B1E, bg2: 0xEE1A1315, fg: 0xFFFFFFFF, accent: 0xFFF87171, shadow: 0x66000000, progress: 0xFFEF4444 })
        ToastTheme.Register("warning", { bg1: 0xEE2D1F1E, bg2: 0xEE1C1315, fg: 0xFFFFFFFF, accent: 0xFFFCD34D, shadow: 0x66000000, progress: 0xFFFBBF24 })
        ToastTheme.Register("info", { bg1: 0xEE1E2B3D, bg2: 0xEE14191F, fg: 0xFFFFFFFF, accent: 0xFF93C5FD, shadow: 0x66000000, progress: 0xFF60A5FA })

        ; Añade aquí el resto de tus temas (neon, vapor, glass, etc.) manteniendo la estructura...
        ToastTheme.Register("neon", { bg1: 0xEE0F0518, bg2: 0xEE1A0B2E, fg: 0xFFE9D5FF, accent: 0xFFD946EF, shadow: 0x88D946EF, progress: 0xFFC026D3 })
    }

    static Register(name, palette) {
        ; CACHEO TOTAL: Todo lo que se usa en Draw() se crea UNA VEZ aquí.
        palette.shadowBrush := Gdip_BrushCreateSolid(palette.shadow)
        palette.borderPen := Gdip_CreatePen(palette.accent, 2)
        palette.accentBrush := Gdip_BrushCreateSolid(palette.accent)
        palette.btnBorderPen := Gdip_CreatePen(0x44FFFFFF, 1)
        palette.btnFillBrush := Gdip_BrushCreateSolid(0x33000000)
        palette.progressFillBrush := Gdip_BrushCreateSolid(palette.progress)

        ; NUEVOS OBJETOS CACHEADOS (Eliminan los Gdip_Create del loop de renderizado)
        palette.whiteBrush := Gdip_BrushCreateSolid(0xFFFFFFFF)
        palette.iconPen := Gdip_CreatePen(0xFFFFFFFF, 3)
        palette.iconThinPen := Gdip_CreatePen(0xFFFFFFFF, 2)
        palette.closePen := Gdip_CreatePen(0xAAFFFFFF, 2)
        palette.closeHoverPen := Gdip_CreatePen(0xFFFFFFFF, 2)
        palette.closeHoverBrush := Gdip_BrushCreateSolid(0x33FFFFFF)

        ToastTheme.themes[name] := palette
    }

    static palette(theme) => ToastTheme.themes.Has(theme) ? ToastTheme.themes[theme] : ToastTheme.themes["dark"]

    static Shutdown() {
        for name, pal in ToastTheme.themes {
            try Gdip_DeleteBrush(pal.shadowBrush)
            try Gdip_DeletePen(pal.borderPen)
            try Gdip_DeleteBrush(pal.accentBrush)
            try Gdip_DeletePen(pal.btnBorderPen)
            try Gdip_DeleteBrush(pal.btnFillBrush)
            try Gdip_DeleteBrush(pal.progressFillBrush)
            try Gdip_DeleteBrush(pal.whiteBrush)
            try Gdip_DeletePen(pal.iconPen)
            try Gdip_DeletePen(pal.iconThinPen)
            try Gdip_DeletePen(pal.closePen)
            try Gdip_DeletePen(pal.closeHoverPen)
            try Gdip_DeleteBrush(pal.closeHoverBrush)
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
    animDuration := 300
    animEasing := "easeOutCubic"
    animStyle := "slide"
    animEntrance := "auto"
    repoDuration := 300
    renderQuality := "High"
}
ToastTheme.__New()

; ============================================================================
; Toastify - El Manager (Timers, Arrays, Lógica Global)
; ============================================================================
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
    static __mouseTimer := 0
    static registry := Map()
    static config := ToastConfig()

    static SetConfig(cfg) {
        for p in ["fontName", "fontSizeTitle", "fontSizeBody", "fontWeightTitle", "width", "borderRadius", "iconSize", "paddingX", "paddingY", "repoDuration"] {
            if (cfg.HasProp(p))
                Toastify.config.%p% := cfg.%p%
        }
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

            OnExit((*) => Toastify.Shutdown())
            OnMessage(0x201, (wParam, lParam, msg, hwnd) => Toastify.__Click(wParam, lParam, msg, hwnd))

            ; EFICIENCIA: 30 FPS es indistinguible para UI y salva batería. Sin timeBeginPeriod agresivo.
            Toastify.__globalTimer := ObjBindMethod(Toastify, "__globalTick")
            SetTimer(Toastify.__globalTimer, -33)

            Toastify.__watchdogTimer := ObjBindMethod(Toastify, "__watchdogTick")
            SetTimer(Toastify.__watchdogTimer, 200)

            Toastify.__mouseTimer := ObjBindMethod(Toastify, "__mouseTimerTick")
            SetTimer(Toastify.__mouseTimer, 50)
        }
        Toastify.theme := theme
        Toastify.position := position
    }

    static Shutdown(*) {
        if Toastify.__globalTimer SetTimer(Toastify.__globalTimer, 0)
            if Toastify.__watchdogTimer SetTimer(Toastify.__watchdogTimer, 0)
                if Toastify.__mouseTimer SetTimer(Toastify.__mouseTimer, 0)
                    for t in Toastify.toasts t.Destroy()
                        for t in Toastify.exitingToasts t.Destroy()
                            for hwnd, data in Toastify.registry
                                try DllCall("DestroyWindow", "ptr", hwnd)
        Toastify.registry.Clear()
        Toastify.toasts := []
        Toastify.exitingToasts := []

        if Toastify.pToken {
            ToastTheme.Shutdown()
            Gdip_Shutdown(Toastify.pToken)
            Toastify.pToken := 0
        }
    }

    static Show(title := "", body := "", actions := [], opts := 0) {
        if !IsObject(opts)
            opts := {}
        return Toastify.__createToast(title, body, actions, opts)
    }
    static Success(title, body := "", actions := [], opts := 0) {
        if !IsObject(opts)
            opts := {}
        opts.theme := "success"
        opts.icon := "success"
        return Toastify.Show(title, body, actions, opts)
    }
    static Error(title, body := "", actions := [], opts := 0) {
        if !IsObject(opts)
            opts := {}
        opts.theme := "error"
        opts.icon := "error"
        return Toastify.Show(title, body, actions, opts)
    }
    static Warning(title, body := "", actions := [], opts := 0) {
        if !IsObject(opts)
            opts := {}
        opts.theme := "warning"
        opts.icon := "warning"
        return Toastify.Show(title, body, actions, opts)
    }
    static Info(title, body := "", actions := [], opts := 0) {
        if !IsObject(opts)
            opts := {}
        opts.theme := "info"
        opts.icon := "info"
        return Toastify.Show(title, body, actions, opts)
    }

    static __createToast(title, body, actions, opts) {
        if !IsObject(opts)
            opts := {}
        if !opts.HasProp("theme")
            opts.theme := Toastify.theme
        if !opts.HasProp("position")
            opts.position := Toastify.position
        while (Toastify.toasts.Length >= Toastify.maxToasts) {
            if (Toastify.toasts.Length > 0)
                Toastify.toasts[1].StartExit()
            else break
                    }

        t := Toast(title, body, actions, opts)
        Toastify.toasts.Push(t)
        Toastify.__reflow(true)
        t.InitAnimation()
        t.Draw()
        t.AnimateIn()
        return t
    }

    static __reflow(animate := true) {
        total := Toastify.toasts.Length
        if (total = 0)
            return
        isTop := (Toastify.position = "top-right" || Toastify.position = "top-left")
        now := A_TickCount

        for idx, t in Toastify.toasts {
            x := 0, y := 0
            if (Toastify.position = "top-right") {
                x := A_ScreenWidth - Toastify.marginX - t.width
                y := Toastify.marginY + (idx - 1) * (t.height + Toastify.spacing)
            } else if (Toastify.position = "bottom-right") {
                x := A_ScreenWidth - Toastify.marginX - t.width
                y := A_ScreenHeight - Toastify.marginY - (t.height) - (total - idx) * (t.height + Toastify.spacing)
            } else if (Toastify.position = "top-left") {
                x := Toastify.marginX
                y := Toastify.marginY + (idx - 1) * (t.height + Toastify.spacing)
            } else {
                x := Toastify.marginX
                y := A_ScreenHeight - Toastify.marginY - (t.height) - (total - idx) * (t.height + Toastify.spacing)
            }

            ; Espaciado dinámico para toasts saliendo
            for et in Toastify.exitingToasts {
                exitFraction := 1.0 - Min(1.0, (now - et.animStartTime) / Max(1, et.animDuration))
                if (exitFraction > 0) {
                    if (isTop && t.currentY > et.targetY + 1)
                        y += (et.height + Toastify.spacing) * exitFraction
                    else
                        if (!isTop && t.currentY < et.targetY - 1)
                            y -= (et.height + Toastify.spacing) * exitFraction
                }
            }

            t.targetX := x
            t.targetY := y

            if (animate) {
                t.repoStartX := t.currentX
                t.repoStartY := t.currentY
                t.repoTargetX := x
                t.repoTargetY := y
                t.repoStartTime := now
                t.repoActive := true
            } else {
                t.currentX := x
                t.currentY := y
                if (t.hwnd)
                    t.UpdateWindow(x, y)
            }
        }
    }

    static __globalTick(*) {
        Critical("On") ; Evita que otro timer (mouse/watchdog) interrumpa a mitad de la mutación de los arrays
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
                t.Dismiss()
            } else {
                i++
            }
        }
        Critical("Off")
    }

    static __watchdogTick(*) {
        Critical("On")
        now := A_TickCount
        for hwnd, data in Toastify.registry.Clone() {
            if (!DllCall("IsWindow", "ptr", hwnd)) {
                Toastify.registry.Delete(hwnd)
                continue
            }
            t := (data.HasOwnProp("instance") && data.instance) ? data.instance : 0
            if (t && t.hovered && t.progressPaused && Toastify.hoverPauseEnabled)
                continue
            if (data.duration > 0 && t) {
                expectedLifetime := t.animDuration + data.duration + 500
                if ((now - data.startTime) > expectedLifetime) {
                    if (t.animState == "out") {
                        if ((now - data.startTime) > expectedLifetime + t.animDuration + 500) {
                            try DllCall("DestroyWindow", "ptr", hwnd)
                            if (Toastify.registry.Has(hwnd))
                                Toastify.registry.Delete(hwnd)
                        }
                    } else t.StartExit()
                }
            }
        }
        Critical("Off")
    }

    static __mouseTimerTick(*) {
        Critical("On")
        MouseGetPos(&x, &y)
        for t in Toastify.toasts {
            Toastify.__checkHover(t, x, y)
        }
        for t in Toastify.exitingToasts {
            Toastify.__checkHover(t, x, y)
        }
        Critical("Off")
    }

    static __checkHover(t, x, y) {
        if (!t.hwnd)
            return
        isInside := (x >= t.currentX && x <= t.currentX + t.width && y >= t.currentY && y <= t.currentY + t.height)
        if (isInside && !t.hovered)
            t.OnMouseMove(x - t.currentX, y - t.currentY)
        else
            if (!isInside && t.hovered)
                t.OnMouseLeave()
            else
                if (isInside)
                    t.OnMouseMove(x - t.currentX, y - t.currentY)
    }

    static __Click(wParam, lParam, msg, hwnd) {
        x := lParam & 0xFFFF, y := (lParam >> 16) & 0xFFFF
        for t in Toastify.toasts
            if (t.hwnd == hwnd) {
                t.OnClick(x, y)
                return
            }
        for t in Toastify.exitingToasts
            if (t.hwnd == hwnd)
            {
                t.OnClick(x, y)
                return
            }
    }
}

; ============================================================================
; Toast - La Instancia (Renderizado y Animación Final)
; ============================================================================
class Toast {
    ; ... [Todas las variables de estado de tu clase original aquí] ...
    title := "", body := "", actions := [], width := 340, height := 120, duration := 3000
    theme := "dark", position := "top-right", icon := "", showClose := true, showProgress := true
    hwnd := 0, gui := 0, hbm := 0, hdc := 0, obm := 0, G := 0
    pBitmapCache := 0, GCache := 0, cacheDirty := true
    targetX := 0, targetY := 0, currentX := 0, currentY := 0
    repoStartX := 0, repoStartY := 0, repoTargetX := 0, repoTargetY := 0
    repoStartTime := 0, repoDuration := 250, repoActive := false
    animState := "idle", animStartTime := 0, animDuration := 300
    animEasing := "easeOutCubic", animStyle := ["fade"], animEntrance := "auto"
    opacity := 1.0, scale := 1.0, rotation := 0.0, resolvedEntrance := "right"
    _hasSlide := false, _hasFade := false, _hasZoom := false, _hasRotate := false
    bufferWidth := 0, bufferHeight := 0
    progress := 0.0, progressStartTime := 0, progressPaused := false
    progressPauseTime := 0, lastProgress := 0.0, creationTime := 0
    clickRegions := [], hovered := false, closeHovered := false
    onClickCallback := 0, onCloseCallback := 0, userInitiatedExit := false
    autoDismiss := true, progressCompleteTime := 0
    static progressGracePeriod := 5000
    fontName := "Segoe UI", fontSizeTitle := 16, fontSizeBody := 11
    fontWeightTitle := "Bold", fontWeightBody := "Normal"
    paddingX := 16, paddingY := 14, iconSize := 32
    borderRadius := 18, renderQuality := "High"
    _windowShown := false
    pBgGradientBrush := 0 ; Cache por instancia

    __New(title, body, actions, opts) {
        this.title := title, this.body := body, this.actions := actions
        cfg := Toastify.config
        this.width := cfg.width, this.fontName := cfg.fontName, this.fontSizeTitle := cfg.fontSizeTitle
        this.fontSizeBody := cfg.fontSizeBody, this.fontWeightTitle := cfg.fontWeightTitle
        this.fontWeightBody := cfg.fontWeightBody, this.paddingX := cfg.paddingX, this.paddingY := cfg.paddingY
        this.iconSize := cfg.iconSize, this.borderRadius := cfg.borderRadius, this.animDuration := cfg.animDuration
        this.animEasing := cfg.animEasing, this.animStyle := [cfg.animStyle], this.animEntrance := cfg.animEntrance
        this.renderQuality := cfg.renderQuality, this.repoDuration := cfg.repoDuration

        if (opts) {
            for p in ["width", "duration", "theme", "position", "icon", "showClose", "showProgress", "onClick", "onClose", "fontName", "fontSizeTitle", "fontSizeBody", "fontWeightTitle", "fontWeightBody", "paddingX", "paddingY", "iconSize", "borderRadius", "animDuration", "renderQuality"] {
                if (opts.HasProp(p))
                    this.%p% := opts.%p%
            }
            if (!HasProp(this.animStyle, "Length") && Type(this.animStyle) == "String")
                this.animStyle := [this.animStyle]
            else
                if (!HasProp(this.animStyle, "Length"))
                    this.animStyle := ["fade"]
            this.animEasing := opts.HasProp("animEasing") ? opts.animEasing : cfg.animEasing
            this.animEntrance := opts.HasProp("animEntrance") ? opts.animEntrance : cfg.animEntrance
            if (opts.HasProp("autoDismiss"))
                this.autoDismiss := !!opts.autoDismiss
            if (opts.HasProp("permanent") && !!opts.permanent)
            {
                this.autoDismiss := false
                if (!opts.HasProp("duration"))
                    this.duration := 0
                if (!opts.HasProp("showProgress"))
                    this.showProgress := false
            }
        }
        this.creationTime := A_TickCount
        this.__createWindow()
    }

    __createWindow() {
        this.gui := Gui("-Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs")
        this.hwnd := this.gui.Hwnd

        this.hbm := CreateDIBSection(this.width, this.height)
        this.hdc := CreateCompatibleDC()
        this.obm := SelectObject(this.hdc, this.hbm)
        this.G := Gdip_GraphicsFromHDC(this.hdc)

        this.bufferWidth := this.width, this.bufferHeight := this.height
        this.pBitmapCache := Gdip_CreateBitmap(this.width, this.height)
        this.GCache := Gdip_GraphicsFromImage(this.pBitmapCache)

        q := (this.renderQuality = "Low") ? 1 : (this.renderQuality = "Medium") ? 2 : 2
        Gdip_SetSmoothingMode(this.GCache, q == 1 ? 1 : 4)
        Gdip_SetTextRenderingHint(this.GCache, q == 1 ? 3 : 5)
        DllCall("gdiplus\GdipSetPixelOffsetMode", "ptr", this.GCache, "int", q)
        DllCall("gdiplus\GdipSetCompositingQuality", "ptr", this.GCache, "int", q)

        ; PRE-CACHE DEL GRADIENT DE FONDO (Evita crear uno nuevo cada vez que cacheDirty = true)
        pal := ToastTheme.palette(this.theme)
        this.pBgGradientBrush := Gdip_CreateLineBrushFromRect(0, 0, this.width, this.height, pal.bg1, pal.bg2, 1, 1)

        ; ANTI-FLICKER: Mostrar oculto off-screen. NUNCA usar gui.Show() de nuevo.
        this.gui.Show("NA x-9999 y-9999 w0 h0")
        this._windowShown := true

        Toastify.registry[this.hwnd] := { startTime: A_TickCount, duration: this.autoDismiss ? this.duration : 0, instance: this }
    }

    Draw() {
        if (!this.cacheDirty && this.scale == 1.0 && this.rotation == 0) {
            this.RenderToWindow()
            return
        }

        pal := ToastTheme.palette(this.theme)
        this.clickRegions := []
        Gdip_GraphicsClear(this.GCache)

        Gdip_FillRoundedRectangle(this.GCache, pal.shadowBrush, 4, 4, this.width - 8, this.height - 8, this.borderRadius)
        Gdip_FillRoundedRectangle(this.GCache, this.pBgGradientBrush, 0, 0, this.width, this.height, this.borderRadius)
        Gdip_DrawRoundedRectangle(this.GCache, pal.borderPen, 1, 1, this.width - 2, this.height - 2, this.borderRadius)

        textStartX := this.paddingX
        if (this.icon != "") {
            this.DrawIcon(this.paddingX, this.paddingY, this.iconSize, this.icon, pal)
            textStartX := this.paddingX + this.iconSize + 12
        }

        if (this.showClose) this.DrawCloseButton(pal)
            font := this.fontName
        titleWidth := this.width - textStartX - (this.showClose ? 40 : this.paddingX)

        if (this.title != "") {
            Gdip_TextToGraphics(this.GCache, this.title, "x" textStartX " y" this.paddingY " w" titleWidth " c" Format("{:x}", pal.fg) " r4 s" this.fontSizeTitle " " this.fontWeightTitle, font, this.width, this.height)
        }
        if (this.body != "") {
            bodyY := (this.title != "") ? (this.paddingY + this.fontSizeTitle * 1.5 + 4) : this.paddingY
            availableHeight := this.height - bodyY - this.paddingY - (this.actions.Length ? 38 : 0) - (this.showProgress && this.duration > 0 ? 12 : 0)
            Gdip_TextToGraphics(this.GCache, this.body, "x" textStartX " y" bodyY " w" titleWidth " h" Max(20, availableHeight) " c" Format("{:x}", pal.fg) " r4 s" this.fontSizeBody " " this.fontWeightBody, font, this.width, this.height)
        }

        if (this.actions.Length) {
            btnW := (this.width - 32 - (this.actions.Length - 1) * 8) // this.actions.Length
            y := this.height - (this.showProgress ? 50 : 40)
            x := 16
            for idx, act in this.actions {
                Gdip_FillRoundedRectangle(this.GCache, pal.accentBrush, x, y, btnW, 28, 6)
                Gdip_DrawRoundedRectangle(this.GCache, pal.btnBorderPen, x, y, btnW, 28, 6)
                Gdip_TextToGraphics(this.GCache, act.HasProp("text") ? act.text : act[1], "x" x + 10 " y" y + 6 " w" btnW - 20 " cFFFFFFFF r4 s" this.fontSizeBody " Centre Bold", font, this.width, this.height)
                this.clickRegions.Push({ x: x, y: y, w: btnW, h: 28, cb: (act.HasProp("onClick") ? act.onClick : act[2]), type: "button" })
                x += btnW + 8
            }
        }

        if (this.showProgress && this.duration > 0) this.DrawProgressBar(pal)
            this.cacheDirty := false
        this.RenderToWindow()
    }

    RenderToWindow() {
        Gdip_GraphicsClear(this.G, 0x00000000)
        Gdip_SetSmoothingMode(this.G, this.renderQuality = "Low" ? 1 : 4)
        Gdip_SetInterpolationMode(this.G, this.renderQuality = "Low" ? 5 : 7)

        if (this.scale < 0.01) {
            this.UpdateWindow(this.currentX, this.currentY, 0) ; Invisible
            return
        }

        if (this.scale != 1.0 || this.rotation != 0) {
            Gdip_ResetWorldTransform(this.G)
            bufCX := this.bufferWidth / 2, bufCY := this.bufferHeight / 2
            Gdip_TranslateWorldTransform(this.G, bufCX, bufCY, 0)
            if (this.rotation != 0) Gdip_RotateWorldTransform(this.G, this.rotation, 0)
                if (this.scale != 1.0) Gdip_ScaleWorldTransform(this.G, this.scale, this.scale, 0)
                    Gdip_TranslateWorldTransform(this.G, -bufCX, -bufCY, 0)

            Gdip_DrawImage(this.G, this.pBitmapCache, (this.bufferWidth - this.width) / 2, (this.bufferHeight - this.height) / 2, this.width, this.height, 0, 0, this.width, this.height)
            Gdip_ResetWorldTransform(this.G)
        } else {
            Gdip_DrawImage(this.G, this.pBitmapCache, (this.bufferWidth - this.width) / 2, (this.bufferHeight - this.height) / 2, this.width, this.height, 0, 0, this.width, this.height)
        }

        this.UpdateWindow(this.currentX, this.currentY, Floor(this.opacity * 255))
    }

    ; FIX FLICKER Y BLUR: Redondeo absoluto de píxeles y sin llamadas a Show()
    UpdateWindow(x := "", y := "", alpha := 255) {
        if (x != "") this.currentX := x
            if (y != "") this.currentY := y
                w := (this.bufferWidth > this.width) ? this.bufferWidth : this.width
        h := (this.bufferHeight > this.height) ? this.bufferHeight : this.height

        ; LA MAGIA: Redondear para evitar subpixel blur en monitores 4K/HiDPI
        winX := Round(this.currentX - (w - this.width) / 2)
        winY := Round(this.currentY - (h - this.height) / 2)

        UpdateLayeredWindow(this.hwnd, this.hdc, winX, winY, w, h, alpha)
    }

    DrawIcon(x, y, size, iconType, pal) {
        switch iconType {
            case "success":
                Gdip_FillEllipse(this.GCache, pal.accentBrush, x, y, size, size)
                points := x "," (y + size / 2) "|" (x + size / 3) "," (y + size * 2 / 3) "|" (x + size * 4 / 5) "," (y + size / 4)
                Gdip_DrawLines(this.GCache, pal.iconPen, points)
            case "error":
                Gdip_FillEllipse(this.GCache, pal.accentBrush, x, y, size, size)
                Gdip_DrawLine(this.GCache, pal.iconPen, x + size / 4, y + size / 4, x + size * 3 / 4, y + size * 3 / 4)
                Gdip_DrawLine(this.GCache, pal.iconPen, x + size * 3 / 4, y + size / 4, x + size / 4, y + size * 3 / 4)
            case "warning":
                points := (x + size / 2) "," y "|" x "," (y + size) "|" (x + size) "," (y + size)
                Gdip_FillPolygon(this.GCache, pal.accentBrush, points)
                Gdip_DrawLine(this.GCache, pal.iconThinPen, x + size / 2, y + size / 4, x + size / 2, y + size / 2)
                Gdip_FillEllipse(this.GCache, pal.whiteBrush, x + size / 2 - 2, y + size * 2 / 3, 4, 4)
            case "info":
                Gdip_FillEllipse(this.GCache, pal.accentBrush, x, y, size, size)
                Gdip_FillEllipse(this.GCache, pal.whiteBrush, x + size / 2 - 2, y + size / 4, 4, 4)
                Gdip_DrawLine(this.GCache, pal.iconThinPen, x + size / 2, y + size / 2.5, x + size / 2, y + size * 3 / 4)
        }
    }

    DrawCloseButton(pal) {
        closeSize := 20, closeX := this.width - this.paddingX - closeSize, closeY := this.paddingY - 4
        this.clickRegions.Push({ x: closeX, y: closeY, w: closeSize, h: closeSize, cb: (*) => this.ForceClose(), type: "close" })

        if (this.closeHovered) {
            Gdip_FillEllipse(this.GCache, pal.closeHoverBrush, closeX - 2, closeY - 2, closeSize + 4, closeSize + 4)
            pPen := pal.closeHoverPen
        } else {
            pPen := pal.closePen
        }

        offset := 6
        Gdip_DrawLine(this.GCache, pPen, closeX + offset, closeY + offset, closeX + closeSize - offset, closeY + closeSize - offset)
        Gdip_DrawLine(this.GCache, pPen, closeX + closeSize - offset, closeY + offset, closeX + offset, closeY + closeSize - offset)
    }

    DrawProgressBar(pal) {
        barHeight := 4, barY := this.height - barHeight - 4, barX := 8, barWidth := this.width - 16
        Gdip_FillRoundedRectangle(this.GCache, pal.btnFillBrush, barX, barY, barWidth, barHeight, 2)
        if (this.progress > 0)
            Gdip_FillRoundedRectangle(this.GCache, pal.progressFillBrush, barX, barY, barWidth * this.progress, barHeight, 2)
    }

    HasAnim(name) {
        for style in this.animStyle
            if (style == name)
                return true
        return false
    }

    InitAnimation() {
        this.opacity := 1.0, this.scale := 1.0, this.rotation := 0.0
        entrance := this.animEntrance
        if (entrance == "auto") entrance := (this.position = "top-right" || this.position = "bottom-right") ? "right" : (this.position = "top-left" || this.position = "bottom-left") ? "left" : "top"
            this.resolvedEntrance := entrance

        this._hasSlide := this.HasAnim("slide"), this._hasFade := this.HasAnim("fade")
        this._hasZoom := this.HasAnim("zoom"), this._hasRotate := this.HasAnim("rotate")

        if (this._hasFade) this.opacity := 0.0
            if (this._hasZoom) this.scale := 0.0
                if (this._hasRotate) {
                    this.rotation := -90.0
                    diag := Sqrt(this.width ** 2 + this.height ** 2)
                    this.ResizeBuffer(Ceil(diag), Ceil(diag))
                }

        startX := this.targetX, startY := this.targetY
        if (this._hasSlide) {
            if (entrance == "right")
                startX := A_ScreenWidth
            else if (entrance == "left")
                startX := -this.width
            else if (entrance == "top")
                startY := -this.height
            else if (entrance == "bottom")
                startY := A_ScreenHeight
        }
        this.currentX := startX, this.currentY := startY
    }

    AnimateIn() {
        this.animState := "in", this.animStartTime := A_TickCount
        this.progressStartTime := A_TickCount + this.animDuration
        this.UpdateWindow(this.currentX, this.currentY, Floor(this.opacity * 255))
    }

    Tick() {
        if (!this.hwnd)
            return
        now := A_TickCount, dirty := false

        ; Watchdog local
        if (this.animState != "out" && this.autoDismiss && !(Toastify.hoverPauseEnabled && this.hovered && this.progressPaused)) {
            if ((now - this.creationTime) > this.duration + (this.animDuration * 2) + 1000) {
                this.StartExit()
                return
            }
        }

        ; Reposition Animation
        if (this.repoActive) {
            if (Abs(this.currentX - this.repoTargetX) < 0.5 && Abs(this.currentY - this.repoTargetY) < 0.5) {
                this.repoActive := false
            } else {
                elapsed := now - this.repoStartTime
                if (elapsed >= this.repoDuration) {
                    this.currentX := this.repoTargetX, this.currentY := this.repoTargetY, this.repoActive := false, dirty := true
                } else {
                    ease := ToastEasing.getEasing("easeOutCubic", elapsed / this.repoDuration)
                    this.currentX := this.repoStartX + (this.repoTargetX - this.repoStartX) * ease
                    this.currentY := this.repoStartY + (this.repoTargetY - this.repoStartY) * ease
                    dirty := true
                }
            }
        }

        ; Entrance / Exit Animation
        if (this.animState == "in" || this.animState == "out") {
            elapsed := now - this.animStartTime
            if (elapsed < this.animDuration) {
                ease := ToastEasing.getEasing(this.animEasing, elapsed / this.animDuration)
                easeOut := (this.animState == "out") ? (1 - ease) : ease

                if (this._hasSlide) {
                    offX := 0, offY := 0
                    if (this.resolvedEntrance == "right")
                        offX := (A_ScreenWidth - this.targetX) * (1 - easeOut)
                    else if (this.resolvedEntrance == "left")
                        offX := (-this.width - this.targetX) * (1 - easeOut)
                    else if (this.resolvedEntrance == "top")
                        offY := (-this.height - this.targetY) * (1 - easeOut)
                    else if (this.resolvedEntrance == "bottom")
                        offY := (A_ScreenHeight - this.targetY) * (1 - easeOut)
                    this.currentX := this.targetX + offX
                    this.currentY := this.targetY + offY
                    dirty := true
                } else if (!this.repoActive) {
                    this.currentX := this.targetX
                    this.currentY := this.targetY
                }

                if (this._hasFade) {
                    this.opacity := easeOut, dirty := true
                }
                if (this._hasZoom) {
                    this.scale := easeOut, dirty := true
                }
                if (this._hasRotate) {
                    this.rotation := -90.0 * (1 - easeOut), dirty := true
                }

            } else {
                ; Animación terminada
                if (this.animState == "in") {
                    this.animState := "idle"
                    if (this._hasFade) this.opacity := 1.0
                        if (this._hasZoom) this.scale := 1.0
                            if (this._hasRotate) {
                                this.rotation := 0.0, this.ShrinkBuffer()
                            }
                    if (this._hasSlide || !this.repoActive) {
                        this.currentX := this.targetX, this.currentY := this.targetY
                    }
                    dirty := true
                }
            }
        }

        ; Progress Bar
        if (this.animState == "idle" && this.autoDismiss && this.duration > 0 && this.showProgress) {
            if !(Toastify.hoverPauseEnabled && this.hovered && this.progressPaused) {
                this.progress := Min(1.0, (now - this.progressStartTime) / this.duration)
                if (this.progress != this.lastProgress) {
                    this.lastProgress := this.progress
                    this.cacheDirty := true
                    dirty := true
                }
                if (this.progress >= 1.0) {
                    this.progressCompleteTime := this.progressCompleteTime ? this.progressCompleteTime : now
                    if (now - this.progressCompleteTime > 100)
                        this.StartExit() ; Pequeño delay visual
                }
            }
        }

        if (dirty)
            this.Draw()
        else if (this.repoActive || this.animState != "idle")
            this.RenderToWindow()
    }

    StartExit() {
        if (this.animState == "out")
            return
        this.animState := "out"
        this.animStartTime := A_TickCount

        idx := 0
        for i, t in Toastify.toasts {
            if (t = this) {
                idx := i
                break
            }
        }
        if (idx) {
            Toastify.toasts.RemoveAt(idx)
            Toastify.exitingToasts.Push(this)
            Toastify.__reflow(true)
        }
    }

    Dismiss() {
        idx := 0
        for i, t in Toastify.exitingToasts {
            if (t = this) {
                idx := i
                break
            }
        }
        if (idx) {
            Toastify.exitingToasts.RemoveAt(idx)
            Toastify.__reflow(true)
        }
        this.Destroy()
    }

    ForceClose() {
        this.userInitiatedExit := true
        if (this.onCloseCallback) this.onCloseCallback.Call(this)
            this.StartExit()
    }

    Destroy() {
        if (this.hwnd) {
            if (Toastify.registry.Has(this.hwnd)) Toastify.registry.Delete(this.hwnd)
                try DllCall("DestroyWindow", "ptr", this.hwnd)
            this.hwnd := 0
        }
        if (this.pBgGradientBrush) {
            Gdip_DeleteBrush(this.pBgGradientBrush)
            this.pBgGradientBrush := 0
        }
        if (this.pBitmapCache) {
            Gdip_DisposeImage(this.pBitmapCache)
            this.pBitmapCache := 0
        }
        if (this.GCache) {
            Gdip_DeleteGraphics(this.GCache)
            this.GCache := 0
        }
        if (this.G) {
            Gdip_DeleteGraphics(this.G)
            this.G := 0
        }
        if (this.obm && this.hdc) {
            SelectObject(this.hdc, this.obm)
            this.obm := 0
        }
        if (this.hbm) {
            DeleteObject(this.hbm)
            this.hbm := 0
        }
        if (this.hdc) {
            DeleteDC(this.hdc)
            this.hdc := 0
        }
        if (this.gui) {
            this.gui.Destroy()
            this.gui := 0
        }
    }

    OnMouseMove(x, y) {
        this.hovered := true
        wasCloseHovered := this.closeHovered
        this.closeHovered := false
        for r in this.clickRegions {
            if (r.type == "close" && x >= r.x && x <= r.x + r.w && y >= r.y && y <= r.y + r.h) {
                this.closeHovered := true
                break
            }
        }
        if (wasCloseHovered != this.closeHovered) this.cacheDirty := true
            if (Toastify.hoverPauseEnabled && this.progressPaused == false && this.hovered && this.autoDismiss && this.progress > 0 && this.progress < 1) {
                this.progressPaused := true
                this.progressPauseTime := A_TickCount
            }
    }

    OnMouseLeave() {
        this.hovered := false
        if (this.closeHovered) {
            this.closeHovered := false
            this.cacheDirty := true
        }
        if (this.progressPaused && Toastify.hoverPauseEnabled) {
            this.progressPaused := false
            this.progressStartTime += (A_TickCount - this.progressPauseTime)
        }
    }

    OnClick(x, y) {
        for r in this.clickRegions {
            if (x >= r.x && x <= r.x + r.w && y >= r.y && r.y + r.h) {
                if (r.cb) r.cb.Call()
                    return
            }
        }
        if (this.onClickCallback)
            this.onClickCallback.Call(this)
    }

    ResizeBuffer(w, h) {
        if (w <= this.bufferWidth && h <= this.bufferHeight)
            return
        SelectObject(this.hdc, this.obm), DeleteObject(this.hbm), Gdip_DeleteGraphics(this.G)
        this.bufferWidth := w, this.bufferHeight := h
        this.hbm := CreateDIBSection(w, h), this.obm := SelectObject(this.hdc, this.hbm)
        this.G := Gdip_GraphicsFromHDC(this.hdc), Gdip_SetSmoothingMode(this.G, 4)
    }

    ShrinkBuffer() {
        if (this.bufferWidth <= this.width && this.bufferHeight <= this.height)
            return
        SelectObject(this.hdc, this.obm), DeleteObject(this.hbm), Gdip_DeleteGraphics(this.G)
        this.bufferWidth := this.width, this.bufferHeight := this.height
        this.hbm := CreateDIBSection(this.width, this.height), this.obm := SelectObject(this.hdc, this.hbm)
        this.G := Gdip_GraphicsFromHDC(this.hdc), Gdip_SetSmoothingMode(this.G, 4)
    }
}