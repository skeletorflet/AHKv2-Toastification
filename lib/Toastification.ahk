#Requires AutoHotkey v2.0
#Include AHKv2-Gdip\Gdip_All.ahk

; ============================================================================
; Toastification - Complete Toast Notification System with GDIP
; ============================================================================

; ToastTheme.__New()

; ============================================================================
; ToastEasing - Easing Functions for Smooth Animations
; ============================================================================
class ToastEasing {
    ; Linear (no easing)
    static linear(t) => t

    ; Quadratic easing
    static easeInQuad(t) => t * t
    static easeOutQuad(t) => t * (2 - t)
    static easeInOutQuad(t) => (t < 0.5) ? (2 * t * t) : (-1 + (4 - 2 * t) * t)

    ; Cubic easing
    static easeInCubic(t) => t * t * t
    static easeOutCubic(t) => (--t) * t * t + 1
    static easeInOutCubic(t) => (t < 0.5) ? (4 * t * t * t) : ((t - 1) * (2 * t - 2) * (2 * t - 2) + 1)

    ; Quartic easing
    static easeInQuart(t) => t * t * t * t
    static easeOutQuart(t) => 1 - (--t) * t * t * t
    static easeInOutQuart(t) => (t < 0.5) ? (8 * t * t * t * t) : (1 - 8 * (--t) * t * t * t)

    ; Back easing (overshoot)
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

    ; Bounce easing
    static bounce(t) {
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

    ; Get easing function by name and apply it to t
    static get(name, t) {
        if (name = "linear")
            return ToastEasing.linear(t)
        else if (name = "easeInQuad")
            return ToastEasing.easeInQuad(t)
        else if (name = "easeOutQuad")
            return ToastEasing.easeOutQuad(t)
        else if (name = "easeInOutQuad")
            return ToastEasing.easeInOutQuad(t)
        else if (name = "easeInCubic")
            return ToastEasing.easeInCubic(t)
        else if (name = "easeOutCubic")
            return ToastEasing.easeOutCubic(t)
        else if (name = "easeInOutCubic")
            return ToastEasing.easeInOutCubic(t)
        else if (name = "easeInQuart")
            return ToastEasing.easeInQuart(t)
        else if (name = "easeOutQuart")
            return ToastEasing.easeOutQuart(t)
        else if (name = "easeInOutQuart")
            return ToastEasing.easeInOutQuart(t)
        else if (name = "easeInBack")
            return ToastEasing.easeInBack(t)
        else if (name = "easeOutBack")
            return ToastEasing.easeOutBack(t)
        else if (name = "easeInOutBack")
            return ToastEasing.easeInOutBack(t)
        else if (name = "bounce" || name = "bounceOut")
            return ToastEasing.bounceOut(t)
        else if (name = "bounceIn")
            return ToastEasing.bounceIn(t)
        else if (name = "bounceInOut")
            return ToastEasing.bounceInOut(t)
        ; Sine
        else if (name = "easeInSine")
            return ToastEasing.easeInSine(t)
        else if (name = "easeOutSine")
            return ToastEasing.easeOutSine(t)
        else if (name = "easeInOutSine")
            return ToastEasing.easeInOutSine(t)
        ; Expo
        else if (name = "easeInExpo")
            return ToastEasing.easeInExpo(t)
        else if (name = "easeOutExpo")
            return ToastEasing.easeOutExpo(t)
        else if (name = "easeInOutExpo")
            return ToastEasing.easeInOutExpo(t)
        ; Circ
        else if (name = "easeInCirc")
            return ToastEasing.easeInCirc(t)
        else if (name = "easeOutCirc")
            return ToastEasing.easeOutCirc(t)
        else if (name = "easeInOutCirc")
            return ToastEasing.easeInOutCirc(t)
        ; Quint
        else if (name = "easeInQuint")
            return ToastEasing.easeInQuint(t)
        else if (name = "easeOutQuint")
            return ToastEasing.easeOutQuint(t)
        else if (name = "easeInOutQuint")
            return ToastEasing.easeInOutQuint(t)
        ; Elastic
        else if (name = "elasticIn")
            return ToastEasing.elasticIn(t)
        else if (name = "elasticOut")
            return ToastEasing.elasticOut(t)
        else if (name = "elasticInOut")
            return ToastEasing.elasticInOut(t)
        ; Flutter curves
        else if (name = "decelerate")
            return ToastEasing.decelerate(t)
        else if (name = "ease")
            return ToastEasing.ease(t)
        else if (name = "easeIn")
            return ToastEasing.easeIn(t)
        else if (name = "easeOut")
            return ToastEasing.easeOut(t)
        else if (name = "easeInOut")
            return ToastEasing.easeInOut(t)
        else if (name = "fastOutSlowIn" || name = "fastOutSlowIn")
            return ToastEasing.fastOutSlowIn(t)
        else if (name = "slowMiddle")
            return ToastEasing.slowMiddle(t)
        else if (name = "easeInToLinear")
            return ToastEasing.easeInToLinear(t)
        else if (name = "linearToEaseOut")
            return ToastEasing.linearToEaseOut(t)
        else if (name = "fastLinearToSlowEaseIn")
            return ToastEasing.fastLinearToSlowEaseIn(t)
        else if (name = "easeInOutCubicEmphasized")
            return ToastEasing.easeInOutCubicEmphasized(t)
        else
            return ToastEasing.easeOutCubic(t) ; Default fallback
    }

    ; === Quint Easing ===
    static easeInQuint(t) => t * t * t * t * t
    static easeOutQuint(t) => 1 + (--t) * t * t * t * t
    static easeInOutQuint(t) => (t < 0.5) ? (16 * t * t * t * t * t) : (1 + 16 * (--t) * t * t * t * t)

    ; === Sine Easing ===
    static easeInSine(t) => 1 - Cos((t * 3.14159265359) / 2)
    static easeOutSine(t) => Sin((t * 3.14159265359) / 2)
    static easeInOutSine(t) => -(Cos(3.14159265359 * t) - 1) / 2

    ; === Expo Easing ===
    static easeInExpo(t) => (t = 0) ? 0 : (2 ** (10 * t - 10))
    static easeOutExpo(t) => (t = 1) ? 1 : (1 - 2 ** (-10 * t))
    static easeInOutExpo(t) {
        if (t = 0)
            return 0
        if (t = 1)
            return 1
        return (t < 0.5) ? (2 ** (20 * t - 10)) / 2 : (2 - 2 ** (-20 * t + 10)) / 2
    }

    ; === Circ Easing ===
    static easeInCirc(t) => 1 - Sqrt(1 - (t ** 2))
    static easeOutCirc(t) => Sqrt(1 - ((t - 1) ** 2))
    static easeInOutCirc(t) => (t < 0.5)
        ? (1 - Sqrt(1 - (2 * t) ** 2)) / 2
        : (Sqrt(1 - (-2 * t + 2) ** 2) + 1) / 2

    ; === Elastic Easing ===
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

    ; === Bounce variants ===
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

    ; === Flutter Curves ===
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
        linearEnd := 0.5  ; 50% linear
        if (t < linearEnd)
            return t / linearEnd * 0.5  ; Map 0-0.5 to 0-0.5 linearly
        return 0.5 + ToastEasing.easeInCubic((t - linearEnd) / (1 - linearEnd)) / 2
    }
    static easeInOutCubicEmphasized(t) {
        ; Emphasized curve with more pronounced ease-in and ease-out
        c := 1.4
        if (t < 0.5)
            return (c * 4 * t * t * t)
        return 1 - (((-2 * t + 2) ** 3) * c) / 2
    }
}

; ============================================================================
; Toast Class - Individual Toast Instance
; ============================================================================

class Toastify {
    static pToken := 0
    static toasts := []
    static exitingToasts := [] ; New list for toasts that are animating out
    static marginX := 16
    static marginY := 16
    static spacing := 12
    static position := "top-right"  ; Deprecated, use alignment instead
    static alignment := "topright"  ; Where toasts accumulate: topleft, top, topright, centerleft, center, centerright, bottomleft, bottom, bottomright
    static stackDirection := "auto" ; How new toasts stack: top, bottom, left, right, center, auto
    static theme := "dark"
    static hoverPauseEnabled := true
    static maxToasts := 8 ; Maximum number of active toasts

    static __globalTimer := 0
    static __watchdogTimer := 0
    static __mouseTimer := 0
    static isShuttingDown := false
    static registry := Map() ; HWND -> {startTime, duration, instance}
    static config := ToastConfig()

    static SetConfig(cfg) {
        if (cfg.HasProp("fontName"))
            Toastify.config.fontName := cfg.fontName
        if (cfg.HasProp("fontSizeTitle"))
            Toastify.config.fontSizeTitle := cfg.fontSizeTitle
        if (cfg.HasProp("fontSizeBody"))
            Toastify.config.fontSizeBody := cfg.fontSizeBody
        if (cfg.HasProp("fontWeightTitle"))
            Toastify.config.fontWeightTitle := cfg.fontWeightTitle
        if (cfg.HasProp("width"))
            Toastify.config.width := cfg.width
        if (cfg.HasProp("borderRadius"))
            Toastify.config.borderRadius := cfg.borderRadius
        if (cfg.HasProp("iconSize"))
            Toastify.config.iconSize := cfg.iconSize
        if (cfg.HasProp("paddingX"))
            Toastify.config.paddingX := cfg.paddingX
        if (cfg.HasProp("paddingY"))
            Toastify.config.paddingY := cfg.paddingY
    }

    static RegisterTheme(name, palette) {
        ToastTheme.Register(name, palette)
    }

