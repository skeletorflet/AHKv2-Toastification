#Requires AutoHotkey v2.0
#Include ToastDPI.ahk
#Include AHKv2-Gdip\Gdip_All.ahk


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
    static bounce(t) => ToastEasing.bounceOut(t)
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
        return (c / 2) + (1 - c / 2) * (1 - ((-2 * t + 2) ** 3))
    }
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
    static __frameCounter := 0
    static __lastTickTime := 0
    static _reflowNeeded := false
    static __active := false

    static __wasAnyIconic := false
    static registry := Map()
    static __destroyCount := 0
    static config := ToastConfig()
    static animStartX := 0
    static animStartY := 0
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
            "width", "minHeight", "borderRadius", "borderWidth", "iconSize", "iconScale", "designScale", "paddingX", "paddingY", "repoDuration",
            "animDuration", "animEasing", "animStyle", "animEntrance", "renderQuality",
            "rotationDegree"]

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
            ToastDPI.Init()                     ; Per-Monitor v2 awareness
            pt := Gdip_Startup()
            if !pt {
                MsgBox("GDI+ startup failed")
                return
            }
            Toastify.pToken := pt
            ToastTheme.InitThemes()
            OnExit((*) => Toastify.Shutdown())
            OnMessage(0x201, (wParam, lParam, msg, hwnd) =>
                Toastify.__Click(wParam, lParam, msg, hwnd))
            ; Native hover: WM_MOUSEMOVE + TrackMouseEvent/WM_MOUSELEAVE.
            ; Windows resolves z-order: only the topmost toast receives messages.
            OnMessage(0x200, (wParam, lParam, msg, hwnd) =>
                Toastify.__onMouseMove(lParam, hwnd))
            OnMessage(0x2A3, (wParam, lParam, msg, hwnd) =>
                Toastify.__onMouseLeave(hwnd))
            Toastify.__globalTimer := ObjBindMethod(Toastify, "__globalTick")
            Toastify.__lastTickTime := A_TickCount
            Toastify.__frameCounter := 0
        }
        Toastify.theme := theme
        Toastify.position := position
    }

    ; ── Enable/disable the frame loop ──
    ;    Active only while toasts are alive: 60Hz timer, 2ms timer res,
    ;    HIGH priority. Idle → everything restored, 0% CPU.
    static __setActive(active) {
        if (active == Toastify.__active)
            return
        Toastify.__active := active
        if (active) {
            DllCall("Winmm.dll\timeBeginPeriod", "UInt", 2)
            ProcessSetPriority(Toastify.PRIORITY.ABOVE_NORMAL)
            Toastify.__lastTickTime := A_TickCount
            SetTimer(Toastify.__globalTimer, -16)
        } else {
            DllCall("Winmm.dll\timeEndPeriod", "UInt", 2)
            ProcessSetPriority(Toastify.PRIORITY.NORMAL)
            if (Toastify.__globalTimer)
                SetTimer(Toastify.__globalTimer, 0)
        }
    }

    static Shutdown(*) {
        Toastify.__setActive(false)
        for t in Toastify.toasts
            t.Destroy()
        for t in Toastify.exitingToasts
            t.Destroy()
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
        Toastify.__setActive(true)
        Toastify.__reflow(true)
        t.InitAnimation()
        t.Draw()
        t.AnimateIn()
        return t
    }

    static DismissAll() {
        for t in Toastify.toasts.Clone()
            t.StartExit()
    }

    static __createToast(title, body, actions, opts) {
        if !opts
            opts := {}
        if !opts.HasProp("theme")
            opts.theme := Toastify.theme
        if !opts.HasProp("position")
            opts.position := Toastify.position

        ; count how many visible toasts share this position
        pos := opts.position
        refT := 0
        for t in Toastify.toasts
            if (t.position = pos) {
                refT := t
                break
            }
        if (refT) {
            rx := refT.targetX > 0 ? refT.targetX : refT.currentX
            ry := refT.targetY > 0 ? refT.targetY : refT.currentY
            wa := ToastDPI.WorkArea(rx, ry)
            dpi := ToastDPI.ForPoint(rx, ry)
        } else {
            wa := ToastDPI.WorkArea(0, 0)
            dpi := ToastDPI.Primary()
        }
        marginY := ToastDPI.Px(Toastify.marginY, dpi)
        spacing := ToastDPI.Px(Toastify.spacing, dpi)

        availableH := wa.h - marginY * 2
        usedH := 0
        toastsInPos := 0
        for t in Toastify.toasts {
            if (t.position = pos) {
                usedH += t.height + spacing
                toastsInPos++
            }
        }
        ; altura estimada del nuevo toast
        estHeight := ToastDPI.Px(120, dpi)
        if (usedH + estHeight > availableH && toastsInPos > 0) {
            ; evict the oldest toast in that position
            for t in Toastify.toasts {
                if (t.position = pos) {
                    t.StartExit()
                    break
                }
            }
        }

        ; hard cap global
        if (Toastify.toasts.Length >= Toastify.maxToasts) {
            Toastify.toasts[1].StartExit()
        }

        ; pass the computed destination-monitor dpi to the constructor
        opts := opts.Clone()
        opts.dpi := dpi

        t := Toast(title, body, actions, opts)
        Toastify.toasts.Push(t)
        Toastify.__setActive(true)
        Toastify.__reflow(true)
        t.InitAnimation()

        t.AnimateIn()
        t.Draw()
        Toastify._reflowNeeded := true
        return t
    }

    static __reflow(animate := true) {
        if (Toastify.toasts.Length = 0)
            return

        groups := Map()
        for t in Toastify.toasts {
            pos := t.position
            if !groups.Has(pos)
                groups[pos] := []
            groups[pos].Push(t)
        }

        now := A_TickCount

        for pos, group in groups {
            refT := group[1]
            ; Use target (final position) to resolve the monitor; fallback currentX/Y
            refX := refT.targetX > 0 ? refT.targetX : ((refT.currentX > 0 && refT.currentX < A_ScreenWidth) ? refT.currentX : 0)
            refY := refT.targetY > 0 ? refT.targetY : ((refT.currentY > 0 && refT.currentY < A_ScreenHeight) ? refT.currentY : 0)
            wa := ToastDPI.WorkArea(refX, refY)
            dpi := ToastDPI.ForPoint(refX, refY)

marginX := ToastDPI.Px(Toastify.marginX, dpi)
        marginY := ToastDPI.Px(Toastify.marginY, dpi)
        spacing := ToastDPI.Px(Toastify.spacing, dpi)

            isBottom := InStr(pos, "bottom") || pos = "bottom"
            isMidV := (pos = "left" || pos = "right" || pos = "center")
            total := group.Length

            waSCX := wa.x + wa.w // 2
            waSCY := wa.y + wa.h // 2

            _getX(t, p) {
                ; explicit p: closures don't capture `for` loop variables
                ; by reference → snapshot of the first group = wrong X.
                if (InStr(p, "right") || p = "right")
                    return wa.x + wa.w - marginX - t.width
                if (InStr(p, "left") || p = "left")
                    return wa.x + marginX
                return waSCX - t.width // 2
            }

            ; ── compute how much vertical space is available ─────────
            availableH := wa.h - marginY * 2

            ; ── calcular targets y detectar overflow ────────────────
            ; Each target carries gi = ORIGINAL index in group; assignment
            ; uses that key, not the array position (the reverse+truncated
            ; bottom branch broke that assumption → toasts at (0,0)).
            targets := []

            if (!isBottom && !isMidV) {
                cursor := wa.y + marginY
                for idx, t in group {
                    if (cursor + t.height > wa.y + wa.h - marginY)
                        break   ; just don't assign a position to those that don't fit
                    targets.Push({ x: _getX(t, pos), y: cursor, gi: idx })
                    cursor += t.height + spacing
                }
            } else if (isBottom) {
                cursor := wa.y + wa.h - marginY
                loop total {
                    idx := total + 1 - A_Index
                    t := group[idx]
                    cursor -= t.height
                    if (cursor < wa.y + marginY) {
                        cursor += t.height  ; revertir
                        break
                    }
                    targets.Push({ x: _getX(t, pos), y: cursor, gi: idx })
                    cursor -= spacing
                }
            } else {
                totalH := 0
                for t in group
                    totalH += t.height + spacing
                totalH -= spacing
                cursor := Max(wa.y + marginY, waSCY - totalH // 2)
                for idx, t in group {
                    if (cursor + t.height > wa.y + wa.h - marginY)
                        break   ; truncate overflow in midV too
                    targets.Push({ x: _getX(t, pos), y: cursor, gi: idx })
                    cursor += t.height + spacing
                }
            }

            for target in targets {
                t := group[target.gi]
                x := target.x
                y := target.y
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
                } else if (t.animState == "visible" || t.animState == "in") {
                    if (animate) {
                        if (Abs(t.repoTargetX - x) > 0.5 || Abs(t.repoTargetY - y) > 0.5) {
                            t.repoStartX := t.currentX
                            t.repoStartY := t.currentY
                            t.repoTargetX := x
                            t.repoTargetY := y
                            t.repoStartTime := now
                            t.repoActive := true
                            ; Si estaba en "in", promover a "visible" para que el repositioning funcione
                            if (t.animState == "in")
                                t.animState := "visible"
                        }
                    } else {
                        t.repoActive := false
                        t.repoTargetX := x
                        t.repoTargetY := y
                        t.currentX := x
                        t.currentY := y
                        if (t.animState == "in")
                            t.animState := "visible"
                        if (t.hwnd && DllCall("IsWindow", "ptr", t.hwnd))
                            t.UpdateWindow(x, y)
                    }
                }
            }
        }
    }

    static __globalTick(*) {
        now := A_TickCount
        elapsed := now - Toastify.__lastTickTime
        Toastify.__lastTickTime := now
        SetTimer(Toastify.__globalTimer, -Max(1, 16 - elapsed))

        ; ── Idle: sin toasts, sin ventanas → apagar timer + period + prioridad ──
        if (Toastify.toasts.Length + Toastify.exitingToasts.Length + Toastify.registry.Count = 0
            && !Toastify._reflowNeeded) {
            Toastify.__setActive(false)
            return
        }
        Toastify.__setActive(true)

        ; ── Contador de frames: multiplexa sub-tareas de menor frecuencia ──
        frame := ++Toastify.__frameCounter

        ; ── Cada 6 frames (~10Hz): registry scan + watchdog + iconic restore ──
        if (Mod(frame, 6) = 1) {
            anyIconicNow := false
            iconicHwnds := []
            deadHwnds := []
            ; Scan + watchdog in ONE pass (previously 3 loops over registry)
            for hwnd, data in Toastify.registry {
                if (!DllCall("IsWindow", "ptr", hwnd)) {
                    deadHwnds.Push(hwnd)
                    continue
                }
                if (DllCall("IsIconic", "ptr", hwnd)) {
                    anyIconicNow := true
                    iconicHwnds.Push(hwnd)
                }

                ; Watchdog de tiempo de vida
                t := (data.HasOwnProp("instance") && data.instance) ? data.instance : 0
                if (t && t.hovered && t.progressPaused && Toastify.hoverPauseEnabled)
                    continue
                if (data.duration > 0 && t) {
                    expectedLifetime := t.animDuration + data.duration + 500
                    actualLifetime := now - data.startTime
                    if (actualLifetime > expectedLifetime) {
                        if (t.animState == "out")
                            if (actualLifetime > expectedLifetime + t.animDuration + 500) {
                                t.Dismiss(true)
                                if (Toastify.registry.Has(hwnd))
                                    Toastify.registry.Delete(hwnd)
                            }
                            else
                                t.StartExit()
                    }
                } else if (data.duration > 0 && !t)
                    if (now - data.startTime > data.duration + 1000)
                        if (Toastify.registry.Has(hwnd))
                            Toastify.registry.Delete(hwnd)
            }
            for hwnd in deadHwnds
                if (Toastify.registry.Has(hwnd))
                    Toastify.registry.Delete(hwnd)

            ; ── Hover safety: WM_MOUSELEAVE on layered windows is unreliable
            ;    → hovered can stay true and opacity pinned at 100%.
            ;    Rect check (only if something is hovered). DON'T use
            ;    WindowFromPoint: unreliable for layered windows and it
            ;    cleared hover with the cursor on top.
            anyHovered := false
            for t in Toastify.toasts
                if (t.hovered) {
                    anyHovered := true
                    break
                }
            if (!anyHovered)
                for t in Toastify.exitingToasts
                    if (t.hovered) {
                        anyHovered := true
                        break
                    }
            if (anyHovered) {
                pt := Buffer(8, 0)
                DllCall("GetCursorPos", "ptr", pt)
                mx := NumGet(pt, 0, "int")
                my := NumGet(pt, 4, "int")
for t in Toastify.toasts
                if (t.hovered && !(mx >= t.currentX && mx <= t.currentX + t.width
                    && my >= t.currentY && my <= t.currentY + t.height))
                    t.OnMouseLeave()
            for t in Toastify.exitingToasts
                if (t.hovered && !(mx >= t.currentX && mx <= t.currentX + t.width
                    && my >= t.currentY && my <= t.currentY + t.height))
                    t.OnMouseLeave()
            ; X button safety: if the cursor is no longer over the X region
            ; (even if still inside the toast and without WM_MOUSEMOVE), clear its hover.
            for t in Toastify.toasts
                if (t.closeHovered) {
                    ox := (t.bufferWidth - t.width) // 2
                    oy := (t.bufferHeight - t.height) // 2
                    d := t.dpiFactor
                    cxx := t.currentX - ox + t.width - t.paddingX - 20 * d + 10 * d
                    cyy := t.currentY - oy + t.paddingY - 4 * d + 10 * d
                    cr := 10 * d
                    dx := mx - cxx
                    dy := my - cyy
                    if (dx * dx + dy * dy > cr * cr) {
                        t.closeHovered := false
                        t.__updateCloseHover()
                    }
                }
            }

            if (anyIconicNow) {
                ; Restaurar ventanas minimizadas con SetWindowPos
                ; (SW_SHOWNOACTIVATE=4 NO restaura ventanas minimizadas)
                for hwnd in iconicHwnds {
                    ; Robust method: remove WS_MINIMIZE from the style + SetWindowPos
                    style := DllCall("GetWindowLongPtr", "ptr", hwnd, "int", -16, "ptr")
                    if (style & 0x20000000) {          ; WS_MINIMIZE
                        style &= ~0x20000000
                        DllCall("SetWindowLongPtr", "ptr", hwnd, "int", -16, "ptr", style)
                        ; SWP_NOSIZE(1)|SWP_NOMOVE(2)|SWP_NOACTIVATE(16)|SWP_SHOWWINDOW(64)|SWP_FRAMECHANGED(32) = 0x0073
                        DllCall("SetWindowPos", "ptr", hwnd, "ptr", -1
                            , "int", 0, "int", 0, "int", 0, "int", 0
                            , "uint", 0x0073)
                    }
                }
            }

            if (Toastify.__wasAnyIconic && !anyIconicNow) {
                ; ── Acabamos de salir del estado minimizado: snap total ──
                Toastify.__reflow(false)
                for t in Toastify.toasts {
                    ; Force animState to "visible" (it may have been left in "in")
                    if (t.animState != "out")
                        t.animState := "visible"
                    t.repoActive := false
                    t.repoTargetX := t.targetX
                    t.repoTargetY := t.targetY
                    t.currentX := t.targetX
                    t.currentY := t.targetY
                    t.cacheDirty := true
                    t._lastRenderX := -999999
                    t._lastRenderY := -999999
                    t._lastAlpha := -1
                    t.Draw()
                    ; Forzar UpdateLayeredWindow completo
                    try t.UpdateWindow(t.currentX, t.currentY, Floor(t.opacity * 255))
                }
            }
            Toastify.__wasAnyIconic := anyIconicNow
        }


        ; expiration logic (lightweight): StartExit already removes from toasts and
        ; moves it to exitingToasts; the RemoveAt/re-push was dead code.
        while (Toastify.toasts.Length > Toastify.maxToasts)
            Toastify.toasts[1].StartExit()

        toastsToExit := []
        for t in Toastify.toasts {
            if (t.animState == "out") {
                toastsToExit.Push(t)
                continue
            }
            t.Tick()
        }
        for t in toastsToExit
            t.StartExit()

        i := 1
        while (i <= Toastify.exitingToasts.Length) {
            t := Toastify.exitingToasts[i]
            t.Tick()
            if (t.animState == "out" && (A_TickCount - t.animStartTime > t.animDuration)) {
                t.Dismiss(true)   ; Dismiss ya llama __reflow
            } else
                i++
        }

        if (Toastify._reflowNeeded) {
            Toastify.__reflow(true)
            Toastify._reflowNeeded := false
        }
    }

    static __toastByHwnd(hwnd) {
        if (Toastify.registry.Has(hwnd))
            return Toastify.registry[hwnd].instance
        return 0
    }
    static __trackLeave(hwnd) {
        tr := Buffer(16, 0)
        NumPut("uint", 16, tr, 0)      ; cbSize
        NumPut("uint", 2, tr, 4)        ; TME_LEAVE
        NumPut("ptr", hwnd, tr, 8)
        DllCall("TrackMouseEvent", "ptr", tr)
    }
    static __onMouseMove(lParam, hwnd) {
        t := Toastify.__toastByHwnd(hwnd)
        if !t
            return
        Toastify.__trackLeave(hwnd)
        x := lParam & 0xFFFF
        y := (lParam >> 16) & 0xFFFF
        ; Coordenadas cliente = ventana completa; restar offset del buffer
        ; expandido (rotate/zoom) para que coincidan con clickRegions (0..width).
        x -= (t.bufferWidth - t.width) // 2
        y -= (t.bufferHeight - t.height) // 2
        t.OnMouseMove(x, y)
    }
    static __onMouseLeave(hwnd) {
        t := Toastify.__toastByHwnd(hwnd)
        if t
            t.OnMouseLeave()
    }

    static __Click(wParam, lParam, msg, hwnd) {
        for t in Toastify.toasts
            if (t.hwnd == hwnd) {
                x := lParam & 0xFFFF
                y := (lParam >> 16) & 0xFFFF
                t.OnClick(x, y)
                return
            }
        for t in Toastify.exitingToasts
            if (t.hwnd == hwnd) {
                x := lParam & 0xFFFF
                y := (lParam >> 16) & 0xFFFF
                t.OnClick(x, y)
                return
            }
    }
}

