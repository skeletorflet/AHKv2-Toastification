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

    static __nextTickDelay() {
        if (Toastify.exitingToasts.Length > 0 || Toastify._reflowNeeded)
            return 16
        for t in Toastify.toasts
            if (t.animState == "in" || t.repoActive || t._hoverOpacityActive
                || (t.showProgress && t.duration > 0 && !t.progressPaused))
                return 16
        ; ponytail: semi-idle 100ms; volver a 60Hz solo si hay animación/progreso vivo
        return 100
    }
    static __globalTick(*) {
        now := A_TickCount
        elapsed := now - Toastify.__lastTickTime
        Toastify.__lastTickTime := now
        SetTimer(Toastify.__globalTimer, -Toastify.__nextTickDelay())

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