    static Start(theme := "dark", alignment := "topright", stackDirection := "auto") {
        if !Toastify.pToken {
            pt := Gdip_Startup()
            if !pt {
                MsgBox("GDI+ startup failed")
                return
            }
            Toastify.pToken := pt
            OnExit((*) => Toastify.Shutdown())
            OnMessage(0x201, (wParam, lParam, msg, hwnd) => Toastify.__Click(wParam, lParam, msg, hwnd))

            ; === HIGH PERFORMANCE MODE ===
            ; Set Windows multimedia timer resolution to 1ms for precise timing
            ; This dramatically improves SetTimer accuracy from ~15.6ms to 1ms
            DllCall("Winmm.dll\timeBeginPeriod", "UInt", 1)

            ; Increase process priority for better CPU scheduling
            ProcessSetPriority("High")

            ; Start Global Animation Loop with HIGH PRECISION
            ; Negative period (-16) = high priority, more precise execution
            ; Target: 60 FPS (1000ms / 60 = ~16.67ms)
            Toastify.__globalTimer := ObjBindMethod(Toastify, "__globalTick")
            SetTimer(Toastify.__globalTimer, -16) ; Negative = run once with high priority

            ; Start Watchdog (Fast failsafe for stuck toasts)
            Toastify.__watchdogTimer := ObjBindMethod(Toastify, "__watchdogTick")
            SetTimer(Toastify.__watchdogTimer, 200)  ; Check every 200ms (optimized from 100ms)

            ; Start Mouse Polling Timer for Hover Detection (More reliable than hook for layered windows)
            Toastify.__mouseTimer := ObjBindMethod(Toastify, "__mouseTimerTick")
            SetTimer(Toastify.__mouseTimer, 75)  ; Check every 75ms (optimized from 50ms)
        }
        Toastify.theme := theme

        ; Map old position values to new alignment for backward compatibility
        if (alignment == "top-right")
            alignment := "topright"
        else if (alignment == "top-left")
            alignment := "topleft"
        else if (alignment == "bottom-right")
            alignment := "bottomright"
        else if (alignment == "bottom-left")
            alignment := "bottomleft"

        Toastify.alignment := alignment
        Toastify.position := alignment  ; Keep for backward compatibility
        Toastify.stackDirection := stackDirection
    }

    static Shutdown(*) {
        Toastify.isShuttingDown := true
        if Toastify.__globalTimer
            SetTimer(Toastify.__globalTimer, 0)
        if Toastify.__watchdogTimer
            SetTimer(Toastify.__watchdogTimer, 0)
        if Toastify.__mouseTimer
            SetTimer(Toastify.__mouseTimer, 0)

        ; Stop old mouse hook if it exists
        ToastMouseHook.Stop()

        for t in Toastify.toasts {
            t.Destroy()
        }
        for t in Toastify.exitingToasts {
            t.Destroy()
        }

        ; Nuclear cleanup of any remaining registry items
        for hwnd, data in Toastify.registry {
            try DllCall("DestroyWindow", "ptr", hwnd)
        }
        Toastify.registry.Clear()
        Toastify.toasts := []
        Toastify.exitingToasts := []

        ; Restore default Windows timer resolution
        DllCall("Winmm.dll\timeEndPeriod", "UInt", 1)

        ; Restore normal process priority
        ProcessSetPriority("Normal")

        if Toastify.pToken {
            Gdip_Shutdown(Toastify.pToken)
            Toastify.pToken := 0
        }
        Toastify.isShuttingDown := false
    }

    ; ... (API Methods remain same) ...

    static __watchdogTick(*) {
        now := A_TickCount
        for hwnd, data in Toastify.registry.Clone() {
            ; Check if window still exists
            if (!DllCall("IsWindow", "ptr", hwnd)) {
                Toastify.registry.Delete(hwnd)
                continue
            }

            ; Get toast instance for checks
            t := (data.HasOwnProp("instance") && data.instance) ? data.instance : 0

            ; Skip watchdog checks if toast is currently paused due to hover
            if (t && t.hovered && t.progressPaused && Toastify.hoverPauseEnabled) {
                continue  ; Don't check lifetime while user is hovering
            }

            ; Check lifespan - Must account for entrance animation + progress duration + exit animation
            ; The toast should live for: animDuration (in) + duration (progress) + animDuration (out) + grace
            if (data.duration > 0 && t) {
                ; Calculate expected lifetime: entrance anim + progress bar duration + small grace period
                expectedLifetime := t.animDuration + data.duration + 500  ; 500ms grace for completion
                actualLifetime := now - data.startTime

                if (actualLifetime > expectedLifetime) {
                    if (t.HasProp("animState") && t.animState == "out") {
                        ; Already exiting. Let __globalTick handle the animation and cleanup.
                        ; Force kill if stuck longer than expected exit duration + 500ms
                        if (actualLifetime > expectedLifetime + t.animDuration + 500) {
                            try DllCall("DestroyWindow", "ptr", hwnd)
                            if (Toastify.registry.Has(hwnd))
                                Toastify.registry.Delete(hwnd)
                        }
                    } else {
                        ; Progress bar should have finished. Trigger graceful exit.
                        t.StartExit()
                    }
                }
            } else if (data.duration > 0 && !t) {
                ; No instance found, or just a raw window. Kill it if overdue.
                if (now - data.startTime > data.duration + 1000) {
                    try DllCall("DestroyWindow", "ptr", hwnd)
                    if (Toastify.registry.Has(hwnd))
                        Toastify.registry.Delete(hwnd)
                }
            }
        }
    }
    ; === Simple API Methods ===

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
        t := Toastify.__createToast("", "", [], opts)
        t.view := viewItems
        t.Draw()
        t.animState := "in" ; Set initial state for global tick
        t.animStartTime := A_TickCount
        Toastify.toasts.Push(t)
        Toastify.__reflow(false)
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

        ; Ensure defaults for properties managed by Toastify class
        if !opts.HasProp("theme")
            opts.theme := Toastify.theme
        if !opts.HasProp("alignment")
            opts.alignment := Toastify.alignment
        if !opts.HasProp("stackDirection")
            opts.stackDirection := Toastify.stackDirection

        ; Also set position for backward compatibility
        if !opts.HasProp("position")
            opts.position := opts.alignment

        t := Toast(title, body, actions, opts)

        alignment := t.HasProp("alignment") ? t.alignment : Toastify.alignment
        stackDir := t.HasProp("stackDirection") ? t.stackDirection : Toastify.stackDirection
        if (stackDir == "auto") {
            if (alignment == "topleft" || alignment == "top" || alignment == "topright")
                stackDir := "bottom"
            else if (alignment == "bottomleft" || alignment == "bottom" || alignment == "bottomright")
                stackDir := "top"
            else if (alignment == "centerleft")
                stackDir := "right"
            else if (alignment == "centerright")
                stackDir := "left"
            else
                stackDir := "bottom"
        }

        if (stackDir == "top" || stackDir == "bottom") {
            capacity := Max(1, Floor((A_ScreenHeight - 2 * Toastify.marginY + Toastify.spacing) / (t.height + Toastify.spacing
            )))
        } else {
            capacity := Max(1, Floor((A_ScreenWidth - 2 * Toastify.marginX + Toastify.spacing) / (t.width + Toastify.spacing
            )))
        }

        count := 0
        for i, prevToast in Toastify.toasts {
            prevAlignment := prevToast.HasProp("alignment") ? prevToast.alignment : Toastify.alignment
            if (prevAlignment == alignment)
                count++
        }
        removals := Max(0, (count + 1) - capacity)
        if (removals > 0) {
            for i, prevToast in Toastify.toasts.Clone() {
                if (removals <= 0)
                    break
                prevAlignment := prevToast.HasProp("alignment") ? prevToast.alignment : Toastify.alignment
                if (prevAlignment == alignment) {
                    prevToast.StartExit()
                    removals--
                }
            }
        }

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