class ToastTheme {
    static themes := Map()
    static InitThemes() {
        if (ToastTheme.themes.Count > 0)
            return

        ; ═══════════════════════════════════════════════════════════════
        ; DARK THEMES — high saturation, stronger shadows, vivid accents
        ; ═══════════════════════════════════════════════════════════════

        ToastTheme.Register("error", {
            bg1: 0xEE2D1517, bg2: 0xEE1A0D10,
            fg: 0xFFFECACA, accent: 0xFFF87171,
            shadow: 0x77EF4444, progress: 0xFFEF4444
        })
        ToastTheme.Register("warning", {
            bg1: 0xEE2D1B0E, bg2: 0xEE1A1008,
            fg: 0xFFFEF3C7, accent: 0xFFFB923C,
            shadow: 0x77F97316, progress: 0xFFEA580C
        })
        ToastTheme.Register("success", {
            bg1: 0xEE0A2312, bg2: 0xEE06140B,
            fg: 0xFFA7F3D0, accent: 0xFF34D399,
            shadow: 0x7710B981, progress: 0xFF059669
        })
        ToastTheme.Register("info", {
            bg1: 0xEE0F2035, bg2: 0xEE0A1525,
            fg: 0xFFBFDBFE, accent: 0xFF60A5FA,
            shadow: 0x773B82F6, progress: 0xFF2563EB
        })
        ToastTheme.Register("dark", {
            bg1: 0xEE1F2937, bg2: 0xEE0F172A,
            fg: 0xFFF9FAFB, accent: 0xFF818CF8,
            shadow: 0x77000000, progress: 0xFF6366F1
        })
        ToastTheme.Register("midnight", {
            bg1: 0xEE0F172A, bg2: 0xEE1E293B,
            fg: 0xFFE2E8F0, accent: 0xFF38BDF8,
            shadow: 0x770F172A, progress: 0xFF0EA5E9
        })
        ToastTheme.Register("forest", {
            bg1: 0xEE052E16, bg2: 0xEE064E3B,
            fg: 0xFFA7F3D0, accent: 0xFF34D399,
            shadow: 0x77064E3B, progress: 0xFF10B981
        })
        ToastTheme.Register("neon", {
            bg1: 0xEE0F0518, bg2: 0xEE1A0B2E,
            fg: 0xFFF5D0FE, accent: 0xFFE879F9,
            shadow: 0x99D946EF, progress: 0xFFC026D3
        })
        ToastTheme.Register("vapor", {
            bg1: 0xEE10002B, bg2: 0xEE240046,
            fg: 0xFFE0AAFF, accent: 0xFF22D3EE,
            shadow: 0x7700FFFF, progress: 0xFFE879F9
        })
        ToastTheme.Register("cyberpunk", {
            bg1: 0xEE000000, bg2: 0xEE0A0A0A,
            fg: 0xFFFCEE0A, accent: 0xFF00F0FF,
            shadow: 0x88FCEE0A, progress: 0xFFFF003C
        })
        ToastTheme.Register("retro", {
            bg1: 0xEE0A0A0A, bg2: 0xEE000000,
            fg: 0xFF33FF00, accent: 0xFF33FF00,
            shadow: 0x4433FF00, progress: 0xFF33FF00
        })
        ToastTheme.Register("glass", {
            bg1: 0xCC1F2937, bg2: 0xCC111827,
            fg: 0xFFFFFFFF, accent: 0xCCFFFFFF,
            shadow: 0x44000000, progress: 0xFFFFFFFF, progressBg: 0x40FFFFFF
        })
        ToastTheme.Register("minimal", {
            bg1: 0xFF0A0A0A, bg2: 0xFF000000,
            fg: 0xFFFFFFFF, accent: 0xFFFFFFFF,
            shadow: 0x33000000, progress: 0xFFAAAAAA, progressBg: 0x40FFFFFF
        })
        ToastTheme.Register("pastel", {
            bg1: 0xEE1F1F23, bg2: 0xEE18181B,
            fg: 0xFFFFD1DC, accent: 0xFFFB7185,
            shadow: 0x55000000, progress: 0xFFFB7185
        })
        ToastTheme.Register("flat", {
            bg1: 0xFF1E293B, bg2: 0xFF0F172A,
            fg: 0xFFF1F5F9, accent: 0xFFCBD5E1,
            shadow: 0x33000000, progress: 0xFF94A3B8, progressBg: 0x40FFFFFF
        })

        ; ═══════════════════════════════════════════════════════════════
        ; LIGHT THEMES — more saturation, visible gradient, AAA contrast
        ; ═══════════════════════════════════════════════════════════════

        ToastTheme.Register("error-light", {
            bg1: 0xFFFEE2E2, bg2: 0xFFFCA5A5,
            fg: 0xFF7F1D1D, accent: 0xFFDC2626,
            shadow: 0x44DC2626, progress: 0xFFB91C1C
        })
        ToastTheme.Register("warning-light", {
            bg1: 0xFFFEF3C7, bg2: 0xFFFDE68A,
            fg: 0xFF78350F, accent: 0xFFEA580C,
            shadow: 0x44EA580C, progress: 0xFFC2410C
        })
        ToastTheme.Register("success-light", {
            bg1: 0xFFDCFCE7, bg2: 0xFFBBF7D0,
            fg: 0xFF064E3B, accent: 0xFF059669,
            shadow: 0x44059669, progress: 0xFF047857
        })
        ToastTheme.Register("info-light", {
            bg1: 0xFFDBEAFE, bg2: 0xFFBFDBFE,
            fg: 0xFF1E3A8A, accent: 0xFF2563EB,
            shadow: 0x442563EB, progress: 0xFF1D4ED8
        })
        ToastTheme.Register("light", {
            bg1: 0xFFFAFBFC, bg2: 0xFFE2E8F0,
            fg: 0xFF0F172A, accent: 0xFF6366F1,
            shadow: 0x44000000, progress: 0xFF4F46E5
        })
        ToastTheme.Register("midnight-light", {
            bg1: 0xFFE0F2FE, bg2: 0xFFBAE6FD,
            fg: 0xFF0C4A6E, accent: 0xFF0284C7,
            shadow: 0x440284C7, progress: 0xFF0369A1
        })
        ToastTheme.Register("forest-light", {
            bg1: 0xFFD1FAE5, bg2: 0xFFA7F3D0,
            fg: 0xFF064E3B, accent: 0xFF059669,
            shadow: 0x4410B981, progress: 0xFF047857
        })
        ToastTheme.Register("neon-light", {
            bg1: 0xFFFAF5FF, bg2: 0xFFE9D5FF,
            fg: 0xFF581C87, accent: 0xFFA855F7,
            shadow: 0x44A855F7, progress: 0xFF9333EA
        })
        ToastTheme.Register("vapor-light", {
            bg1: 0xFFFCE7F3, bg2: 0xFFCFFAFE,
            fg: 0xFF831843, accent: 0xFF06B6D4,
            shadow: 0x4406B6D4, progress: 0xFFDB2777
        })
        ToastTheme.Register("cyberpunk-light", {
            bg1: 0xFFFCEE0A, bg2: 0xFFFDD835,
            fg: 0xFF000000, accent: 0xFFFF003C,
            shadow: 0x66000000, progress: 0xFF000000, progressBg: 0x66FFFFFF
        })
        ToastTheme.Register("retro-light", {
            bg1: 0xFFFBE5C8, bg2: 0xFFE8C896,
            fg: 0xFF3E2723, accent: 0xFFD2691E,
            shadow: 0x44D2691E, progress: 0xFFA0522D
        })
        ToastTheme.Register("glass-light", {
            bg1: 0xDDFFFFFF, bg2: 0xDDE2E8F0,
            fg: 0xFF0F172A, accent: 0xCC6366F1,
            shadow: 0x33000000, progress: 0xCC6366F1
        })
        ToastTheme.Register("minimal-light", {
            bg1: 0xFFFFFFFF, bg2: 0xFFF1F5F9,
            fg: 0xFF000000, accent: 0xFF000000,
            shadow: 0x33000000, progress: 0xFF525252, progressBg: 0x59000000
        })
        ToastTheme.Register("pastel-light", {
            bg1: 0xFFFFE4E6, bg2: 0xFFFFC9D6,
            fg: 0xFF4A1942, accent: 0xFFE11D48,
            shadow: 0x44E11D48, progress: 0xFFBE123C
        })
        ToastTheme.Register("flat-light", {
            bg1: 0xFFF1F5F9, bg2: 0xFFCBD5E1,
            fg: 0xFF0F172A, accent: 0xFF475569,
            shadow: 0x33000000, progress: 0xFF1E293B
        })
    }