        ; Process each toast (they might have different alignments)
        for idx, t in Toastify.toasts {
            ; Get toast-specific alignment or use global default
            alignment := t.HasProp("alignment") ? t.alignment : Toastify.alignment
            stackDir := t.HasProp("stackDirection") ? t.stackDirection : Toastify.stackDirection

            ; Auto-detect stack direction based on alignment
            if (stackDir == "auto") {
                if (alignment == "topleft" || alignment == "top" || alignment == "topright")
                    stackDir := "bottom"  ; Top alignments stack downward
                else if (alignment == "bottomleft" || alignment == "bottom" || alignment == "bottomright")
                    stackDir := "top"     ; Bottom alignments stack upward
                else if (alignment == "centerleft")
                    stackDir := "right"   ; Center-left stacks rightward
                else if (alignment == "centerright")
                    stackDir := "left"    ; Center-right stacks leftward
                else  ; center
                    stackDir := "bottom"  ; Center stacks downward
            }

            ; Calculate base anchor position for this alignment
            anchorX := 0, anchorY := 0

            switch alignment {
                case "topleft":
                    anchorX := Toastify.marginX
                    anchorY := Toastify.marginY

                case "top":
                    anchorX := (A_ScreenWidth - t.width) / 2
                    anchorY := Toastify.marginY

                case "topright":
                    anchorX := A_ScreenWidth - Toastify.marginX - t.width
                    anchorY := Toastify.marginY

                case "centerleft":
                    anchorX := Toastify.marginX
                    anchorY := (A_ScreenHeight - t.height) / 2

                case "center":
                    anchorX := (A_ScreenWidth - t.width) / 2
                    anchorY := (A_ScreenHeight - t.height) / 2

                case "centerright":
                    anchorX := A_ScreenWidth - Toastify.marginX - t.width
                    anchorY := (A_ScreenHeight - t.height) / 2

                case "bottomleft":
                    anchorX := Toastify.marginX
                    anchorY := A_ScreenHeight - Toastify.marginY - t.height

                case "bottom":
                    anchorX := (A_ScreenWidth - t.width) / 2
                    anchorY := A_ScreenHeight - Toastify.marginY - t.height

                case "bottomright":
                    anchorX := A_ScreenWidth - Toastify.marginX - t.width
                    anchorY := A_ScreenHeight - Toastify.marginY - t.height
            }

            ; Calculate stack offset based on index and stack direction
            ; We need to count how many toasts with the same alignment come before this one
            stackIndex := 0
            for i, prevToast in Toastify.toasts {
                if (i >= idx)
                    break
                prevAlignment := prevToast.HasProp("alignment") ? prevToast.alignment : Toastify.alignment
                if (prevAlignment == alignment)
                    stackIndex++
            }

            offsetX := 0, offsetY := 0

            switch stackDir {
                case "top":
                    offsetY := -stackIndex * (t.height + Toastify.spacing)

                case "bottom":
                    offsetY := stackIndex * (t.height + Toastify.spacing)

                case "left":
                    offsetX := -stackIndex * (t.width + Toastify.spacing)

                case "right":
                    offsetX := stackIndex * (t.width + Toastify.spacing)

                case "center":
                    ; Subtle offset to show layering
                    offsetX := stackIndex * 2
                    offsetY := stackIndex * 2
            }

            ; Final position
            t.targetX := anchorX + offsetX
            t.targetY := anchorY + offsetY

            if (!animate) {
                t.currentX := t.targetX
                t.currentY := t.targetY
                if (t.hwnd)
                    t.UpdateWindow(t.targetX, t.targetY)
            }
        }
    }

    static __globalTick(*) {
        if (Toastify.isShuttingDown || Toastify.pToken = 0)
            return
        ; === HIGH PERFORMANCE: Self-restart for precise timing ===
        ; Restart timer immediately for next frame (negative period = high priority)
        SetTimer(Toastify.__globalTimer, -16)

        ; --- FAIL-SAFE 1: Enforce Max Toasts (Redundant check) ---
        while (Toastify.toasts.Length > Toastify.maxToasts) {
            if (Toastify.toasts.Length > 0) {
                t := Toastify.toasts[1]
                t.StartExit()
                ; Force remove if StartExit failed to remove it from the list for some reason
                if (Toastify.toasts.Length > 0 && Toastify.toasts[1] == t) {
                    Toastify.toasts.RemoveAt(1)
                    Toastify.exitingToasts.Push(t) ; Ensure it goes to exiting
                }
            } else {
                break
            }
        }

        ; Process Active Toasts
        for t in Toastify.toasts.Clone() {
            ; --- FAIL-SAFE 2: Leaked "Out" Toasts ---
            ; If a toast in the active list is marked as "out", it shouldn't be here.
            if (t.animState == "out") {
                t.StartExit() ; This will move it to exitingToasts
                continue
            }
            t.Tick()
        }

        ; Process Exiting Toasts
        for t in Toastify.exitingToasts.Clone() {
            t.Tick()

            ; --- FAIL-SAFE 3: Stuck Exit Timeout ---
            ; Force dismiss if stuck in exit state too long (immediately after expected duration)
            if (t.animState == "out" && (A_TickCount - t.animStartTime > t.animDuration)) {
                t.Dismiss()
            }
        }
    }

    static __mouseTimerTick(*) {
        if (Toastify.isShuttingDown || Toastify.pToken = 0)
            return
        ; === PERFORMANCE: Early exit if no toasts to check ===
        if (Toastify.toasts.Length == 0 && Toastify.exitingToasts.Length == 0)
            return

        ; Poll mouse position and check against all toasts
        MouseGetPos(&x, &y)

        ; Check Active Toasts
        for t in Toastify.toasts.Clone() {
            if (!t.hwnd)
                continue

            ; Check if mouse is within toast screen bounds
            wasInside := t.hovered
            isInside := (x >= t.currentX && x <= t.currentX + t.width && y >= t.currentY && y <= t.currentY + t.height)

            if (isInside && !wasInside) {
                ; Mouse entered
                relX := x - t.currentX
                relY := y - t.currentY
                t.OnMouseMove(relX, relY)
            } else if (!isInside && wasInside) {
                ; Mouse left
                t.OnMouseLeave()
            } else if (isInside) {
                ; Mouse moved inside (update close button hover state)
                relX := x - t.currentX
                relY := y - t.currentY
                t.OnMouseMove(relX, relY)
            }
        }

        ; Check Exiting Toasts too
        for t in Toastify.exitingToasts.Clone() {
            if (!t.hwnd)
                continue

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
    }

    static __mouseMoveHook(x, y, prevX, prevY) {
        ; Check Active Toasts
        ; Use Clone() to avoid issues if array changes during iteration
        for t in Toastify.toasts.Clone() {
            if (!t.hwnd)
                continue

            ; Check if mouse is within toast screen bounds
            wasInside := t.hovered
            isInside := (x >= t.currentX && x <= t.currentX + t.width && y >= t.currentY && y <= t.currentY + t.height)

            if (isInside && !wasInside) {
                ; Mouse entered
                relX := x - t.currentX
                relY := y - t.currentY
                t.OnMouseMove(relX, relY)
            } else if (!isInside && wasInside) {
                ; Mouse left
                t.OnMouseLeave()
            } else if (isInside) {
                ; Mouse moved inside
                relX := x - t.currentX
                relY := y - t.currentY
                t.OnMouseMove(relX, relY)
            }
        }
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

    ; Removed __MouseMove as we use the hook now
}

; Embedded OnMouseMove Class
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

    static __New() {
        ; Initialize default themes with MODERN FLAT UI COLORS

        ; === BASE THEMES ===
        ToastTheme.Register("light", {
            bg1: 0xFFFFFFFF, bg2: 0xFFF8F9FA,
            fg: 0xFF1F2937, accent: 0xFF3B82F6,
            shadow: 0x44000000, progress: 0xFF3B82F6
        })
        ToastTheme.Register("dark", {
            bg1: 0xEE1F2937, bg2: 0xEE111827,
            fg: 0xFFF9FAFB, accent: 0xFF60A5FA,
            shadow: 0x66000000, progress: 0xFF60A5FA
        })

        ; === DARK VARIANTS (Subtle, Dark Backgrounds) ===
        ToastTheme.Register("success", {
            bg1: 0xEE1C2B23, bg2: 0xEE14191A,
            fg: 0xFFFFFFFF, accent: 0xFF34D399,
            shadow: 0x66000000, progress: 0xFF10B981
        })
        ToastTheme.Register("error", {
            bg1: 0xEE2D1B1E, bg2: 0xEE1A1315,
            fg: 0xFFFFFFFF, accent: 0xFFF87171,
            shadow: 0x66000000, progress: 0xFFEF4444
        })
        ToastTheme.Register("warning", {
            bg1: 0xEE2D1F1E, bg2: 0xEE1C1315,
            fg: 0xFFFFFFFF, accent: 0xFFFCD34D,
            shadow: 0x66000000, progress: 0xFFFBBF24
        })
        ToastTheme.Register("info", {
            bg1: 0xEE1E2B3D, bg2: 0xEE14191F,
            fg: 0xFFFFFFFF, accent: 0xFF93C5FD,
            shadow: 0x66000000, progress: 0xFF60A5FA
        })

        ; === LIGHT VARIANTS (Clean, Near-White Backgrounds) ===
        ToastTheme.Register("success-light", {
            bg1: 0xFFFAFDFB, bg2: 0xFFF0FDF4,
            fg: 0xFF065F46, accent: 0xFF059669,
            shadow: 0x22000000, progress: 0xFF10B981
        })
        ToastTheme.Register("error-light", {
            bg1: 0xFFFEFDFD, bg2: 0xFFFEF2F2,
            fg: 0xFF991B1B, accent: 0xFFDC2626,
            shadow: 0x22000000, progress: 0xFFEF4444
        })
        ToastTheme.Register("warning-light", {
            bg1: 0xFFFEFDFD, bg2: 0xFFFEF3F2,
            fg: 0xFF991B1B, accent: 0xFFDC2626,
            shadow: 0x22000000, progress: 0xFFEF4444
        })
        ToastTheme.Register("info-light", {
            bg1: 0xFFFDFDFE, bg2: 0xFFF0F5FF,
            fg: 0xFF1E40AF, accent: 0xFF2563EB,
            shadow: 0x22000000, progress: 0xFF3B82F6
        })
        ToastTheme.Register("neon-light", {
            bg1: 0xFFFDFCFE, bg2: 0xFFF5F3FF,
            fg: 0xFF6B21A8, accent: 0xFF9333EA,
            shadow: 0x22000000, progress: 0xFFA855F7
        })

        ; === NEW THEMES ===

        ; NEON (Cyberpunk/High Contrast)
        ToastTheme.Register("neon", {
            bg1: 0xEE0F0518, bg2: 0xEE1A0B2E,
            fg: 0xFFE9D5FF, accent: 0xFFD946EF,
            shadow: 0x88D946EF, progress: 0xFFC026D3
        })

        ; VAPOR (Retrowave/Synthwave)
        ToastTheme.Register("vapor", {
            bg1: 0xEE240046, bg2: 0xEE10002B,
            fg: 0xFFE0AAFF, accent: 0xFF00FFFF,
            shadow: 0x6600FFFF, progress: 0xFF9D4EDD
        })
        ToastTheme.Register("vapor-light", {
            bg1: 0xFFFFF0F5, bg2: 0xFFE0F7FA,
            fg: 0xFF5D3FD3, accent: 0xFF00CED1,
            shadow: 0x2200CED1, progress: 0xFFDA70D6
        })

        ; PASTEL (Soft/Gentle)
        ToastTheme.Register("pastel", {
            bg1: 0xEE2D2D2D, bg2: 0xEE252525,
            fg: 0xFFFFD1DC, accent: 0xFFAEC6CF,
            shadow: 0x44000000, progress: 0xFFB39EB5
        })
        ToastTheme.Register("pastel-light", {
            bg1: 0xFFFFFDF5, bg2: 0xFFFDF5E6,
            fg: 0xFF6B5B95, accent: 0xFFFFB347,
            shadow: 0x22000000, progress: 0xFFFF6961
        })

        ; FLAT (Solid/No Gradient)
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

        ; CYBERPUNK (High Tech)
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

        ; RETRO (Terminal/Sepia)
        ToastTheme.Register("retro", {
            bg1: 0xEE000000, bg2: 0xEE000000,
            fg: 0xFF33FF00, accent: 0xFF33FF00,
            shadow: 0x00000000, progress: 0xFF33FF00
        })
        ToastTheme.Register("retro-light", {
            bg1: 0xFFF4E4BC, bg2: 0xFFE6D6AC,
            fg: 0xFF4B3621, accent: 0xFF6F4E37,
            shadow: 0x224B3621, progress: 0xFF8B4513
        })

        ; GLASS (Translucent)
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

        ; MINIMAL (High Contrast B&W)
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

        ; MIDNIGHT (Deep Blue)
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

        ; FOREST (Nature)
        ToastTheme.Register("forest", {
            bg1: 0xEE052e16, bg2: 0xEE064e3b,
            fg: 0xFFD1FAE5, accent: 0xFF34D399,
            shadow: 0x66064e3b, progress: 0xFF10B981
        })
        ToastTheme.Register("forest-light", {
            bg1: 0xFFECFDF5, bg2: 0xFFD1FAE5,
            fg: 0xFF065F46, accent: 0xFF059669,
            shadow: 0x22065F46, progress: 0xFF10B981
        })
    }

    static Register(name, palette) {
        ToastTheme.themes[name] := palette
    }

    static palette(theme) {
        if (ToastTheme.themes.Has(theme))
            return ToastTheme.themes[theme]
        return ToastTheme.themes["dark"]
    }
}

class ToastConfig {
    fontName := "Segoe UI Emoji"  ; Changed to support emoji rendering
    fontSizeTitle := 16
    fontSizeBody := 13  ; Increased from 11 for better readability
    fontWeightTitle := "Bold"
    fontWeightBody := "Normal"

    width := 340
    minHeight := 120
    paddingX := 16
    paddingY := 14
    iconSize := 32
    borderRadius := 18

    ; Animation settings
    animDuration := 300  ; Animation duration in milliseconds
    animEasing := "easeOutCubic"  ; Default easing curve
    animStyle := "slide" ; slide, fade, zoom, slide+fade, zoom+fade
    animEntrance := "auto" ; auto, right, left, top, bottom

    ; Graphics Quality
    renderQuality := "Medium" ; Low, Medium, High - Medium provides best performance/quality balance

    ; Hover Effects
    hoverStyle := [] ; ["zoom", "brightness", "rotate"]
    hoverScale := 1.05
    hoverRotation := 2.0
    hoverOpacity := 1.0
    hoverBrightness := 0.15 ; 0.0 to 1.0 (white overlay opacity)
}

; Initialize themes on load
ToastTheme.__New()

class Toast {
    title := ""
    body := ""
    actions := []
    width := 340
    height := 120
    duration := 3000
    theme := "dark"
    position := "top-right"  ; Deprecated, use alignment
    alignment := "topright"  ; Where this toast appears
    stackDirection := "auto" ; How this toast stacks with others
    icon := ""
    showClose := true
    showProgress := true
    hwnd := 0
    gui := 0
    hbm := 0
    hdc := 0
    obm := 0
    G := 0

    ; Rendering Cache
    pBitmapCache := 0
    GCache := 0
    cacheDirty := true

    ; Position State
    targetX := 0
    targetY := 0
    currentX := 0
    currentY := 0

    ; Animation State
    animState := "idle" ; idle, in, out
    animStartTime := 0
    animDuration := 300 ; ms (will be overridden from config)
    animEasing := "easeOutCubic"
    animStyle := ["fade"] ; Default to fade, as array
    animEntrance := "auto"

    ; Animation Properties
    opacity := 1.0
    scale := 1.0
    rotation := 0.0

    ; Buffer State
    bufferWidth := 0
    bufferHeight := 0

    ; Progress State
    progress := 0.0
    progressStartTime := 0
    progressPaused := false
    progressPauseTime := 0
    lastProgress := 0.0 ; For redraw optimization
    lastProgressDrawTime := 0 ; Timestamp of last progress bar redraw

    ; Watchdog
    creationTime := 0 ; Track creation time for watchdog

    ; Interaction State
    clickRegions := []
    hovered := false
    closeHovered := false
    onClickCallback := 0
    onCloseCallback := 0
    userInitiatedExit := false

    ; Dismissal Behavior
    autoDismiss := true

    ; Configurable Properties
    fontName := "Segoe UI"
    fontSizeTitle := 16
    fontSizeBody := 11
    fontWeightTitle := "Bold"
    fontWeightBody := "Normal"
    paddingX := 16
    paddingY := 14
    iconSize := 32
    borderRadius := 18
    renderQuality := "High" ; Default

    ; Hover Configuration
    hoverStyle := []
    hoverScale := 1.05
    hoverRotation := 2.0
    hoverOpacity := 1.0
    hoverBrightness := 0.15

    ; Hover State
    currentBrightness := 0.0

    ; Close Button Animation State
    closeBtnScale := 1.0
    closeBtnRotation := 0.0
    closeBtnAlpha := 170 ; 0xAA

    ; Performance Tracking
    lastDrawTime := 0
    lastHoverUpdate := 0

    __New(title, body, actions, opts) {
        this.title := title
        this.body := body
        this.actions := actions

        ; Defaults from Global Config
        cfg := Toastify.config
        this.width := cfg.width
        this.fontName := cfg.fontName
        this.fontSizeTitle := cfg.fontSizeTitle
        this.fontSizeBody := cfg.fontSizeBody
        this.fontWeightTitle := cfg.fontWeightTitle
        this.fontWeightBody := cfg.fontWeightBody
        this.paddingX := cfg.paddingX
        this.paddingY := cfg.paddingY
        this.iconSize := cfg.iconSize
        this.borderRadius := cfg.borderRadius
        this.animDuration := cfg.animDuration
        this.animEasing := cfg.animEasing
        this.animStyle := cfg.animStyle
        this.animEntrance := cfg.animEntrance
        this.renderQuality := cfg.renderQuality

        ; Overrides from Options
        if (opts) {
            if (opts.HasProp("width"))
                this.width := opts.width
            if (opts.HasProp("duration"))
                this.duration := opts.duration
            if (opts.HasProp("theme"))
                this.theme := opts.theme
            if (opts.HasProp("alignment"))
                this.alignment := opts.alignment
            if (opts.HasProp("stackDirection"))
                this.stackDirection := opts.stackDirection
            if (opts.HasProp("position")) {
                ; Map old position to alignment for backward compatibility
                if (opts.position == "top-right")
                    this.alignment := "topright"
                else if (opts.position == "top-left")
                    this.alignment := "topleft"
                else if (opts.position == "bottom-right")
                    this.alignment := "bottomright"
                else if (opts.position == "bottom-left")
                    this.alignment := "bottomleft"
                else
                    this.alignment := opts.position
            }
            this.position := this.alignment  ; Keep in sync
            if (opts.HasProp("icon"))
                this.icon := opts.icon
            if (opts.HasProp("showClose"))
                this.showClose := opts.showClose
            if (opts.HasProp("showProgress"))
                this.showProgress := opts.showProgress
            if (opts.HasProp("onClick"))
                this.onClickCallback := opts.onClick
            if (opts.HasProp("onClose"))
                this.onCloseCallback := opts.onClose

            ; Style Overrides
            if (opts.HasProp("fontName"))
                this.fontName := opts.fontName
            if (opts.HasProp("fontSizeTitle"))
                this.fontSizeTitle := opts.fontSizeTitle
            if (opts.HasProp("fontSizeBody"))
                this.fontSizeBody := opts.fontSizeBody
            if (opts.HasProp("fontWeightTitle"))
                this.fontWeightTitle := opts.fontWeightTitle
            if (opts.HasProp("fontWeightBody"))
                this.fontWeightBody := opts.fontWeightBody
            if (opts.HasProp("paddingX"))
                this.paddingX := opts.paddingX
            if (opts.HasProp("paddingY"))
                this.paddingY := opts.paddingY
            if (opts.HasProp("iconSize"))
                this.iconSize := opts.iconSize
            if (opts.HasProp("borderRadius"))
                this.borderRadius := opts.borderRadius
            if (opts.HasProp("animDuration"))
                this.animDuration := opts.animDuration
            if (opts.HasProp("renderQuality"))
                this.renderQuality := opts.renderQuality
            ; showProgress is already set in lines 912-913 above, no need to override here
            this.progressPaused := false

            this.animStyle := opts.HasProp("animStyle") ? opts.animStyle : Toastify.config.animStyle
            ; Ensure animStyle is an array
            if (!HasProp(this.animStyle, "Length") && Type(this.animStyle) == "String") {
                this.animStyle := [this.animStyle]
            } else if (!HasProp(this.animStyle, "Length")) {
                this.animStyle := ["fade"] ; Fallback
            }

            this.animEasing := opts.HasProp("animEasing") ? opts.animEasing : Toastify.config.animEasing
            this.animEntrance := opts.HasProp("animEntrance") ? opts.animEntrance : Toastify.config.animEntrance

            ; Permanent / AutoDismiss options
            if (opts.HasProp("autoDismiss"))
                this.autoDismiss := !!opts.autoDismiss
            if (opts.HasProp("permanent") && !!opts.permanent) {
                this.autoDismiss := false
                if (!opts.HasProp("duration"))
                    this.duration := 0
                if (!opts.HasProp("showProgress"))
                    this.showProgress := false
            }

            ; Hover Options
            this.hoverStyle := opts.HasProp("hoverStyle") ? opts.hoverStyle : Toastify.config.hoverStyle
            if (Type(this.hoverStyle) == "String")
                this.hoverStyle := [this.hoverStyle]

            this.hoverScale := opts.HasProp("hoverScale") ? opts.hoverScale : Toastify.config.hoverScale
            this.hoverRotation := opts.HasProp("hoverRotation") ? opts.hoverRotation : Toastify.config.hoverRotation
            this.hoverOpacity := opts.HasProp("hoverOpacity") ? opts.hoverOpacity : Toastify.config.hoverOpacity
            this.hoverBrightness := opts.HasProp("hoverBrightness") ? opts.hoverBrightness : Toastify.config.hoverBrightness
        }

        ; Initialize Animation State BEFORE first Draw to avoid flash
        this.creationTime := A_TickCount ; Track creation for watchdog
        this.InitAnimation()

        this.__createWindow()
        this.Draw()
        this.AnimateIn()
    }