    static Register(name, palette) {
        if (ToastTheme.themes.Has(name))
            ToastTheme.DeletePalette(ToastTheme.themes[name])
        if !palette.HasOwnProp("border") {
            accentRGB := palette.accent & 0xFFFFFF
            palette.border := 0xCC000000 | accentRGB
        }
        if !palette.HasOwnProp("progressBg") {
            c := palette.bg1 & 0xFFFFFF
            lum := ((c >> 16) & 0xFF) * 0.299 + ((c >> 8) & 0xFF) * 0.587 + (c & 0xFF) * 0.114
            palette.progressBg := lum < 128 ? 0x55FFFFFF : 0x33000000
        }
        if !palette.HasOwnProp("borderWidth")
            palette.borderWidth := 1.5
        palette.shadowBrush := Gdip_BrushCreateSolid(palette.shadow)
        palette.borderPen := Gdip_CreatePen(palette.border, palette.borderWidth)
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

    static DeletePalette(pal) {
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
    static Shutdown() {
        for name, pal in ToastTheme.themes
            ToastTheme.DeletePalette(pal)
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
    iconScale := 1
    designScale := 1
    borderRadius := 18
    borderWidth := 0
    animDuration := 300
    animEasing := "easeOutCubic"
    animStyle := "slide"
    animEntrance := "auto"
    repoDuration := 300
    renderQuality := "High"

    rotationDegree := 10

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
    iconScale := 1
    designScale := 1
    showClose := true
    showProgress := true
    hwnd := 0
    gui := 0
    hbm := 0
    hdc := 0
    obm := 0
    G := 0
    exitTargetX := 0
    exitTargetY := 0
    exitStartX := 0
    exitStartY := 0
    static _cfgKeys := ["width", "fontName", "fontSizeTitle", "fontSizeBody", "fontWeightTitle", "fontWeightBody",
        "paddingX", "paddingY", "iconSize", "iconScale", "designScale", "borderRadius", "borderWidth", "animDuration", "animEasing",
        "animStyle", "animEntrance", "renderQuality", "repoDuration", "rotationDegree"]
    static _styleKeys := ["fontName", "fontSizeTitle", "fontSizeBody", "fontWeightTitle", "fontWeightBody",
        "paddingX", "paddingY", "iconSize", "iconScale", "designScale", "borderRadius", "borderWidth", "animDuration", "renderQuality",
        "rotationDegree"]
    pBitmapCache := 0
    GCache := 0
    cacheDirty := true
    _compositeDirty := true
    ; ── Progress overlay: small bitmap, only it gets redrawn ──
    _progressBitmap := 0
    _GProgress := 0
    _progressW := 0
    _progressH := 0
    ; ── Close button: its own small bitmap; the hover halo does NOT redraw
    ;    the full cache (gradient + shadow + text) ──
    _closeBitmap := 0
    _GClose := 0
    _closeW := 0
    _closeH := 0
    _closeHoveredRendered := -1
    ; ── Fix #4: text cache (rendered only once) ──
    _textRendered := false
    _textRenderedTheme := ""
    _buttonClickRegions := []
    _textBitmap := 0      ; separate bitmap where text + buttons are rasterized (Fix bug #4)
    _GText := 0           ; graphics context of _textBitmap
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
    rotation := 90
    resolvedEntrance := "right"
    _hasSlide := false
    _hasFade := false
    _hasZoom := false
    _hasRotate := false
    _baseCfg := 0
    dpiFactor := 1.0
    _dpi := 0
    bufferWidth := 0
    bufferHeight := 0
    progress := 0.0
    progressStartTime := 0
    ; progressPaused := false
    ; progressPauseTime := 0
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
    _baseOpacity := 1.0
    opacityOnHover := false
    _hoverOpacityFrom := 0.0
    _hoverOpacityTarget := 0.0
    _hoverOpacityStart := 0
    _hoverOpacityActive := false
    _hoverOpacityDur := 180
    _windowShown := false
    _initialized := false

    __New(title, body, actions, opts) {
        dpi := 1.0

        this.title := title
        this.body := body
        this.actions := actions
        cfg := Toastify.config
        for key in Toast._cfgKeys
            if cfg.HasProp(key)
                this.%key% := cfg.%key%
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
                if opts.HasProp("opacity")
                    this._baseOpacity := opts.opacity
                if opts.HasProp("opacityOnHover")
                    this.opacityOnHover := !!opts.opacityOnHover

            }
            for key in Toast._styleKeys
                try
                    if opts.HasProp(key)
                        this.%key% := opts.%key%
            this.progressPaused := false
            try {
                if opts.HasProp("animStyle")
                    this.animStyle := opts.animStyle
                else
                    this.animStyle := Toastify.config.animStyle
            }
            if Type(this.animStyle) == "String"
                this.animStyle := [this.animStyle]
            else if !HasProp(this.animStyle, "Length")
                this.animStyle := ["fade"]
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
            try
                if opts.HasProp("permanent")
                    isPermanent := !!opts.permanent
            if (isPermanent) {
                this.autoDismiss := false
                if !opts.HasProp("duration")
                    this.duration := 0
                if !opts.HasProp("showProgress")
                    this.showProgress := false
            }
        }
        this.creationTime := A_TickCount
        ; DPI of the destination monitor, computed by __createToast (opts.dpi).
        this._dpi := (IsObject(opts) && opts.HasProp("dpi")) ? opts.dpi : ToastDPI.Primary()
        this._saveBaseCfg()
        this.__createWindow()
    }

    __deleteThemeCache() {
        if (this._bgBrush) {
            Gdip_DeleteBrush(this._bgBrush)
            this._bgBrush := 0
        }
        if (this._closeHoverBrush) {
            Gdip_DeleteBrush(this._closeHoverBrush)
            this._closeHoverBrush := 0
        }
        if (this._closePenNormal) {
            Gdip_DeletePen(this._closePenNormal)
            this._closePenNormal := 0
        }
        if (this._closePenHover) {
            Gdip_DeletePen(this._closePenHover)
            this._closePenHover := 0
        }
        if (this._customBorderPen) {
            Gdip_DeletePen(this._customBorderPen)
            this._customBorderPen := 0
        }
        this._bgBrushTheme := ""
    }

    __initThemeCache(pal) {
        this._bgBrush := Gdip_CreateLineBrushFromRect(0, 0, this.width, this.height, pal.bg1, pal.bg2, 1, 1)
        if (!this._bgBrush)
            this._bgBrush := Gdip_BrushCreateSolid(pal.bg1 & 0xFFFFFF)
        this._bgBrushTheme := this.theme

        ; 2) Circular halo of the close button on hover (constant)
        this._closeHoverBrush := Gdip_BrushCreateSolid(0x33FFFFFF)

        ; 3) Dos pens del aspa del close: normal + hover (constantes)
        ;    OJO: usar dpiFactor (1.0), no dpi (96). dpiFactor es el factor de escala real.
        this._closePenNormal := Gdip_CreatePen(0xAAFFFFFF, 2 * this.dpiFactor)
        this._closePenHover := Gdip_CreatePen(0xFFFFFFFF, 2 * this.dpiFactor)

        ; 4) Custom border (only if borderWidth > 0)
        if (this.borderWidth > 0) {
            this._customBorderPen := Gdip_CreatePen(pal.border, this.borderWidth)
            this._customBorderTheme := this.theme
        } else {
            this._customBorderPen := 0
            this._customBorderTheme := ""
        }
    }
    _applyDpi() {
        ; Real DPI of the destination monitor (computed by __createToast before
        ; constructing; primary fallback). The thread is Per-Monitor v2
        ; (see ToastDPI.ahk), so this dpi is the real physical one and the
        ; content must be scaled by hand: design px × dpiFactor.
        dpi := (this._dpi > 0) ? this._dpi : ToastDPI.Primary()
        this.dpi := dpi
        this.dpiFactor := ToastDPI.Factor(dpi)
        s := this._baseCfg.designScale
        p := (pts) => ToastDPI.Px(pts * s, dpi)

        this.width := p(this._baseCfg.width)
        this.height := p(this._baseCfg.minHeight)
        this.fontSizeTitle := Round(this._baseCfg.fontSizeTitle * this.dpiFactor * s)
        this.fontSizeBody := Round(this._baseCfg.fontSizeBody * this.dpiFactor * s)
        this.paddingX := p(this._baseCfg.paddingX)
        this.paddingY := p(this._baseCfg.paddingY)
        this.iconSize := p(this._baseCfg.iconSize)
        this.borderRadius := p(this._baseCfg.borderRadius)
        this.borderWidth := Round(this._baseCfg.borderWidth * this.dpiFactor * s)
        this.repoDuration := this._baseCfg.repoDuration
        this.height := Max(this.height, this.__autoHeight())
    }
    __autoHeight() {
        d := this.dpiFactor
        extras := 0
        if (this.actions.Length > 0)
            extras += 38 * d
        if (this.showProgress && this.duration > 0)
            extras += 12 * d
        textW := this.width - this.paddingX * 2
        if (this.icon != "" && this.icon != "none")
            textW -= this.iconSize * this.iconScale + 12 * d
        if (this.showClose)
            textW -= 40 * d
        textW := Max(60 * d, textW)
        tmpBmp := Gdip_CreateBitmap(1, 1)
        tmpG := tmpBmp ? Gdip_GraphicsFromImage(tmpBmp) : 0
        titleH := (this.title = "") ? 0 : this.__measureTextH(tmpG, this.title, textW, this.fontSizeTitle, this.fontWeightTitle)
        bodyH := (this.body = "") ? 0 : this.__measureTextH(tmpG, this.body, textW, this.fontSizeBody, this.fontWeightBody)
        if (tmpG) {
            Gdip_DeleteGraphics(tmpG)
            Gdip_DisposeImage(tmpBmp)
        }
        titleBoxH := (this.title = "") ? 0 : Max(this.fontSizeTitle * 1.5, titleH)
        bodyY := this.paddingY + titleBoxH + (this.title = "" ? 0 : 4 * d)
        h := bodyY + bodyH + this.paddingY + extras
        if (this.icon != "" && this.icon != "none")
            h := Max(h, this.iconSize * this.iconScale + this.paddingY + extras)
        return Ceil(h)
    }
    __measureTextH(G, text, w, fontSize, weight) {
        if (!G)
            return 0
        hFam := Gdip_FontFamilyCreate(this.fontName)
        if (!hFam)
            return 0
        style := (weight = "Bold") ? 1 : (weight = "Italic") ? 2 : (weight = "BoldItalic") ? 3 : 0
        hFont := Gdip_FontCreate(hFam, fontSize, style)
        hFmt := Gdip_StringFormatCreate(0x4000)
        layout := Buffer(16)
        NumPut("float", 0, layout, 0)
        NumPut("float", 0, layout, 4)
        NumPut("float", w, layout, 8)
        NumPut("float", 10000, layout, 12)
        ms := Gdip_MeasureString(G, text, hFont, hFmt, &layout)
        h := IsObject(ms) ? 0 : Ceil(StrSplit(ms, "|")[4])
        Gdip_DeleteFontFamily(hFam)
        Gdip_DeleteFont(hFont)
        Gdip_DeleteStringFormat(hFmt)
        return h
    }
    _saveBaseCfg() {
        ; Keeps a copy of the design values at 96 DPI
        ; (as they arrived from ToastConfig/opts) without scaling.
        this._baseCfg := {
            width: this.width,
            minHeight: Toastify.config.minHeight,
            fontSizeTitle: this.fontSizeTitle,
            fontSizeBody: this.fontSizeBody,
            paddingX: this.paddingX,
            paddingY: this.paddingY,
            iconSize: this.iconSize,
            designScale: this.designScale,
            borderRadius: this.borderRadius,
            borderWidth: this.borderWidth,
            repoDuration: this.repoDuration
        }
    }
    __createWindow() {
        this.gui := Gui("-Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs")
        this.hwnd := this.gui.Hwnd
        this._windowShown := false

        ; ── Real DPI of the monitor where the toast will appear ──
        ; At this point targetX/Y are already assigned by __reflow.
        ; If they're still 0 we use point 0,0 (primary monitor).
        this._applyDpi()

        ; buffers in physical px, already scaled
        this.bufferWidth := this.width
        this.bufferHeight := this.height

        this.hbm := CreateDIBSection(this.bufferWidth, this.bufferHeight)
        this.hdc := CreateCompatibleDC()
        this.obm := SelectObject(this.hdc, this.hbm)
        this.G := Gdip_GraphicsFromHDC(this.hdc)
        Gdip_SetSmoothingMode(this.G, 4)

        this.pBitmapCache := Gdip_CreateBitmap(this.width, this.height)
        this.GCache := Gdip_GraphicsFromImage(this.pBitmapCache)
        this.__applyRenderQuality(this.G, false)
        this.__applyRenderQuality(this.GCache, true)

        ; Cachea brushes/pens del tema (se reutilizan en cada __drawCache)
        this.__initThemeCache(ToastTheme.palette(this.theme))

        Toastify.registry[this.hwnd] := {
            startTime: A_TickCount,
            duration: this.autoDismiss ? this.duration : 0,
            instance: this
        }
    }
    Draw() {
        if (!this._initialized)
            return
        if (this.cacheDirty) {
            this.__drawCache()
            this.cacheDirty := false
        }
        this.RenderToWindow()
    }
    __drawCache() {
        pal := ToastTheme.palette(this.theme)
        if (this._bgBrushTheme != this.theme) {
            this.__deleteThemeCache()
            this.__initThemeCache(pal)
        }
        d := this.dpiFactor
        this.clickRegions := []
        Gdip_GraphicsClear(this.GCache)
        Gdip_FillRoundedRectangle(this.GCache, pal.shadowBrush, 4 * d, 4 * d, this.width - 4 * d, this.height - 4 * d, this.borderRadius)
        ; Gradient brush cached in __initThemeCache
        Gdip_FillRoundedRectangle(this.GCache, this._bgBrush, 0, 0, this.width, this.height, this.borderRadius)
        if (this.borderWidth > 0)
            Gdip_DrawRoundedRectangle(this.GCache, this._customBorderPen, 2 * d, 2 * d, this.width - 4 * d, this.height - 4 * d, this.borderRadius - 1)
        else
            Gdip_DrawRoundedRectangle(this.GCache, pal.borderPen, 2 * d, 2 * d, this.width - 4 * d, this.height - 4 * d, this.borderRadius - 1)

        iconX := this.paddingX
        iconSize := this.iconSize * this.iconScale
        textStartX := this.paddingX
        if (this.icon != "" && this.icon != "none") {
            bodyY := (this.title != "") ? (this.paddingY + this.fontSizeTitle * 1.5 + 4 * d) : this.paddingY
            avail := this.height - bodyY - this.paddingY
            if (this.actions.Length > 0)
                avail -= 38 * d
            if (this.showProgress && this.duration > 0)
                avail -= 12 * d
            textBlockH := (bodyY + Max(20 * d, avail)) - this.paddingY
            iconY := this.paddingY + Max(0, Floor((textBlockH - iconSize) / 2))
            this.DrawIcon(iconX, iconY, iconSize, this.icon, pal)
            textStartX := iconX + iconSize + 12 * d
        }
        font := this.fontName
        if (this.showClose) {
            this.__ensureCloseBitmap()
            this.__renderCloseBitmap(pal)
            this.__blitClose()
            this.__pushCloseRegion()
        }

        ; ── Text (title + body + buttons): rasterized ONCE onto _textBitmap ──
        ; Then blitted over GCache each frame (a cheap Gdip_DrawImage).
        ; This lets GCache be cleared freely each __drawCache without losing the text.
        if (!this._textRendered || this._textRenderedTheme != this.theme) {
            this.__renderTextAndButtons(pal, font, d, textStartX)
            this._textRendered := true
            this._textRenderedTheme := this.theme
        }
        ; ALWAYS blit the text bitmap (preserves text between frames).
        if (this._textBitmap)
            Gdip_DrawImage(this.GCache, this._textBitmap, 0, 0, this.width, this.height, 0, 0, this.width, this.height)
        ; Reuse the cached button click-regions
        if (this._textRendered)
            for r in this._buttonClickRegions
                this.clickRegions.Push(r)

        if (this.showProgress && this.duration > 0)
            this.__drawProgress()
        this._compositeDirty := true
    }

    __ensureProgressBitmap() {
        if (this._progressBitmap)
            return
        d := this.dpiFactor
        this._progressW := this.width - 28 * d
        this._progressH := 3 * d
        this._progressBitmap := Gdip_CreateBitmap(this._progressW, this._progressH)
        if (!this._progressBitmap)
            return
        this._GProgress := Gdip_GraphicsFromImage(this._progressBitmap)
        this.__applyRenderQuality(this._GProgress, true)
    }

    __drawProgress() {
        if (!(this.showProgress && this.duration > 0))
            return
        pal := ToastTheme.palette(this.theme)
        d := this.dpiFactor
        this.__ensureProgressBitmap()
        Gdip_GraphicsClear(this._GProgress, 0x00000000)
        Gdip_FillRoundedRectangle(this._GProgress, pal.progressBgBrush, 0, 0, this._progressW, this._progressH, 2 * d)
        if (this.progress > 0) {
            fillWidth := this._progressW * this.progress
            Gdip_FillRoundedRectangle(this._GProgress, pal.progressFillBrush, 0, 0, fillWidth, this._progressH, 2 * d)
        }
        Gdip_DrawImage(this.GCache, this._progressBitmap, 14 * d, this.height - this._progressH - 7 * d
            , this._progressW, this._progressH, 0, 0, this._progressW, this._progressH)
        this._compositeDirty := true
    }

    __renderTextAndButtons(pal, font, d, textStartX) {
        ; ── Lazy init of the text bitmap (separate from GCache) ──
        ; Rasterized ONCE, then blitted over GCache in every __drawCache.
        if (!this._textBitmap) {
            this._textBitmap := Gdip_CreateBitmap(this.width, this.height)
            if (!this._textBitmap)
                return
            this._GText := Gdip_GraphicsFromImage(this._textBitmap)
            this.__applyRenderQuality(this._GText, true)
        }
        Gdip_GraphicsClear(this._GText, 0x00000000)

        titleWidth := this.width - textStartX - (this.showClose ? 40 * d : this.paddingX)

        if (this.title != "") {
            titleOpts := "x" textStartX " y" this.paddingY " w" titleWidth " c" Format("{:x}", pal.fg) " r4 s" this.fontSizeTitle " " this.fontWeightTitle
            Gdip_TextToGraphics(this._GText, this.title, titleOpts, font, this.width, this.height)
        }
        if (this.body != "") {
            bodyY := (this.title != "") ? (this.paddingY + this.fontSizeTitle * 1.5 + 4 * d) : this.paddingY
            availableHeight := this.height - bodyY - this.paddingY
            if (this.actions.Length > 0)
                availableHeight -= 38 * d
            if (this.showProgress && this.duration > 0)
                availableHeight -= 12 * d
            bodyHeight := Max(20 * d, availableHeight)
            bodyOpts := "x" textStartX " y" bodyY " w" titleWidth " h" bodyHeight " c" Format("{:x}", pal.fg) " r4 s" this.fontSizeBody " " this.fontWeightBody
            Gdip_TextToGraphics(this._GText, this.body, bodyOpts, font, this.width, this.height)
        }

        this._buttonClickRegions := []
        if (this.actions.Length) {
            ; Button text contrast: white or near-black, whichever gives the
            ; best WCAG ratio against the theme accent. (Some accents are
            ; light: retro/flat/minimal → white unreadable.)
            ar := (pal.accent >> 16) & 0xFF, ag := (pal.accent >> 8) & 0xFF, ab := pal.accent & 0xFF
            lr := ar / 255, lg := ag / 255, lb := ab / 255
            lr := lr <= 0.03928 ? lr / 12.92 : ((lr + 0.055) / 1.055) ** 2.4
            lg := lg <= 0.03928 ? lg / 12.92 : ((lg + 0.055) / 1.055) ** 2.4
            lb := lb <= 0.03928 ? lb / 12.92 : ((lb + 0.055) / 1.055) ** 2.4
            La := 0.2126 * lr + 0.7152 * lg + 0.0722 * lb
            btnFg := (La + 0.05) / 0.05 > 1.05 / (La + 0.05) ? 0xFF0F172A : 0xFFFFFFFF
            ; Custom buttons: measure each label → width by text, no wrap.
            ; If the row doesn't fit, shrink the button font (one pass).
            hFam := Gdip_FontFamilyCreate(font)
            hFmt := Gdip_StringFormatCreate(0x1000)
            layout := Buffer(16)
            NumPut("float", 0, layout, 0)
            NumPut("float", 0, layout, 4)
            NumPut("float", 10000, layout, 8)
            NumPut("float", 10000, layout, 12)
            btnFont := this.fontSizeBody
            availW := this.width - 32 * d - (this.actions.Length - 1) * 8 * d
            loop {
                widths := []
                total := 0
                for act in this.actions {
                    label := act.HasProp("text") ? act.text : act[1]
                    hFont := Gdip_FontCreate(hFam, btnFont, 1)
                    ms := Gdip_MeasureString(this._GText, label, hFont, hFmt, &layout)
                    Gdip_DeleteFont(hFont)
                    w := Ceil(Number(StrSplit(ms, "|")[3])) + 20 * d
                    widths.Push(w)
                    total += w
                }
                if (total <= availW || btnFont <= 8)
                    break
                btnFont := Max(8, Floor(btnFont * availW / total))
            }
            Gdip_DeleteFontFamily(hFam)
            Gdip_DeleteStringFormat(hFmt)
            leftover := Max(0, availW - total)
            factor := (total > availW) ? (availW / total) : 1
            share := Floor(leftover / this.actions.Length)
            y := this.height - (this.showProgress ? 50 * d : 40 * d)
            x := 16 * d
            for idx, act in this.actions {
                rectW := Floor(widths[idx] * factor) + share + (idx = this.actions.Length ? Mod(leftover, this.actions.Length) : 0)
                rectX := x, rectY := y, rectW := Floor(rectW), rectH := 28 * d
                ; Buttons are drawn on _textBitmap (part of the static content)
                Gdip_FillRoundedRectangle(this._GText, pal.accentBrush, rectX, rectY, rectW, rectH, 6 * d)
                Gdip_DrawRoundedRectangle(this._GText, pal.btnBorderPen, rectX, rectY, rectW, rectH, 6 * d)
                txtOpts := "x" rectX " y" rectY " w" rectW " h" rectH " c" Format("{:x}", btnFg) " r4 s" btnFont " Centre vCenter Bold"
                Gdip_TextToGraphics(this._GText, act.HasProp("text") ? act.text : act[1], txtOpts, font, this.width, this.height)
                this._buttonClickRegions.Push({ x: rectX, y: rectY, w: rectW, h: rectH, cb: (act.HasProp("onClick") ? act.onClick : act[2]), type: "button" })
                x += rectW + 8 * d
            }
        }
    }

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
    _lastRenderX := 0
    _lastRenderY := 0
    _lastAlpha := -1
    RenderToWindow() {
        compositeDone := false    ; local: G fue recompuesto este frame

        drawX := (this.bufferWidth - this.width) / 2
        drawY := (this.bufferHeight - this.height) / 2
        if (this.scale != 1.0 || this.rotation != 0) {
            if (this.scale < 0.01) {
                this.UpdateWindow(this.currentX, this.currentY, 0)
                return
            }
            Gdip_GraphicsClear(this.G, 0x00000000)
            ; Bilinear during transform: bicubic per frame slows down rotation
            Gdip_SetInterpolationMode(this.G, 6)
            Gdip_ResetWorldTransform(this.G)
            bufCX := this.bufferWidth / 2
            bufCY := this.bufferHeight / 2
            Gdip_TranslateWorldTransform(this.G, bufCX, bufCY, 0)
            if (this.rotation != 0)
                Gdip_RotateWorldTransform(this.G, this.rotation, 0)
            if (this.scale != 1.0)
                Gdip_ScaleWorldTransform(this.G, this.scale, this.scale, 0)
            Gdip_TranslateWorldTransform(this.G, -bufCX, -bufCY, 0)
            Gdip_SetClipRect(this.G, drawX, drawY, this.width, this.height, 0)
            Gdip_DrawImage(this.G, this.pBitmapCache, drawX, drawY, this.width, this.height, 0, 0, this.width, this.height)
            Gdip_ResetClip(this.G)
            Gdip_ResetWorldTransform(this.G)
            compositeDone := true
            this._compositeDirty := true
        } else if (this._compositeDirty) {
            Gdip_GraphicsClear(this.G, 0x00000000)
            Gdip_DrawImage(this.G, this.pBitmapCache, drawX, drawY, this.width, this.height, 0, 0, this.width, this.height)
            compositeDone := true
            this._compositeDirty := false
        }

        alpha := Floor(this.opacity * 255)
        x := this.currentX
        y := this.currentY

        if (compositeDone || alpha != this._lastAlpha || x != this._lastRenderX || y != this._lastRenderY) {
            this.UpdateWindow(x, y, alpha)
            this._lastRenderX := x
            this._lastRenderY := y
            this._lastAlpha := alpha
        }
    }

    UpdateWindow(x, y, alpha := -1) {
        if (alpha = -1) {
            alpha := Floor(this.opacity * 255)
            alpha := Max(0, Min(255, alpha))
        }
        if (!this.hwnd)
            return
        if (!DllCall("IsWindow", "ptr", this.hwnd))
            return
        if (!IsObject(this.gui))
            return
        w := this.bufferWidth
        h := this.bufferHeight
        ; ── compensate the offset when the buffer is larger than the toast ──
        offsetX := (this.bufferWidth - this.width) // 2
        offsetY := (this.bufferHeight - this.height) // 2
        wx := x - offsetX
        wy := y - offsetY
        if (!this._windowShown) {
            this._windowShown := true
            try
                this.gui.Show("NA")
            catch {
                this._windowShown := false
                return
            }
        }
        UpdateLayeredWindow(this.hwnd, this.hdc, wx, wy, w, h, alpha)
    }
    DrawIcon(x, y, size, iconType, pal) {
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
            default:
                glyphCode := Toast.__glyphCode(iconType)
                if (glyphCode != "") {
                    glyph := Chr(glyphCode)
                    Gdip_TextToGraphics(this.GCache, glyph,
                        "x" x " y" y " w" size " h" size " Center s" Round(size * 0.9) " c" Format("{:x}", pal.accent),
                        Toast.__iconFontName(), size * 0.9, size * 0.9)
                }
        }
    }
    static __iconFontName() {
        static name := ""
        if (name != "")
            return name
        name := "Segoe MDL2 Assets"
        try {
            v := RegRead("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts", "Segoe Fluent Icons (TrueType)")
            if (v != "")
                name := "Segoe Fluent Icons"
        }
        return name
    }
    static __glyphCode(name) {
        static g := ""
        if (g == "") {
            g := Object()
            for part in StrSplit("check E73E|accept E8FB|cross E711|error2 E783|info2 E946|star E734|starFill E735|heart EB51|heartFill EB52|like E8E1|dislike E8E0|flag E7C1|shield EA18|lock E72E|power E7E8|refresh E72C|sync E895|wifi E701|bluetooth E702|volume E767|mute EA85|play E768|pause E769|stop E71A|record E7C8|forward E72A|back E72B|chevronLeft E76B|chevronRight E76C|mail E715|send E724|reply E97A|message E8BD|phone E717|contact E77B|people E716|group E902|camera E722|webcam E8B8|picture E8B9|video E714|music EC4F|audio E8D6|microphone E720|search E721|home E80F|homeFill EA8A|folder E8B7|folderFill E8D5|save E74E|delete E74D|download E896|upload E898|copy E8C8|cut E8C6|paste E77F|edit E70F|rename E8AC|settings E713|filter E71C|add E710|remove E738|link E71B|globe E774|world E909|calendar E787|calendarFill EA89|clock E823|location E81D|mapPin2 E7B7|cloud E753|help E897|code E943|lightning E945|leaf E8BE|car E804|bus E806|walk E805|cart E7BF|package E7B8|pdf EA90|ringer EA8F|checkbox E739|list E8FD|fullscreen E740|print E749|attach E723|pin E718|shop E719|train E7C0|page E7C3|move E7C2|keyboard E765|chromeClose E8BB", "|") {
                kv := StrSplit(part, " ")
                g.%kv[1]% := Integer("0x" kv[2])
            }
        }
        return g.HasProp(name) ? g.%name% : ""
    }
    __ensureCloseBitmap() {
        if (this._closeBitmap)
            return
        d := this.dpiFactor
        this._closeW := 24 * d
        this._closeH := 24 * d
        this._closeBitmap := Gdip_CreateBitmap(this._closeW, this._closeH)
        if (!this._closeBitmap)
            return
        this._GClose := Gdip_GraphicsFromImage(this._closeBitmap)
        this.__applyRenderQuality(this._GClose, true)
        this._closeHoveredRendered := -1
    }
    __renderCloseBitmap(pal) {
        if (this._closeHoveredRendered == this.closeHovered)
            return
        this._closeHoveredRendered := this.closeHovered
        Gdip_GraphicsClear(this._GClose, 0x00000000)
        accent := pal.accent & 0xFFFFFF
        if (this.closeHovered) {
            circleCol := 0xFF000000 | accent
            glyphCol := this.__contrastOn(pal.accent) ? "ff0f172a" : "ffffffff"
        } else {
            circleCol := 0x40000000 | accent
            glyphCol := Format("{:x}", pal.fg)
        }
        circleBrush := Gdip_BrushCreateSolid(circleCol)
        Gdip_FillEllipse(this._GClose, circleBrush, 0, 0, this._closeW, this._closeH)
        Gdip_DeleteBrush(circleBrush)
        d := this.dpiFactor
        code := Toast.__glyphCode("chromeClose")
        if (code = "")
            code := Toast.__glyphCode("cross")
        glyph := Chr(code)
        s := 13 * d
        hFam := Gdip_FontFamilyCreate(Toast.__iconFontName())
        hFont := Gdip_FontCreate(hFam, s, 0)
        hFmt := Gdip_StringFormatCreate(0x1000)
        layout := Buffer(16)
        NumPut("float", 0, layout, 0)
        NumPut("float", 0, layout, 4)
        NumPut("float", 10000, layout, 8)
        NumPut("float", 10000, layout, 12)
        ms := Gdip_MeasureString(this._GClose, glyph, hFont, hFmt, &layout)
        p := StrSplit(ms, "|")
        gx := (this._closeW - p[3]) / 2 + 0.5 * d
        gy := (this._closeH - p[4]) / 2 + 1.0 * d
        Gdip_TextToGraphics(this._GClose, glyph, "x" gx " y" gy " c" glyphCol " s" s, Toast.__iconFontName(), this._closeW, this._closeH)
        Gdip_DeleteFontFamily(hFam)
        Gdip_DeleteFont(hFont)
        Gdip_DeleteStringFormat(hFmt)
    }
    __contrastOn(c) {
        r := (c >> 16) & 0xFF, g := (c >> 8) & 0xFF, b := c & 0xFF
        lr := r / 255, lg := g / 255, lb := b / 255
        lr := lr <= 0.03928 ? lr / 12.92 : ((lr + 0.055) / 1.055) ** 2.4
        lg := lg <= 0.03928 ? lg / 12.92 : ((lg + 0.055) / 1.055) ** 2.4
        lb := lb <= 0.03928 ? lb / 12.92 : ((lb + 0.055) / 1.055) ** 2.4
        return 0.2126 * lr + 0.7152 * lg + 0.0722 * lb > 0.4
    }
    __blitClose() {
        if (!this._closeBitmap)
            return
        d := this.dpiFactor
        closeSize := 20 * d
        closeX := this.width - this.paddingX - closeSize
        closeY := this.paddingY - 4 * d
        Gdip_DrawImage(this.GCache, this._closeBitmap, closeX - 2 * d, closeY - 2 * d
            , this._closeW, this._closeH, 0, 0, this._closeW, this._closeH)
    }
    __pushCloseRegion() {
        d := this.dpiFactor
        closeSize := 20 * d
        closeX := this.width - this.paddingX - closeSize
        closeY := this.paddingY - 4 * d
        this.clickRegions.Push({
            x: closeX, y: closeY, w: closeSize, h: closeSize,
            cb: (*) => this.ForceClose(),
            type: "close"
        })
    }
    __updateCloseHover() {
        if (!this.showClose || !this._closeBitmap)
            return
        pal := ToastTheme.palette(this.theme)
        this.__renderCloseBitmap(pal)
        this.__blitClose()
        this.cacheDirty := true
        this._compositeDirty := true
        this.Draw()
    }

    HasAnim(name) {
        for style in this.animStyle
            if (style == name)
                return true
        return false
    }
    InitAnimation() {
        this._hasSlide := this.HasAnim("slide")
        this._hasFade := this.HasAnim("fade")
        this._hasZoom := this.HasAnim("zoom")
        this._hasRotate := this.HasAnim("rotate")
        this.opacity := 1.0
        this.scale := 1.0
        ; this.rotation := 0.0
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
        if (this._hasFade)
            this.opacity := 0.0
        if (this._hasZoom)
            this.scale := 0.0
        if (this._hasRotate || this._hasZoom) {
            safetyFactor := 1.15
            diag := Sqrt(this.width ** 2 + this.height ** 2) * safetyFactor
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
        this.resolvedEntrance := this.animEntrance
        if (this.resolvedEntrance == "auto") {
            pos := this.position
            if (InStr(pos, "right") || pos == "right")
                this.resolvedEntrance := "right"
            else if (InStr(pos, "left") || pos == "left")
                this.resolvedEntrance := "left"
            else if (InStr(pos, "top") || pos == "top")
                this.resolvedEntrance := "top"
            else
                this.resolvedEntrance := "right"
        }

        wa := ToastDPI.WorkArea(this.targetX, this.targetY)
        ; offset del buffer expandido (ej: rotate agranda el buffer)
        offsetX := (this.bufferWidth - this.width) // 2
        offsetY := (this.bufferHeight - this.height) // 2

        switch this.resolvedEntrance {
            case "right":
                this.animStartX := wa.x + wa.w + 20 + offsetX
                this.animStartY := this.targetY
            case "left":
                this.animStartX := wa.x - this.width - 20 - offsetX
                this.animStartY := this.targetY
            case "top":
                this.animStartX := this.targetX
                this.animStartY := wa.y - this.height - 20 - offsetY
            case "bottom":
                this.animStartX := this.targetX
                this.animStartY := wa.y + wa.h + 20 + offsetY
            default:
                this.animStartX := wa.x + wa.w + 20 + offsetX
                this.animStartY := this.targetY
        }


        this.currentX := this.animStartX
        this.currentY := this.animStartY
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
        this.opacity := this._hasFade ? 0 : this._baseOpacity
        this.scale := this._hasZoom ? 0.5 : 1
        this.rotation := this._hasRotate ? this.rotationDegree : 0
        this.animState := "in"
        this.animStartTime := A_TickCount
        this._initialized := true
    }
    Tick() {
        now := A_TickCount

        ; ── 1) Repo animation: runs INDEPENDENT of the state ──
        ; Previously this returned here → SKIPPED progress in "visible" → freeze + jump.
        ; Now it only updates currentX/Y; the state code (in/out/visible) runs after.
        repoWasActive := this.repoActive
        if (repoWasActive) {
            elapsed := now - this.repoStartTime
            rp := Min(1.0, elapsed / Max(1, this.repoDuration))
            eased := ToastEasing.getEasing("easeOutCubic", rp)
            this.currentX := this.repoStartX + (this.repoTargetX - this.repoStartX) * eased
            this.currentY := this.repoStartY + (this.repoTargetY - this.repoStartY) * eased
            if (rp >= 1.0) {
                this.repoActive := false
                this.currentX := this.repoTargetX
                this.currentY := this.repoTargetY
            }
        }

        ; ── 2) Entrance animation ──
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
            this.opacity := this._hasFade ? (eased * this._baseOpacity) : this._baseOpacity
            this.scale := this._hasZoom ? (0.5 + 0.5 * eased) : 1.0
            this.rotation := this._hasRotate ? ((1 - eased) * this.rotationDegree * (this.resolvedEntrance == "left" ? -1 : 1)) : 0
            if (progress >= 1.0) {
                this.animState := "visible"
                this.currentX := this.targetX
                this.currentY := this.targetY
                this.opacity := this._baseOpacity
                this.scale := 1.0
                this.rotation := 0
                this.progressStartTime := now
                this.repoActive := false
                ; Expanded buffer (rotate/zoom) stays alive until Destroy:
                ; avoids realloc on entrance→visible and visible→exit (stutter).
            }
            this.Draw()
            return
        }

        ; ── 3) Exit animation ──
        if (this.animState == "out") {
            elapsed := now - this.animStartTime
            progress := Min(1.0, elapsed / Max(1, this.animDuration))
            eased := ToastEasing.getEasing(this.animEasing, progress)
            if (this._hasSlide) {
                this.currentX := this.exitStartX + (this.exitTargetX - this.exitStartX) * eased
                this.currentY := this.exitStartY + (this.exitTargetY - this.exitStartY) * eased
            }
            this.opacity := this._hasFade ? ((1.0 - eased) * this._baseOpacity) : this._baseOpacity
            this.scale := this._hasZoom ? (1.0 - 0.5 * eased) : 1.0
            this.rotation := this._hasRotate ? (eased * this.rotationDegree * (this.resolvedEntrance == "left" ? 1 : -1)) : 0
            this.Draw()
            return
        }

        ; ── 4) Visible state: progress + possible draw by repo ──
        if (this.animState == "visible") {
            drew := false

            ; ── Hover opacity: smoothly rises to 100% and back to _baseOpacity ──
            ; Direction is decided each tick by this.hovered; if it changes
            ; mid-transition, it restarts instantly (no waiting for the
            ; previous one to finish → no stutter on fast in/out).
            if (this.opacityOnHover) {
                target := this.hovered ? 1.0 : this._baseOpacity
                if (this._hoverOpacityActive) {
                    if (Abs(target - this._hoverOpacityTarget) > 0.001) {
                        this._hoverOpacityFrom := this.opacity
                        this._hoverOpacityTarget := target
                        this._hoverOpacityStart := now
                    }
                } else if (Abs(this.opacity - target) > 0.001) {
                    this._hoverOpacityFrom := this.opacity
                    this._hoverOpacityTarget := target
                    this._hoverOpacityStart := now
                    this._hoverOpacityActive := true
                }
                if (this._hoverOpacityActive) {
                    e := Min(1.0, (now - this._hoverOpacityStart) / this._hoverOpacityDur)
                    k := ToastEasing.getEasing("easeOutCubic", e)
                    this.opacity := this._hoverOpacityFrom + (this._hoverOpacityTarget - this._hoverOpacityFrom) * k
                    if (e >= 1.0) {
                        this._hoverOpacityActive := false
                        this.opacity := this._hoverOpacityTarget
                    }
                    this.Draw()
                    drew := true
                }
            }
            if (this.showProgress && this.duration > 0 && !this.progressPaused) {
                elapsed := now - this.progressStartTime
                this.progress := Min(1.0, elapsed / this.duration)
                diff := Abs(this.progress - this.lastProgress)
                if (diff > 0.005) {
                    this.lastProgress := this.progress
                    ; Solo se redibuja el overlay de la barra (no el cache completo)
                    this.__drawProgress()
                    this.Draw()
                    drew := true
                }
                if (this.progress >= 1.0) {
                    if (this.autoDismiss) {
                        if (!this.progressCompleteTime)
                            this.progressCompleteTime := now
                        else if (now - this.progressCompleteTime > Toast.progressGracePeriod)
                            this.StartExit()
                    }
                }
            }
            ; If the reposition just moved this tick, draw to reflect it.
            ; (If progress already triggered Draw, no need for another.)
            if (!drew && repoWasActive)
                this.Draw()
        }
    }
    StartExit() {
        if (this.animState == "out")
            return
        if ((this._hasRotate || this._hasZoom) && this.bufferWidth == this.width && this.bufferHeight == this.height) {
            safetyFactor := 1.15
            diag := Sqrt(this.width ** 2 + this.height ** 2) * safetyFactor
            this.ResizeBuffer(Ceil(diag), Ceil(diag))
        }
        wa := ToastDPI.WorkArea(this.currentX, this.currentY)
        offsetX := (this.bufferWidth - this.width) // 2
        offsetY := (this.bufferHeight - this.height) // 2

        this.exitStartX := this.currentX
        this.exitStartY := this.currentY

        switch this.resolvedEntrance {
            case "right":
                this.exitTargetX := wa.x + wa.w + 20 + offsetX
                this.exitTargetY := this.currentY
            case "left":
                this.exitTargetX := wa.x - this.width - 20 - offsetX
                this.exitTargetY := this.currentY
            case "top":
                this.exitTargetX := this.currentX
                this.exitTargetY := wa.y - this.height - 20 - offsetY
            case "bottom":
                this.exitTargetX := this.currentX
                this.exitTargetY := wa.y + wa.h + 20 + offsetY
            default:
                this.exitTargetX := wa.x + wa.w + 20 + offsetX
                this.exitTargetY := this.currentY
        }


        this.animState := "out"
        this.animStartTime := A_TickCount

        for i, t in Toastify.toasts
            if (t == this) {
                Toastify.toasts.RemoveAt(i)
                break
            }
        local found := false
        for t in Toastify.exitingToasts
            if (t == this) {
                found := true
                break
            }
        if (!found)
            Toastify.exitingToasts.Push(this)
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
        for r in this.clickRegions
            if (r.type = "close" && x >= r.x && x <= r.x + r.w && y >= r.y && y <= r.y + r.h) {
                this.closeHovered := true
                break
            }
        if (wasCloseHovered != this.closeHovered)
            this.__updateCloseHover()
        if (!wasHovered && Toastify.hoverPauseEnabled && this.autoDismiss && this.duration > 0) {
            this.progressPaused := true
            this.progressPauseTime := A_TickCount
        }
    }
    OnMouseLeave() {
        if (!this.hovered)
            return
        ; WM_MOUSELEAVE on layered windows is unreliable: it can fire
        ; with the cursor still inside the toast (e.g. UpdateLayeredWindow
        ; refreshes the window and the system emits a spurious leave). Check
        ; the real cursor position before clearing hover.
        pt := Buffer(8, 0)
        DllCall("GetCursorPos", "ptr", pt)
        mx := NumGet(pt, 0, "int")
        my := NumGet(pt, 4, "int")
        rx := mx - (this.currentX - (this.bufferWidth - this.width) // 2)
        ry := my - (this.currentY - (this.bufferHeight - this.height) // 2)
        if (rx >= 0 && rx <= this.width && ry >= 0 && ry <= this.height) {
            ; Cursor still INSIDE the toast → spurious leave, keep hover.
            ; The X only turns off when leaving the button's circular area.
            if (this.closeHovered) {
                d := this.dpiFactor
                cxx := this.width - this.paddingX - 20 * d + 10 * d
                cyy := this.paddingY - 4 * d + 10 * d
                cr := 10 * d
                dx := rx - cxx
                dy := ry - cyy
                if (dx * dx + dy * dy > cr * cr) {
                    this.closeHovered := false
                    this.__updateCloseHover()
                }
            }
            return
        }
        this.hovered := false
        this.closeHovered := false
        if (this.autoDismiss && this.duration > 0) {
            if (this.progressPaused) {
                this.progressPaused := false
                pausedDuration := A_TickCount - this.progressPauseTime
                this.progressStartTime += pausedDuration
                if (this.hwnd && Toastify.registry.Has(this.hwnd))
                    Toastify.registry[this.hwnd].duration += pausedDuration
            }
        } else
            this.progressPaused := false
        ; Hover opacity direction is handled by Tick() each frame.
        this.__updateCloseHover()   ; only redraws the X button halo
    }
    OnClick(x, y) {
        offsetX := (this.bufferWidth > this.width) ? (this.bufferWidth - this.width) / 2 : 0
        offsetY := (this.bufferHeight > this.height) ? (this.bufferHeight - this.height) / 2 : 0
        cx := x - offsetX
        cy := y - offsetY
        clickedRegion := false
        for r in this.clickRegions
            if (cx >= r.x && cx <= r.x + r.w && cy >= r.y && cy <= r.y + r.h) {
                clickedRegion := true
                if r.cb
                    try r.cb()
                if (r.type = "button")
                    this.StartExit()
                else if (r.type = "close")
                    this.ForceClose()
                break
            }
        if (!clickedRegion && this.onClickCallback) {
            try this.onClickCallback()
        }
    }
    Dismiss(instant := false) {
        if (!instant && this.animState != "out") {
            this.StartExit()
            return
        }
        for i, t in Toastify.exitingToasts
            if (t == this) {
                Toastify.exitingToasts.RemoveAt(i)
                break
            }
        for i, t in Toastify.toasts
            if (t == this) {
                Toastify.toasts.RemoveAt(i)
                break
            }
        if (this.hwnd && Toastify.registry.Has(this.hwnd))
            Toastify.registry.Delete(this.hwnd)
        this.Destroy()
        ; Every removal path (exit loop, watchdog, direct Dismiss) goes
        ; through here → the rest is always reordered.
        Toastify.__reflow(true)
    }
    ResizeBuffer(newW, newH) {
        if (newW == this.bufferWidth && newH == this.bufferHeight)
            return

        ; Release previous resources
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

        ; Create new buffer
        this.bufferWidth := newW
        this.bufferHeight := newH
        this.hbm := CreateDIBSection(newW, newH)
        this.hdc := CreateCompatibleDC()
        this.obm := SelectObject(this.hdc, this.hbm)
        this.G := Gdip_GraphicsFromHDC(this.hdc)
        this.__applyRenderQuality(this.G, false)
        this._compositeDirty := true
    }
    Destroy() {
        if (!this.hwnd)
            return
        if (this.GCache) {
            Gdip_DeleteGraphics(this.GCache)
            this.GCache := 0
        }
        if (this._GText) {
            Gdip_DeleteGraphics(this._GText)
            this._GText := 0
        }
        if (this.pBitmapCache) {
            Gdip_DisposeImage(this.pBitmapCache)
            this.pBitmapCache := 0
        }
        if (this._textBitmap) {
            Gdip_DisposeImage(this._textBitmap)
            this._textBitmap := 0
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

        ; Clear cached theme brushes/pens
        this.__deleteThemeCache()

        ; Clear progress overlay
        if (this._GProgress) {
            Gdip_DeleteGraphics(this._GProgress)
            this._GProgress := 0
        }
        if (this._progressBitmap) {
            Gdip_DisposeImage(this._progressBitmap)
            this._progressBitmap := 0
        }
        if (this._GClose) {
            Gdip_DeleteGraphics(this._GClose)
            this._GClose := 0
        }
        if (this._closeBitmap) {
            Gdip_DisposeImage(this._closeBitmap)
            this._closeBitmap := 0
        }
        hwnd := this.hwnd
        this.hwnd := 0
        this.gui := 0
        ; Break reference cycles (clickRegions closures capture this)
        this.clickRegions := []
        this._buttonClickRegions := []
        this.onClickCallback := 0
        this.onCloseCallback := 0
        this.actions := []
        Toastify.__destroyCount++
        if (DllCall("IsWindow", "ptr", hwnd))
            DllCall("DestroyWindow", "ptr", hwnd)
    }
}