    __createWindow() {
        this.gui := Gui("-Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs")
        this.gui.Show("NA")
        this.hwnd := this.gui.Hwnd

        ; Ensure topmost z-order above other topmost windows
        DllCall("user32\SetWindowPos", "ptr", this.hwnd, "ptr", -1, "int", 0, "int", 0, "int", 0, "int", 0,
            "uint", 0x0001 | 0x0002 | 0x0010 | 0x0040)

        ; === CALCULATE BUFFER SIZE ===
        ; Determine maximum required size to avoid clipping during zoom/rotate
        maxScale := 1.0

        ; Check Hover Zoom
        hasHoverZoom := false
        for style in this.hoverStyle {
            if (style == "zoom") {
                hasHoverZoom := true
                break
            }
        }
        if (hasHoverZoom)
            maxScale := Max(maxScale, this.hoverScale)

        ; Check Rotation (Anim or Hover)
        hasRotation := this.HasAnim("rotate")
        if (!hasRotation) {
            for style in this.hoverStyle {
                if (style == "rotate") {
                    hasRotation := true
                    break
                }
            }
        }

        reqW := this.width * maxScale
        reqH := this.height * maxScale

        if (hasRotation) {
            ; If rotation is involved, we need the diagonal size to be safe
            diag := Sqrt(reqW ** 2 + reqH ** 2)
            this.bufferWidth := Ceil(diag)
            this.bufferHeight := Ceil(diag)
        } else {
            this.bufferWidth := Ceil(reqW)
            this.bufferHeight := Ceil(reqH)
        }

        ; Add a little padding for anti-aliasing edges
        this.bufferWidth += 4
        this.bufferHeight += 4

        ; Window DC (Destination)
        this.hbm := CreateDIBSection(this.bufferWidth, this.bufferHeight)
        this.hdc := CreateCompatibleDC()
        this.obm := SelectObject(this.hdc, this.hbm)
        this.G := Gdip_GraphicsFromHDC(this.hdc)
        Gdip_SetSmoothingMode(this.G, 4)

        ; Create Cache Bitmap (Always original size)
        ; Create Cache Bitmap (Always original size)
        this.pBitmapCache := Gdip_CreateBitmap(this.width, this.height)
        this.GCache := Gdip_GraphicsFromImage(this.pBitmapCache)

        ; === QUALITY SETTINGS ===
        if (this.renderQuality = "Low") {
            ; Low Quality (Max Performance)
            Gdip_SetSmoothingMode(this.GCache, 1) ; HighSpeed
            Gdip_SetTextRenderingHint(this.GCache, 3) ; SingleBitPerPixelGridFit
            DllCall("gdiplus\GdipSetPixelOffsetMode", "ptr", this.GCache, "int", 1) ; HighSpeed
            DllCall("gdiplus\GdipSetCompositingQuality", "ptr", this.GCache, "int", 1) ; HighSpeed
        } else if (this.renderQuality = "Medium") {
            ; Medium Quality (Balanced)
            Gdip_SetSmoothingMode(this.GCache, 4) ; AntiAlias
            Gdip_SetTextRenderingHint(this.GCache, 4) ; AntiAlias
            DllCall("gdiplus\GdipSetPixelOffsetMode", "ptr", this.GCache, "int", 2) ; HighQuality
            DllCall("gdiplus\GdipSetCompositingQuality", "ptr", this.GCache, "int", 2) ; HighQuality
        } else {
            ; High Quality (Best Visuals) - Default
            Gdip_SetSmoothingMode(this.GCache, 4) ; AntiAlias
            Gdip_SetTextRenderingHint(this.GCache, 5) ; ClearTypeGridFit (Sharpest text)
            DllCall("gdiplus\GdipSetPixelOffsetMode", "ptr", this.GCache, "int", 2) ; HighQuality
            DllCall("gdiplus\GdipSetCompositingQuality", "ptr", this.GCache, "int", 2) ; HighQuality
        }

        ; Register toast in global registry for watchdog monitoring
        Toastify.registry[this.hwnd] := {
            startTime: A_TickCount,
            duration: this.autoDismiss ? this.duration : 0,
            instance: this
        }
    }

    Draw() {
        if (!this.GCache || !this.pBitmapCache || !this.hdc)
            return
        if (!this.cacheDirty && this.scale == 1.0) {
            ; If cache is clean and no scaling, just copy cache to window
            ; But if we have scaling, we need to RenderToWindow anyway
            this.RenderToWindow()
            return
        }

        pal := ToastTheme.palette(this.theme)
        this.clickRegions := []

        ; Clear Cache
        Gdip_GraphicsClear(this.GCache)

        pBrushShadow := Gdip_BrushCreateSolid(pal.shadow)
        Gdip_FillRoundedRectangle(this.GCache, pBrushShadow, 4, 4, this.width - 8, this.height - 8, this.borderRadius)
        Gdip_DeleteBrush(pBrushShadow)

        ; Draw gradient background
        pBrush := Gdip_CreateLineBrushFromRect(0, 0, this.width, this.height, pal.bg1, pal.bg2, 1, 1)
        Gdip_FillRoundedRectangle(this.GCache, pBrush, 0, 0, this.width, this.height, this.borderRadius)
        Gdip_DeleteBrush(pBrush)

        ; Draw border with accent color
        pPen := Gdip_CreatePen(pal.accent, 2)
        Gdip_DrawRoundedRectangle(this.GCache, pPen, 1, 1, this.width - 2, this.height - 2, this.borderRadius)
        Gdip_DeletePen(pPen)

        ; Draw icon if provided
        iconX := this.paddingX
        iconY := this.paddingY
        iconSize := this.iconSize
        textStartX := this.paddingX

        if (this.icon != "") {
            this.DrawIcon(iconX, iconY, iconSize, this.icon, pal)
            textStartX := iconX + iconSize + 12
        }

        ; Draw close button
        if (this.showClose) {
            this.DrawCloseButton(pal)
        }

        ; Draw text
        font := this.fontName
        titleWidth := this.width - textStartX - (this.showClose ? 40 : this.paddingX)

        if (this.title != "") {
            titleOpts := "x" textStartX " y" this.paddingY " w" titleWidth " c" Format("{:x}", pal.fg) " r4 s" this.fontSizeTitle " " this
            .fontWeightTitle
            Gdip_TextToGraphics(this.GCache, this.title, titleOpts, font, this.width, this.height)
        }

        if (this.body != "") {
            bodyY := (this.title != "") ? (this.paddingY + this.fontSizeTitle * 1.5 + 4) : this.paddingY

            ; Calculate available height for body text
            availableHeight := this.height - bodyY - this.paddingY

            ; Reserve space for actions and progress bar
            if (this.actions.Length > 0)
                availableHeight -= 38  ; 28px button + 10px margin
            if (this.showProgress && this.duration > 0)
                availableHeight -= 12  ; 4px bar + 8px margin

            ; Ensure minimum height
            bodyHeight := Max(20, availableHeight)

            bodyOpts := "x" textStartX " y" bodyY " w" titleWidth " h" bodyHeight " c" Format("{:x}", pal.fg) " r4 s" this
            .fontSizeBody " " this.fontWeightBody
            Gdip_TextToGraphics(this.GCache, this.body, bodyOpts, font, this.width, this.height)
        }

        ; Draw action buttons
        if (this.actions.Length) {
            btnW := (this.width - 32 - (this.actions.Length - 1) * 8) // this.actions.Length
            y := this.height - (this.showProgress ? 50 : 40)
            x := 16
            for idx, act in this.actions {
                rectX := x
                rectY := y
                rectW := btnW
                rectH := 28

                ; Button background
                pAccent := Gdip_BrushCreateSolid(pal.accent)
                Gdip_FillRoundedRectangle(this.GCache, pAccent, rectX, rectY, rectW, rectH, 6)
                Gdip_DeleteBrush(pAccent)

                ; Button border for depth
                pPenBtn := Gdip_CreatePen(0x44FFFFFF, 1)
                Gdip_DrawRoundedRectangle(this.GCache, pPenBtn, rectX, rectY, rectW, rectH, 6)
                Gdip_DeletePen(pPenBtn)

                ; Button text
                txtOpts := "x" rectX + 10 " y" rectY + 6 " w" rectW - 20 " cFFFFFFFF r4 s" this.fontSizeBody " Centre Bold"
                Gdip_TextToGraphics(this.GCache, act.HasProp("text") ? act.text : act[1], txtOpts, font, this.width,
                this.height
                )

                this.clickRegions.Push({
                    x: rectX, y: rectY, w: rectW, h: rectH,
                    cb: (act.HasProp("onClick") ? act.onClick : act[2]),
                    type: "button"
                })
                x += btnW + 8
            }
        }

        ; Draw progress bar
        if (this.showProgress && this.duration > 0) {
            this.DrawProgressBar(pal)
        }

        this.cacheDirty := false
        this.RenderToWindow()
    }

    RenderToWindow() {
        Gdip_GraphicsClear(this.G, 0x00000000)

        ; Apply Quality Settings to Window Graphics
        qual := ((this.animState == "in" || this.animState == "out") ? "Low" : this.renderQuality)
        Gdip_SetCompositingMode(this.G, 0) ; SourceOver for proper alpha blending
        if (qual = "Low") {
            Gdip_SetSmoothingMode(this.G, 1) ; HighSpeed
            DllCall("gdiplus\GdipSetPixelOffsetMode", "ptr", this.G, "int", 2) ; HighQuality to avoid black edges
            DllCall("gdiplus\GdipSetCompositingQuality", "ptr", this.G, "int", 2) ; HighQuality blending
            Gdip_SetInterpolationMode(this.G, 5) ; NearestNeighbor
        } else if (qual = "Medium") {
            Gdip_SetSmoothingMode(this.G, 4) ; AntiAlias
            DllCall("gdiplus\GdipSetPixelOffsetMode", "ptr", this.G, "int", 2) ; HighQuality
            DllCall("gdiplus\GdipSetCompositingQuality", "ptr", this.G, "int", 2) ; HighQuality
            Gdip_SetInterpolationMode(this.G, 6) ; HighQualityBilinear
        } else {
            Gdip_SetSmoothingMode(this.G, 4) ; AntiAlias
            DllCall("gdiplus\GdipSetPixelOffsetMode", "ptr", this.G, "int", 2) ; HighQuality
            DllCall("gdiplus\GdipSetCompositingQuality", "ptr", this.G, "int", 2) ; HighQuality
            Gdip_SetInterpolationMode(this.G, 7) ; HighQualityBicubic
        }

        if (this.scale != 1.0 || this.rotation != 0) {
            ; Draw Cached Bitmap with Scaling and Rotation

            ; Fix for 100% flash: If scale is very small, don't draw anything (transparent)
            if (this.scale < 0.01) {
                UpdateLayeredWindow(this.hwnd, this.hdc, this.currentX, this.currentY, this.bufferWidth, this.bufferHeight,
                    0)
                return
            }

            ; Calculate centered rect
            scaledW := this.width * this.scale
            scaledH := this.height * this.scale
            x := (this.width - scaledW) / 2
            y := (this.height - scaledH) / 2

            ; Apply Transformations
            matrix := Gdip_CreateMatrix()
            cx := this.width / 2
            cy := this.height / 2

            ; If buffer is larger (for rotation), we need to center the drawing in the buffer
            drawX := (this.bufferWidth - this.width) / 2
            drawY := (this.bufferHeight - this.height) / 2

            ; Adjust transform origin to center of BUFFER, not center of TOAST
            ; Actually, we just need to translate the world to the center of the buffer
            Gdip_ResetWorldTransform(this.G)

            bufCX := this.bufferWidth / 2
            bufCY := this.bufferHeight / 2

            Gdip_TranslateWorldTransform(this.G, bufCX, bufCY, 0)
            if (this.rotation != 0)
                Gdip_RotateWorldTransform(this.G, this.rotation, 0)
            if (this.scale != 1.0)
                Gdip_ScaleWorldTransform(this.G, this.scale, this.scale, 0)
            Gdip_TranslateWorldTransform(this.G, -bufCX, -bufCY, 0)

            ; Draw centered in the buffer using pBitmapCache directly
            Gdip_DrawImage(this.G, this.pBitmapCache, drawX, drawY, this.width, this.height, 0, 0, this.width, this.height
            )

            ; Apply Warm Glow Brightness Overlay (if active)
            if (this.currentBrightness > 0.01) {
                ; Use warm amber/golden color for a pleasant glow effect
                glowColor := 0xFFFFE5B4  ; Warm peach/amber color
                alpha := Floor(this.currentBrightness * 120)  ; Reduced opacity for subtlety
                pBrushGlow := Gdip_BrushCreateSolid((alpha << 24) | (glowColor & 0xFFFFFF))
                Gdip_FillRoundedRectangle(this.G, pBrushGlow, drawX, drawY, this.width, this.height, this.borderRadius)
                Gdip_DeleteBrush(pBrushGlow)
            }

            Gdip_ResetWorldTransform(this.G)
            Gdip_DeleteMatrix(matrix)

            ; Update Window with Buffer Size
            ; We need to offset the window position so the center remains at currentX, currentY
            winX := this.currentX - (this.bufferWidth - this.width) / 2
            winY := this.currentY - (this.bufferHeight - this.height) / 2

            UpdateLayeredWindow(this.hwnd, this.hdc, winX, winY, this.bufferWidth, this.bufferHeight, Floor(this.opacity *
                255))

        } else {
            ; Direct Draw using Gdip_DrawImage (preserves alpha better than BitBlt from a different DC)
            drawX := (this.bufferWidth - this.width) / 2
            drawY := (this.bufferHeight - this.height) / 2

            ; Draw normally
            Gdip_DrawImage(this.G, this.pBitmapCache, drawX, drawY, this.width, this.height, 0, 0, this.width, this.height
            )

            ; Apply Warm Glow Brightness Overlay (if active)
            if (this.currentBrightness > 0.01) {
                ; Use warm amber/golden color for a pleasant glow effect
                glowColor := 0xFFFFE5B4  ; Warm peach/amber color
                alpha := Floor(this.currentBrightness * 120)  ; Reduced opacity for subtlety
                pBrushGlow := Gdip_BrushCreateSolid((alpha << 24) | (glowColor & 0xFFFFFF))
                Gdip_FillRoundedRectangle(this.G, pBrushGlow, drawX, drawY, this.width, this.height, this.borderRadius)
                Gdip_DeleteBrush(pBrushGlow)
            }

            winX := this.currentX - drawX
            winY := this.currentY - drawY
            UpdateLayeredWindow(this.hwnd, this.hdc, winX, winY, this.bufferWidth, this.bufferHeight, Floor(this.opacity *
                255))
        }
    }

    ResizeBuffer(w, h) {
        if (w <= this.bufferWidth && h <= this.bufferHeight)
            return ; Already large enough

        SelectObject(this.hdc, this.obm)
        DeleteObject(this.hbm)
        Gdip_DeleteGraphics(this.G)

        this.bufferWidth := w
        this.bufferHeight := h

        this.hbm := CreateDIBSection(w, h)
        this.obm := SelectObject(this.hdc, this.hbm)
        this.G := Gdip_GraphicsFromHDC(this.hdc)
        Gdip_SetSmoothingMode(this.G, 4)
    }

    UpdateWindow(x := "", y := "", alpha := 255) {
        if (x != "")
            this.currentX := x
        if (y != "")
            this.currentY := y

        ; Use buffer size if available (for rotation/scaling that needs more space)
        w := (this.bufferWidth > this.width) ? this.bufferWidth : this.width
        h := (this.bufferHeight > this.height) ? this.bufferHeight : this.height

        ; Calculate window position offset to keep content centered
        ; If buffer is larger, window top-left must be shifted left/up
        winX := this.currentX - (w - this.width) / 2
        winY := this.currentY - (h - this.height) / 2

        UpdateLayeredWindow(this.hwnd, this.hdc, winX, winY, w, h, alpha)
    }

    DrawIcon(x, y, size, iconType, pal) {
        pBrush := Gdip_BrushCreateSolid(pal.accent)
        pBrushWhite := Gdip_BrushCreateSolid(0xFFFFFFFF)
        pPen := Gdip_CreatePen(0xFFFFFFFF, 3)

        switch iconType {
            case "success":
                Gdip_FillEllipse(this.GCache, pBrush, x, y, size, size)
                points := x "," (y + size / 2) "|" (x + size / 3) "," (y + size * 2 / 3) "|" (x + size * 4 / 5) "," (y +
                    size / 4)
                Gdip_DrawLines(this.GCache, pPen, points)
            case "error":
                Gdip_FillEllipse(this.GCache, pBrush, x, y, size, size)
                Gdip_DrawLine(this.GCache, pPen, x + size / 4, y + size / 4, x + size * 3 / 4, y + size * 3 / 4)
                Gdip_DrawLine(this.GCache, pPen, x + size * 3 / 4, y + size / 4, x + size / 4, y + size * 3 / 4)
            case "warning":
                points := (x + size / 2) "," y "|" x "," (y + size) "|" (x + size) "," (y + size)
                Gdip_FillPolygon(this.GCache, pBrush, points)
                pPenThick := Gdip_CreatePen(0xFFFFFFFF, 2)
                Gdip_DrawLine(this.GCache, pPenThick, x + size / 2, y + size / 4, x + size / 2, y + size / 2)
                Gdip_FillEllipse(this.GCache, pBrushWhite, x + size / 2 - 2, y + size * 2 / 3, 4, 4)
                Gdip_DeletePen(pPenThick)
            case "info":
                Gdip_FillEllipse(this.GCache, pBrush, x, y, size, size)
                Gdip_FillEllipse(this.GCache, pBrushWhite, x + size / 2 - 2, y + size / 4, 4, 4)
                pPenThick := Gdip_CreatePen(0xFFFFFFFF, 2)
                Gdip_DrawLine(this.GCache, pPenThick, x + size / 2, y + size / 2.5, x + size / 2, y + size * 3 / 4)
                Gdip_DeletePen(pPenThick)
        }
        Gdip_DeleteBrush(pBrush)
        Gdip_DeleteBrush(pBrushWhite)
        Gdip_DeletePen(pPen)
    }

    DrawCloseButton(pal) {
        closeSize := 20
        closeX := this.width - this.paddingX - closeSize
        closeY := this.paddingY - 4

        ; Expanded hit area for better accessibility (+10px padding)
        hitPadding := 10
        this.clickRegions.Push({
            x: closeX - hitPadding,
            y: closeY - hitPadding,
            w: closeSize + (hitPadding * 2),
            h: closeSize + (hitPadding * 2),
            cb: (*) => this.ForceClose(),
            type: "close"
        })

        ; Calculate center of close button for transformations
        centerX := closeX + closeSize / 2
        centerY := closeY + closeSize / 2

        ; Apply Transformations for Close Button (Spin & Zoom)
        Gdip_TranslateWorldTransform(this.GCache, centerX, centerY, 0)
        Gdip_RotateWorldTransform(this.GCache, this.closeBtnRotation, 0)
        Gdip_ScaleWorldTransform(this.GCache, this.closeBtnScale, this.closeBtnScale, 0)
        Gdip_TranslateWorldTransform(this.GCache, -centerX, -centerY, 0)

        ; Draw X
        color := (Floor(this.closeBtnAlpha) << 24) | 0xFFFFFF
        pPen := Gdip_CreatePen(color, 2)
        offset := 6
        Gdip_DrawLine(this.GCache, pPen, closeX + offset, closeY + offset, closeX + closeSize - offset, closeY +
            closeSize -
            offset)
        Gdip_DrawLine(this.GCache, pPen, closeX + closeSize - offset, closeY + offset, closeX + offset, closeY +
            closeSize -
            offset)
        Gdip_DeletePen(pPen)

        ; Reset Transform
        Gdip_ResetWorldTransform(this.GCache)
    }

    DrawProgressBar(pal) {
        barHeight := 4
        barY := this.height - barHeight - 4
        barX := 8
        barWidth := this.width - 16

        pBrushBg := Gdip_BrushCreateSolid(0x33000000)
        Gdip_FillRoundedRectangle(this.GCache, pBrushBg, barX, barY, barWidth, barHeight, 2)
        Gdip_DeleteBrush(pBrushBg)

        if (this.progress > 0) {
            fillWidth := barWidth * this.progress
            pBrushFill := Gdip_BrushCreateSolid(pal.progress)
            Gdip_FillRoundedRectangle(this.GCache, pBrushFill, barX, barY, fillWidth, barHeight, 2)
            Gdip_DeleteBrush(pBrushFill)
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
        ; Initial State Setup based on Animation Style
        this.opacity := 1.0
        this.scale := 1.0
        this.rotation := 0.0

        if (this.HasAnim("fade")) {
            this.opacity := 0.0
        }

        if (this.HasAnim("zoom")) {
            this.scale := 0.0
        }

        if (this.HasAnim("rotate")) {
            this.rotation := -90.0 ; Start rotated
            ; Buffer resizing is now handled in __createWindow
        }

        ; Calculate Start Position
        startX := this.targetX
        startY := this.targetY

        if (this.HasAnim("slide")) {
            entrance := this.animEntrance
            if (entrance == "auto") {
                ; Auto-detect entrance direction based on alignment
                switch this.alignment {
                    case "topleft", "top", "topright":
                        entrance := "top"     ; Slide from top
                    case "bottomleft", "bottom", "bottomright":
                        entrance := "bottom"  ; Slide from bottom
                    case "centerleft":
                        entrance := "left"    ; Slide from left
                    case "centerright":
                        entrance := "right"   ; Slide from right
                    case "center":
                        ; For center, default to zoom/fade if available, otherwise top
                        entrance := this.HasAnim("zoom") ? "none" : "top"
                }
            }

            if (entrance == "right")
                startX := A_ScreenWidth
            else if (entrance == "left")
                startX := -this.width
            else if (entrance == "top")
                startY := -this.height
            else if (entrance == "bottom")
                startY := A_ScreenHeight
        } else {
            ; For non-slide animations, start AT the target position
            startX := this.targetX
            startY := this.targetY
        }

        this.currentX := startX
        this.currentY := startY

        ; We do NOT draw here. Draw() is called after this in __New
    }

    AnimateIn() {
        this.animState := "in"
        this.animStartTime := A_TickCount
        this.progressStartTime := A_TickCount + this.animDuration

        ; State is already set by InitAnimation
        ; Just update window to start position
        this.UpdateWindow(this.currentX, this.currentY, Floor(this.opacity * 255))
    }

    Tick() {
        if (!this.hwnd)
            return

        ; === PERFORMANCE: Early exit for invisible toasts ===
        if (this.opacity < 0.01 && this.animState != "in")
            return

        now := A_TickCount
        dirty := false

        if (this.animState != "out" && this.autoDismiss) {
            if !(Toastify.hoverPauseEnabled && this.hovered && this.progressPaused) {
                dynDuration := this.duration
                if (this.hwnd && Toastify.registry.Has(this.hwnd))
                    dynDuration := Toastify.registry[this.hwnd].duration
                maxLifetime := dynDuration + (this.animDuration * 2) + 1000
                if ((now - this.creationTime) > maxLifetime) {
                    this.StartExit()
                    return
                }
            }
        }

        ; --- 1. Animation Logic ---
        if (this.animState == "in" || this.animState == "out") {
            elapsed := now - this.animStartTime
            t := 0

            if (elapsed < this.animDuration) {
                t := elapsed / this.animDuration
                ease := ToastEasing.get(this.animEasing, t)

                ; IN Animation
                if (this.animState == "in") {
                    ; Position (Slide)
                    if (this.HasAnim("slide")) {
                        ; Re-calculate start pos if needed, but we set currentX in AnimateIn
                        ; We need to interpolate from initial currentX to targetX
                        ; BUT currentX is updated every frame.
                        ; We need to know the ORIGIN.
                        ; Simplified: We know targetX/Y. We need to calculate offset based on (1-ease).

                        entrance := this.animEntrance
                        if (entrance == "auto") {
                            ; Auto-detect entrance direction based on alignment
                            switch this.alignment {
                                case "topleft", "top", "topright":
                                    entrance := "top"
                                case "bottomleft", "bottom", "bottomright":
                                    entrance := "bottom"
                                case "centerleft":
                                    entrance := "left"
                                case "centerright":
                                    entrance := "right"
                                case "center":
                                    entrance := this.HasAnim("zoom") ? "none" : "top"
                            }
                        }

                        offX := 0, offY := 0
                        if (entrance == "right")
                            offX := (A_ScreenWidth - this.targetX) * (1 - ease)
                        else if (entrance == "left")
                            offX := (-this.width - this.targetX) * (1 - ease)
                        else if (entrance == "top")
                            offY := (-this.height - this.targetY) * (1 - ease)
                        else if (entrance == "bottom")
                            offY := (A_ScreenHeight - this.targetY) * (1 - ease)

                        this.currentX := this.targetX + offX
                        this.currentY := this.targetY + offY
                        dirty := true
                    } else {
                        ; No slide, just snap to target
                        this.currentX := this.targetX
                        this.currentY := this.targetY
                    }

                    ; Opacity (Fade)
                    if (this.HasAnim("fade")) {
                        this.opacity := ease
                        dirty := true
                    } else {
                        this.opacity := 1.0
                    }

                    ; Scale (Zoom)
                    if (this.HasAnim("zoom")) {
                        this.scale := ease
                        this.RenderToWindow() ; Use RenderToWindow instead of Draw
                        dirty := true
                    } else {
                        this.scale := 1.0
                    }

                    ; Rotation
                    if (this.HasAnim("rotate")) {
                        this.rotation := -90.0 * (1.0 - ease)
                        this.RenderToWindow()
                        dirty := true
                    } else {
                        this.rotation := 0.0
                    }

                }
                ; OUT Animation
                else {
                    ; Position (Slide)
                    if (this.HasAnim("slide")) {
                        entrance := this.animEntrance
                        if (entrance == "auto") {
                            ; Auto-detect entrance direction based on alignment
                            switch this.alignment {
                                case "topleft", "top", "topright":
                                    entrance := "top"
                                case "bottomleft", "bottom", "bottomright":
                                    entrance := "bottom"
                                case "centerleft":
                                    entrance := "left"
                                case "centerright":
                                    entrance := "right"
                                case "center":
                                    entrance := this.HasAnim("zoom") ? "none" : "top"
                            }
                        }

                        ; Reverse direction for exit
                        offX := 0, offY := 0
                        if (entrance == "right")
                            offX := (A_ScreenWidth - this.targetX) * ease
                        else if (entrance == "left")
                            offX := (-this.width - this.targetX) * ease
                        else if (entrance == "top")
                            offY := (-this.height - this.targetY) * ease
                        else if (entrance == "bottom")
                            offY := (A_ScreenHeight - this.targetY) * ease

                        this.currentX := this.targetX + offX
                        this.currentY := this.targetY + offY
                        dirty := true
                    }

                    ; Opacity (Fade)
                    if (this.HasAnim("fade")) {
                        this.opacity := 1.0 - ease
                        dirty := true
                    }

                    ; Scale (Zoom)
                    if (this.HasAnim("zoom")) {
                        this.scale := 1.0 - ease
                    }

                    ; Rotation
                    if (this.HasAnim("rotate")) {
                        this.rotation := 90.0 * ease ; Rotate out
                        this.RenderToWindow()
                        dirty := true
                    }
                }
            } else {
                ; Animation Complete
                if (this.animState == "in") {
                    this.animState := "idle"
                    this.currentX := this.targetX
                    this.currentY := this.targetY
                    this.opacity := 1.0
                    this.scale := 1.0
                    this.rotation := 0.0
                    if (this.HasAnim("zoom") || this.HasAnim("rotate"))
                        this.RenderToWindow()
                    dirty := true
                } else {
                    this.Dismiss()
                    return
                }
            }
        } else if (this.animState == "idle") {

            ; === HOVER EFFECTS INTERPOLATION ===
            ; OPTIMIZATION: Only update hover effects at reduced rate during idle state
            now := A_TickCount
            if (now - this.lastHoverUpdate < 16) {
                ; Skip this frame for hover effects (cap at ~60 FPS)
            } else {
                this.lastHoverUpdate := now

                targetS := 1.0
                targetR := 0.0
                targetO := 1.0
                targetB := 0.0

                if (this.hovered) {
                    for style in this.hoverStyle {
                        if (style == "zoom")
                            targetS := this.hoverScale
                        else if (style == "rotate")
                            targetR := this.hoverRotation
                        else if (style == "opacity")
                            targetO := this.hoverOpacity
                        else if (style == "brightness")
                            targetB := this.hoverBrightness
                    }
                }

                ; Smoothly interpolate values
                diffS := targetS - this.scale
                diffR := targetR - this.rotation
                diffO := targetO - this.opacity
                diffB := targetB - this.currentBrightness

                if (Abs(diffS) > 0.001 || Abs(diffR) > 0.1 || Abs(diffO) > 0.01 || Abs(diffB) > 0.01) {
                    this.scale += diffS * 0.2
                    this.rotation += diffR * 0.2
                    this.opacity += diffO * 0.2
                    this.currentBrightness += diffB * 0.2
                    this.RenderToWindow() ; Redraw with new transform/effects
                    dirty := true
                } else {
                    ; Snap to target if close enough
                    this.scale := targetS
                    this.rotation := targetR
                    this.opacity := targetO
                    this.currentBrightness := targetB
                }
            }

            ; === CLOSE BUTTON ANIMATION ===
            ; OPTIMIZATION: Batch close button updates with hover effects
            targetCS := this.closeHovered ? 1.3 : 1.0
            targetCR := this.closeHovered ? 90.0 : 0.0
            targetCA := this.closeHovered ? 255.0 : 170.0

            diffCS := targetCS - this.closeBtnScale
            diffCR := targetCR - this.closeBtnRotation
            diffCA := targetCA - this.closeBtnAlpha

            ; OPTIMIZATION: Only redraw if visual change is significant
            if (Abs(diffCS) > 0.02 || Abs(diffCR) > 2.0 || Abs(diffCA) > 5.0) {
                this.closeBtnScale += diffCS * 0.25
                this.closeBtnRotation += diffCR * 0.2
                this.closeBtnAlpha += diffCA * 0.2

                ; OPTIMIZATION: Throttle Draw() calls - max once per 16ms
                if (A_TickCount - this.lastDrawTime > 16) {
                    this.cacheDirty := true
                    this.Draw()
                    this.lastDrawTime := A_TickCount
                    dirty := true
                }
            } else {
                this.closeBtnScale := targetCS
                this.closeBtnRotation := targetCR
                this.closeBtnAlpha := targetCA
            }

            if (Abs(this.currentX - this.targetX) > 0.5 || Abs(this.currentY - this.targetY) > 0.5) {
                this.currentX += (this.targetX - this.currentX) * 0.2
                this.currentY += (this.targetY - this.currentY) * 0.2
                dirty := true
            } else {
                this.currentX := this.targetX
                this.currentY := this.targetY
            }
        }

        ; --- 2. Progress Bar Animation --- [HEAVILY OPTIMIZED]
        if (this.showProgress && this.duration > 0 && this.animState != "out") {
            if (!this.progressPaused) {
                if (now >= this.progressStartTime) {
                    elapsed := now - this.progressStartTime
                    newProgress := Min(1.0, elapsed / this.duration)

                    ; ALWAYS update progress value (even small changes) for accurate completion detection
                    if (newProgress != this.progress) {
                        this.progress := newProgress

                        ; === Smooth Progress Redraw ===
                        ; Redraw when:
                        ; 1. Visual delta >= ~0.5px (adaptive by bar width)
                        ; 2. OR ~16ms elapsed (target ~60 FPS)
                        ; 3. OR reaching 100%
                        timeSinceLastDraw := now - this.lastProgressDrawTime
                        barWidth := this.width - 16
                        thresholdProgress := Max(0.0005, 0.5 / barWidth)
                        significantChange := Abs(newProgress - this.lastProgress) > thresholdProgress
                        timeForUpdate := timeSinceLastDraw > 16
                        isComplete := newProgress >= 1.0

                        if (significantChange || timeForUpdate || isComplete) {
                            this.lastProgress := newProgress
                            this.lastProgressDrawTime := now
                            this.cacheDirty := true  ; Force cache redraw for progress bar
                            this.Draw()  ; Redraw to update progress bar
                            dirty := true
                        }
                    }

                    ; CRITICAL: Check completion AFTER updating progress value
                    ; Only exit when progress is EXACTLY 1.0 (100%)
                    if (this.progress >= 1.0) {
                        ; Ensure final draw at exactly 100% happened
                        if (this.lastProgress < 1.0) {
                            this.lastProgress := 1.0
                            this.lastProgressDrawTime := now
                            this.cacheDirty := true
                            this.Draw()  ; Final draw at 100%
                            dirty := true
                        }

                        ; CRITICAL: Don't exit if user is hovering (pause indefinitely)
                        if (!this.hovered || !Toastify.hoverPauseEnabled) {
                            this.StartExit()  ; Trigger exit animation
                            return  ; Stop processing this tick
                        }
                        ; If hovered, keep toast alive - it will exit when mouse leaves
                    }
                }
            }
        }

        if (dirty) {
            this.UpdateWindow(this.currentX, this.currentY, Floor(this.opacity * 255))
        }
    }

    StartExit() {
        ; Ensure we are in "out" state
        if (this.animState != "out") {
            this.animState := "out"
            this.animStartTime := A_TickCount
            this.targetX := this.currentX ; Freeze start position for exit anim

            if (this.onCloseCallback) {
                try this.onCloseCallback()
            }
        }

        ; AGGRESSIVELY remove from active list
        loop {
            found := false
            for i, t in Toastify.toasts {
                if (t = this) {
                    Toastify.toasts.RemoveAt(i)
                    found := true
                    break
                }
            }
            if (!found)
                break
        }

        ; Ensure it's in exiting list (avoid duplicates)
        inExiting := false
        for t in Toastify.exitingToasts {
            if (t = this) {
                inExiting := true
                break
            }
        }

        if (!inExiting) {
            Toastify.exitingToasts.Push(this)
        }

        ; Reflow will be triggered after exit animation completes in Dismiss()
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

        ; Fix Hit Testing: Adjust for scale
        ; If toast is scaled (zoom effect), the mouse coordinates need to be mapped back to bitmap space
        if (this.scale != 1.0 && this.scale > 0) {
            ; Center of toast is the pivot
            cx := this.width / 2
            cy := this.height / 2

            ; Translate to center, unscale, translate back
            x := (x - cx) / this.scale + cx
            y := (y - cy) / this.scale + cy
        }

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
            ; Draw() calls RenderToWindow() at the end, so we don't need to call it again
            ; But we do need to update window position if it changed (unlikely here)
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

                    ; Update Watchdog duration to account for pause
                    if (this.hwnd && Toastify.registry.Has(this.hwnd)) {
                        Toastify.registry[this.hwnd].duration += pausedDuration
                    }
                }
            } else {
                ; Permanent toasts: do not adjust timers or registry duration
                this.progressPaused := false
            }

            this.Draw()
            this.UpdateWindow(this.currentX, this.currentY)
        }
    }

    OnClick(x, y) {
        offsetX := (this.bufferWidth > this.width) ? (this.bufferWidth - this.width) / 2 : 0
        offsetY := (this.bufferHeight > this.height) ? (this.bufferHeight - this.height) / 2 : 0

        realX := x - offsetX
        realY := y - offsetY

        ; Fix Hit Testing for Click: Adjust for scale
        if (this.scale != 1.0 && this.scale > 0) {
            cx := this.width / 2
            cy := this.height / 2
            realX := (realX - cx) / this.scale + cx
            realY := (realY - cy) / this.scale + cy
        }

        cx := realX
        cy := realY
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

    Dismiss() {
        this.Destroy()

        ; Remove from exiting toasts
        for i, t in Toastify.exitingToasts {
            if (t = this) {
                Toastify.exitingToasts.RemoveAt(i)
                Toastify.__reflow(true)
                break
            }
        }

        ; Remove from active toasts (fallback)
        for i, t in Toastify.toasts {
            if (t = this) {
                Toastify.toasts.RemoveAt(i)
                Toastify.__reflow(true)
                break
            }
        }
    }

    Destroy() {
        if (this.hwnd && Toastify.registry.Has(this.hwnd)) {
            Toastify.registry.Delete(this.hwnd)
        }

        if (this.hdc) {
            SelectObject(this.hdc, this.obm)
            DeleteObject(this.hbm)
            DeleteDC(this.hdc)
            Gdip_DeleteGraphics(this.G)
            this.hdc := 0
        }
        if (this.pBitmapCache) {
            Gdip_DisposeImage(this.pBitmapCache)
            this.pBitmapCache := 0
        }
        if (this.GCache) {
            Gdip_DeleteGraphics(this.GCache)
            this.GCache := 0
        }
        if (this.gui) {
            this.gui.Destroy()
            this.gui := 0
            this.hwnd := 0
        }
    }
}
