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
    static reducedMotion := false
    static highContrast := false
    static escEnabled := false
    static __globalTimer := 0
    static __frameCounter := 0
    static __lastTickTime := 0
    static __qpcFreq := 0
    static __perfFast := false
    static __frameStats := []
    static __frameStatsIdx := 0
    ; ── Coste REAL del frame (QPC) ──
    ;    __frameStats guarda el INTERVALO entre ticks (cuánto tarda el timer),
    ;    esto guarda lo que cuesta atenderlo: FPS() reporta ambos.
    static __costStats := []
    static __costIdx := 0
    static __costMax := 0
    ; ── Contador de UpdateLayeredWindow (compositor) ──
    static __ulwTotal := 0
    ; Delay con el que está armado el timer (evita re-armarlo en cada wake)
    static __armedDelay := 0
    ; Prioridad del proceso anfitrión, para restaurarla al salir de modo rápido
    static __origPriority := 0
    static _reflowNeeded := false
    static __active := false
    static __suspended := false
    ; ── Windows messages usados por los hooks de la lib ──
    static WM_LBUTTONDOWN := 0x0201
    static WM_MOUSEMOVE := 0x0200
    static WM_MOUSELEAVE := 0x02A3
    static WM_DPICHANGED := 0x02E0

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
        AUTO: "auto",
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
        FLAT_LIGHT: "flat-light",
        DRACULA: "dracula",
        DRACULA_LIGHT: "dracula-light",
        TOKYO_NIGHT: "tokyo-night",
        TOKYO_NIGHT_LIGHT: "tokyo-night-light",
        CATPPUCCIN_MOCHA: "catppuccin-mocha",
        CATPPUCCIN_LATTE: "catppuccin-latte",
        NORD: "nord",
        NORD_LIGHT: "nord-light",
        SOLARIZED: "solarized",
        SOLARIZED_LIGHT: "solarized-light",
        GRUVBOX: "gruvbox",
        GRUVBOX_LIGHT: "gruvbox-light",
        ONE_DARK: "one-dark",
        ONE_LIGHT: "one-light",
        SYNTHWAVE: "synthwave",
        SYNTHWAVE_LIGHT: "synthwave-light",
        MONOKAI: "monokai",
        MONOKAI_LIGHT: "monokai-light",
        MATERIAL_YOU: "material-you",
        MATERIAL_YOU_LIGHT: "material-you-light",
        CARBON: "carbon",
        CARBON_LIGHT: "carbon-light",
        AYU: "ayu",
        AYU_LIGHT: "ayu-light"
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
        for key in ToastConfig.AllKeys {

            if cfg.HasProp(key)
                Toastify.config.%key% := cfg.%key%
        }
    }
    static RegisterTheme(name, palette) {
        ToastTheme.Register(name, palette)
    }

static Start(theme := "dark", position := "top-right") {
        if !Toastify.pToken {
            pt := Gdip_Startup()
            if !pt {
                MsgBox("GDI+ startup failed")
                return
            }
            Toastify.pToken := pt
            ToastTheme.InitThemes()
            OnExit((*) => Toastify.Shutdown())
            Toastify.__hClick := (wParam, lParam, msg, hwnd) =>
                Toastify.__Click(wParam, lParam, msg, hwnd)
            ; Prioridad del host: la restauramos al salir de modo rápido (antes
            ; se forzaba NORMAL y se pisaba la del script anfitrión).
            ; OJO: AHK v2 NO tiene ProcessGetPriority → la clase se lee con
            ; GetPriorityClass (kernel32).
            try Toastify.__origPriority := Toastify.__priorityClass()
            ; Native hover: WM_MOUSEMOVE + TrackMouseEvent/WM_MOUSELEAVE.
            ; Windows resolves z-order: only the topmost toast receives messages.
            Toastify.__hMove := (wParam, lParam, msg, hwnd) =>
                Toastify.__onMouseMove(lParam, hwnd)
            Toastify.__hLeave := (wParam, lParam, msg, hwnd) =>
                Toastify.__onMouseLeave(hwnd)
            Toastify.__hDpi := (wParam, lParam, msg, hwnd) =>
                Toastify.__onDpiChanged(hwnd)
            OnMessage(Toastify.WM_LBUTTONDOWN, Toastify.__hClick)
            OnMessage(Toastify.WM_MOUSEMOVE, Toastify.__hMove)
            OnMessage(Toastify.WM_MOUSELEAVE, Toastify.__hLeave)
            OnMessage(Toastify.WM_DPICHANGED, Toastify.__hDpi)
            Toastify.__globalTimer := ObjBindMethod(Toastify, "__globalTick")
            Toastify.__lastTickTime := Toastify.__now()
            Toastify.__frameCounter := 0
            ; PR5: respect Windows "show animations" setting
            ani := 0
            DllCall("SystemParametersInfoW", "uint", 0x1042, "uint", 0, "ptr*", &ani, "uint", 0)
            Toastify.reducedMotion := (ani = 0)
            ; PR6: Windows high-contrast mode → default theme forced to "minimal"
            ; HIGHCONTRASTW = UINT cbSize(4)+DWORD flags(4)+LPWSTR(8) = 16 en x64
            hc := Buffer(16, 0)
            NumPut("uint", 16, hc, 0)
            if (DllCall("SystemParametersInfoW", "uint", 0x0042, "uint", 16, "ptr", hc, "uint", 0))
                Toastify.highContrast := (NumGet(hc, 4, "uint") & 0x1) != 0
            else
                Toastify.highContrast := false
            ; PR7: optional global Esc to dismiss the newest toast (opt-in)
            Toastify.__syncEscHotkey()
        }
        Toastify.theme := theme
        Toastify.position := position
        Toastify.__syncEscHotkey()
    }
    static SetEscEnabled(enabled) {
        Toastify.escEnabled := !!enabled
        Toastify.__syncEscHotkey()
    }
    static __syncEscHotkey() {
        if (!Toastify.pToken)
            return
        if (Toastify.escEnabled) {
            try Hotkey("Esc", (*) => Toastify.__escDismiss(), "On")
        } else {
            try Hotkey("Esc", "Off")
        }
    }

    static __escDismiss(*) {
        if (Toastify.toasts.Length = 0)
            return
        Toastify.toasts[Toastify.toasts.Length].StartExit()
    }

    ; ── Enable/disable the frame loop ──
    ;    Active only while toasts are alive: 60Hz timer, 2ms timer res,
    ;    HIGH priority. Idle → everything restored, 0% CPU.
    ; ── QPC clock: A_TickCount cuantiza a 15.6ms, miente en telemetría 60Hz ──
    static __now() {
        if (!Toastify.__qpcFreq) {
            DllCall("QueryPerformanceFrequency", "Int64*", &f := 0)
            Toastify.__qpcFreq := f / 1000.0
        }
        DllCall("QueryPerformanceCounter", "Int64*", &c := 0)
        return c / Toastify.__qpcFreq
    }
    static __setActive(active) {
        if (active == Toastify.__active)
            return
        Toastify.__active := active
        if (active) {
            Toastify.__setPerfMode(true)
            Toastify.__lastTickTime := Toastify.__now()
            ; ponytail: -8ms rel entrega ~16ms reales (QPC verificado) → 60fps
            Toastify.__armedDelay := 8
            SetTimer(Toastify.__globalTimer, -8)
        } else {
            Toastify.__setPerfMode(false)
            if (Toastify.__globalTimer)
                SetTimer(Toastify.__globalTimer, 0)
            if (Toastify.registry.Count > 0)
                Toastify.__ensureSweep()
        }
    }
    static __setPerfMode(fast) {
        if (fast == Toastify.__perfFast)
            return
        Toastify.__perfFast := fast
        if (fast) {
            DllCall("Winmm.dll\timeBeginPeriod", "UInt", 2)
            ; Solo se sube la prioridad si el host está en Normal o menos:
            ; si el script anfitrión ya corre en High/Realtime, se respeta.
            if (!Toastify.__isLowPriority(Toastify.__origPriority))
                ProcessSetPriority(Toastify.PRIORITY.ABOVE_NORMAL)
        } else {
            DllCall("Winmm.dll\timeEndPeriod", "UInt", 2)
            if (Toastify.__origPriority)
                try ProcessSetPriority(Toastify.__origPriority)
        }
    }
    ; ── Priority class del proceso actual como string de ProcessSetPriority ──
    ;    AHK v2 no expone ProcessGetPriority; GetPriorityClass → mapeo directo.
    ;    PRIORITY_CLASS: IDLE 0x40, BELOW_NORMAL 0x4000, NORMAL 0x20,
    ;    ABOVE_NORMAL 0x8000, HIGH 0x80, REALTIME 0x100.
    static __priorityClass() {
        ; OJO: la variable NO puede llamarse `map` — en AHK v2 el nombre local
        ; tapa al constructor Map() y la línea lanza "variable not assigned".
        static pcMap := Map(0x40, Toastify.PRIORITY.IDLE, 0x4000, Toastify.PRIORITY.BELOW_NORMAL
            , 0x20, Toastify.PRIORITY.NORMAL, 0x8000, Toastify.PRIORITY.ABOVE_NORMAL
            , 0x80, Toastify.PRIORITY.HIGH, 0x100, Toastify.PRIORITY.REALTIME)
        pc := DllCall("GetPriorityClass", "ptr", DllCall("GetCurrentProcess", "ptr"), "uint")
        return pcMap.Has(pc) ? pcMap[pc] : ""
    }
    static __isLowPriority(p) {
        return (p = "" || p = Toastify.PRIORITY.IDLE || p = Toastify.PRIORITY.BELOW_NORMAL
            || p = Toastify.PRIORITY.NORMAL)
    }

    static Shutdown(*) {
        Toastify.__setActive(false)
        try SetTimer(Toastify.__sweepTimer, 0)
        if (Toastify.__hClick) {
            try OnMessage(Toastify.WM_LBUTTONDOWN, Toastify.__hClick, 0)
            try OnMessage(Toastify.WM_MOUSEMOVE, Toastify.__hMove, 0)
            try OnMessage(Toastify.WM_MOUSELEAVE, Toastify.__hLeave, 0)
            try OnMessage(Toastify.WM_DPICHANGED, Toastify.__hDpi, 0)
            Toastify.__hClick := Toastify.__hMove := Toastify.__hLeave := Toastify.__hDpi := 0
        }
        try Hotkey("Esc", "Off")
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
            Toast.FreeFontCache()
            Toast.FreeShadowCache()
            ToastTheme.Shutdown()
            try Gdip_Shutdown(Toastify.pToken)
            Toastify.pToken := 0
        }
    }
    ; Low-frequency sweep while the 60Hz loop is suspended (permanent toasts):
    ; reaps externally-destroyed hwnds so registry never retains dead windows.
    static __sweepTimer := 0
    static __ensureSweep() {
        if (!Toastify.__sweepTimer)
            Toastify.__sweepTimer := ObjBindMethod(Toastify, "__sweepDead")
        SetTimer(Toastify.__sweepTimer, 1000)
    }
    static __sweepDead() {
        if (Toastify.__active || Toastify.registry.Count = 0) {
            if (Toastify.registry.Count = 0)
                try SetTimer(Toastify.__sweepTimer, 0)
            return
        }
        for hwnd, data in Toastify.registry.Clone() {
            if (!DllCall("IsWindow", "ptr", hwnd)) {
                t := Toastify.__toastByHwnd(hwnd)
                if (t)
                    try t.Dismiss(true)
                if (Toastify.registry.Has(hwnd))
                    Toastify.registry.Delete(hwnd)
            }
        }
        if (Toastify.registry.Count = 0)
            try SetTimer(Toastify.__sweepTimer, 0)
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
        if !opts
            opts := {}
        t := Toastify.__createToast("", "", [], opts)
        t.view := viewItems
        t.Invalidate(false)
        t.Draw()
        return t
    }

    static DismissAll() {
        for t in Toastify.toasts.Clone()
            t.StartExit()
    }

    ; Eliminación inmediata: mata toasts activos + los que animan salida.
    static KillAll() {
        for t in Toastify.toasts.Clone()
            t.Dismiss(true)
        for t in Toastify.exitingToasts.Clone()
            t.Dismiss(true)
    }

    static __createToast(title, body, actions, opts) {
        if !opts
            opts := {}
        if !opts.HasProp("theme")
            opts.theme := Toastify.highContrast ? "minimal" : Toastify.theme
        if !opts.HasProp("position")
            opts.position := Toastify.position

        ; PR2: same tag replaces the existing toast (dedupe spam, case-sensitive)
        if (opts.HasProp("tag") && opts.tag != "") {
            for t in Toastify.toasts.Clone()
                if (t.tag == opts.tag) {
                    t.Dismiss(true, false)
                    break
                }
            for t in Toastify.exitingToasts.Clone()
                if (t.tag == opts.tag) {
                    t.Dismiss(true, false)
                    break
                }
        }

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
            cp := ToastDPI.CursorPoint()
            wa := ToastDPI.WorkArea(cp.x, cp.y)
            dpi := ToastDPI.ForPoint(cp.x, cp.y)
        }
        marginY := ToastDPI.Px(opts.HasProp("marginY") ? opts.marginY : Toastify.marginY, dpi)
        spacing := ToastDPI.Px(opts.HasProp("spacing") ? opts.spacing : Toastify.spacing, dpi)

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
        estHeight := ToastDPI.Px(Toastify.config.minHeight, dpi)
        if (usedH + estHeight > availableH && toastsInPos > 0) {
            ; evict the lowest-priority toast in that position (PR3)
            cand := 0
            for t in Toastify.toasts
                if (t.position = pos && (!cand || t.priority < cand.priority))
                    cand := t
            if (cand)
                cand.StartExit()
        }

        ; hard cap global — evict lowest priority, not just oldest (PR3)
        if (Toastify.toasts.Length >= Toastify.maxToasts)
            Toastify.__lowestPriorityToast().StartExit()

        ; pass the computed destination-monitor dpi to the constructor
        opts := opts.Clone()
        opts.dpi := dpi

        t := Toast(title, body, actions, opts)
        t._stagger := Min(Toastify.toasts.Length, 4) * 60
        Toastify.toasts.Push(t)
        Toastify.__setActive(true)
        Toastify.__reflow(true)

        t.AnimateIn()
        t.Draw()
        ; Ya se refloweó arriba: marcar _reflowNeeded forzaba un SEGUNDO reflow
        ; completo de todos los toasts en el tick siguiente.
        return t
    }

    static __lowestPriorityToast() {
        t0 := 0
        for t in Toastify.toasts
            if (!t0 || t.priority < t0.priority)
                t0 := t
        return t0
    }

    ; PR4: group control by tag (case-sensitive)
    static DismissGroup(tag) {
        for t in Toastify.toasts.Clone()
            if (t.tag == tag)
                t.StartExit()
    }
    static KillGroup(tag) {
        for t in Toastify.toasts.Clone()
            if (t.tag == tag)
                t.Dismiss(true)
        for t in Toastify.exitingToasts.Clone()
            if (t.tag == tag)
                t.Dismiss(true)
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
            ; Use target (final position) to resolve the monitor; fallback cursor
            ; (virtual coords safe: no A_ScreenWidth assumption, multi-monitor OK).
            refX := refT.targetX, refY := refT.targetY
            if (!(refX > 0)) {
                if (refT.currentX != 0 || refT.currentY != 0) {
                    refX := refT.currentX, refY := refT.currentY
                } else {
                    cp := ToastDPI.CursorPoint()
                    refX := cp.x, refY := cp.y
                }
            }
            wa := ToastDPI.WorkArea(refX, refY)
            dpi := ToastDPI.ForPoint(refX, refY)

; PR9: per-toast margin/spacing — group leader defines the layout
            mX := (group[1].marginX >= 0) ? group[1].marginX : Toastify.marginX
            mY := (group[1].marginY >= 0) ? group[1].marginY : Toastify.marginY
            sp := (group[1].spacing >= 0) ? group[1].spacing : Toastify.spacing
            marginX := ToastDPI.Px(mX, dpi)
            marginY := ToastDPI.Px(mY, dpi)
            spacing := ToastDPI.Px(sp, dpi)

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

            ; ── Overflow ──
            ; Antes los toasts que no entraban quedaban SIN target (targetX/Y=0)
            ; y AnimateIn() los hacía volar a (0,0) de la pantalla. Ahora siempre
            ; reciben target: se apilan pegados al borde que les corresponde.
            if (!isBottom && !isMidV) {
                cursor := wa.y + marginY
                maxY := wa.y + wa.h - marginY
                for idx, t in group {
                    y := (cursor + t.height > maxY) ? Max(wa.y + marginY, maxY - t.height) : cursor
                    targets.Push({ x: _getX(t, pos), y: y, gi: idx })
                    if (cursor + t.height <= maxY)
                        cursor += t.height + spacing
                }
            } else if (isBottom) {
                cursor := wa.y + wa.h - marginY
                loop total {
                    idx := total + 1 - A_Index
                    t := group[idx]
                    cursor -= t.height
                    if (cursor < wa.y + marginY)
                        cursor := wa.y + marginY
                    targets.Push({ x: _getX(t, pos), y: cursor, gi: idx })
                    cursor -= spacing
                }
            } else {
                totalH := 0
                for t in group
                    totalH += t.height + spacing
                totalH -= spacing
                cursor := Max(wa.y + marginY, waSCY - totalH // 2)
                maxY := wa.y + wa.h - marginY
                for idx, t in group {
                    y := (cursor + t.height > maxY) ? Max(wa.y + marginY, maxY - t.height) : cursor
                    targets.Push({ x: _getX(t, pos), y: y, gi: idx })
                    if (cursor + t.height <= maxY)
                        cursor += t.height + spacing
                }
            }

            for target in targets {
                t := group[target.gi]
                x := target.x
                y := target.y
                ; Per-toast DPI: the target may sit on another monitor than the
                ; leader (mixed-DPI setups). Fix up size once, not every frame.
                dpiAt := ToastDPI.ForPoint(x, y)
                if (dpiAt > 0 && t.dpi > 0 && dpiAt != t.dpi
                    && t.bufferWidth == t.width && t.bufferHeight == t.height) {
                    t._dpi := dpiAt
                    t._applyDpi()
                    t.ResizeBuffer(t.width, t.height)
                    t.Invalidate(false)
                }
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
                ; PR5: reduced-motion → reposition snaps instantly, no slide/pulse.
                if (animate && !Toastify.reducedMotion) {
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
            return 8
        progressOnly := false
        hasIndeterminate := false
        for t in Toastify.toasts {
            if (t.animState == "in" || t.repoActive || t._hoverOpacityActive)
                return 8
            if (t.HasProgress() && !t.progressPaused) {
                progressOnly := true
                if (t.indeterminate)
                    hasIndeterminate := true
            }
        }
        if (hasIndeterminate)
            return 8
        ; ponytail: determinate progress bar only needs ~30Hz → 33ms
        if (progressOnly)
            return 33
        ; ponytail: semi-idle 100ms; volver a 60Hz solo si hay animación/progreso vivo
        return 100
    }
    static FPS() {
        s := Toastify.__frameStats
        ; Coste real del frame + contadores de ULW (independientes del intervalo)
        cs := Toastify.__costStats
        costSum := 0.0
        for v in cs
            costSum += v
        costAvg := (cs.Length > 0) ? Round(costSum / cs.Length, 2) : 0
        if (s.Length < 2)
            return { fps: 0, avg: 0, p95: 0, max: 0, samples: s.Length
                , cost: costAvg, costMax: Round(Toastify.__costMax, 2), costSamples: cs.Length
                , ulw: Toastify.__ulwTotal }
        total := 0
        mx := 0.0
        for v in s {
            total += v
            mx := Max(mx, v)
        }
        avg := total / s.Length
        ; p95 sin ordenar: quickselect parcial O(n). FPS() es telemetría on-demand.
        k := Ceil(s.Length * 0.95)
        c := s.Clone()
        lo := 1, hi := c.Length
        while (lo < hi) {
            pivot := c[(lo + hi) // 2]
            i := lo, j := hi
            while (i <= j) {
                while (c[i] < pivot)
                    i++
                while (c[j] > pivot)
                    j--
                if (i <= j) {
                    tmp := c[i], c[i] := c[j], c[j] := tmp
                    i++, j--
                }
            }
            if (j < k)
                lo := i
            if (k < i)
                hi := j
        }
        return { fps: Round(1000 / avg, 1), avg: Round(avg, 2)
            , p95: Round(c[k], 2), max: Round(mx, 2), samples: s.Length
            , cost: costAvg, costMax: Round(Toastify.__costMax, 2), costSamples: cs.Length
            , ulw: Toastify.__ulwTotal }
    }
    ; Mide el COSTE del frame (QPC): __frameStats solo guarda el intervalo del
    ; timer. Sin esto "60 fps" no distingue un frame de 1ms de uno de 14ms.
    static __globalTick(*) {
        t0 := Toastify.__now()
        delay := Toastify.__tickBody()
        if (delay < 100)
            Toastify.__pushCost(Toastify.__now() - t0)
    }
    static __pushCost(v) {
        if (Toastify.__costStats.Length < 64)
            Toastify.__costStats.Push(v)
        else {
            Toastify.__costIdx := Mod(Toastify.__costIdx, 64)
            Toastify.__costStats[Toastify.__costIdx + 1] := v
            Toastify.__costIdx++
        }
        if (v > Toastify.__costMax)
            Toastify.__costMax := v
    }
    static __tickBody() {
        now := Toastify.__now()
        elapsed := now - Toastify.__lastTickTime
        Toastify.__lastTickTime := now
        delay := Toastify.__nextTickDelay()

        ; ── Idle: sin toasts, sin ventanas → apagar timer + period + prioridad ──
        if (Toastify.toasts.Length + Toastify.exitingToasts.Length + Toastify.registry.Count = 0
            && !Toastify._reflowNeeded) {
            Toastify.__setActive(false)
            return 100
        }
        ; ── All-static toasts: suspend the timer entirely → 0% CPU.
        ;    Woken by any mouse input (__wake). ponytail: watchdog/dead-window
        ;    cleanup only runs on wake or next show — acceptable for rare
        ;    permanent toasts; add a 1s low-freq timer if it ever matters.
        if (delay >= 100) {
            Toastify.__suspended := true
            if (Toastify.__active)
                Toastify.__setActive(false)
            return delay
        }
        Toastify.__suspended := false
        Toastify.__setActive(true)
        Toastify.__armedDelay := delay
        SetTimer(Toastify.__globalTimer, -delay)
        ; Tri-estado: semi-idle (100ms) → prioridad normal + liberar timer resolution
        Toastify.__setPerfMode(delay < 100)
        ; Telemetría: registrar solo frames rápidos (animación real)
        if (delay < 100) {
            if (Toastify.__frameStats.Length < 64)
                Toastify.__frameStats.Push(elapsed)
            else {
                Toastify.__frameStatsIdx := Mod(Toastify.__frameStatsIdx, 64)
                Toastify.__frameStats[Toastify.__frameStatsIdx + 1] := elapsed
                Toastify.__frameStatsIdx++
            }
        }

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

                ; Watchdog de tiempo de vida — lee duración LIVE del toast
                ; (P6: t.duration := 0 en caliente debe respetarse; el snapshot
                ; de registry queda obsoleto). autoDismiss=false → jamás se mata.
                t := (data.HasOwnProp("instance") && data.instance) ? data.instance : 0
                if (t && t.hovered && t.progressPaused && Toastify.hoverPauseEnabled)
                    continue
                if (t && t.autoDismiss && t.duration > 0) {
                    ; Margen sobre la salida natural (entrada + stagger + fill +
                    ; grace + exit): el watchdog solo mata toasts colgados, nunca
                    ; se adelanta a la salida por progreso.
                    expectedLifetime := t.animDuration + t.duration + t._stagger + Toast.progressGracePeriod + t.animDuration + 500
                    ; A_TickCount: mismo reloj que registry.startTime y que el exit loop.
                    ; QPC (__now) y A_TickCount tienen epochas distintas (wrap 49.7d) →
                    ; mezclarlos aquí mataba toasts ~5s antes de su lifetime real.
                    actualLifetime := A_TickCount - data.startTime
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
                    if (A_TickCount - data.startTime > data.duration + 1000)
                        if (Toastify.registry.Has(hwnd))
                            Toastify.registry.Delete(hwnd)
            }
            for hwnd in deadHwnds {
                t := Toastify.__toastByHwnd(hwnd)
                if (t)
                    t.Dismiss(true)
                if (Toastify.registry.Has(hwnd))
                    Toastify.registry.Delete(hwnd)
            }

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
                static ptHover := Buffer(8, 0)
                pt := ptHover
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
                        newStyle := DllCall("SetWindowLongPtr", "ptr", hwnd, "int", -16, "ptr", style, "ptr")
                        if (!newStyle && A_LastError)
                            DllCall("ShowWindow", "ptr", hwnd, "int", 9) ; SW_RESTORE fallback
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
        for t in Toastify.toasts.Clone() {
            if (t.animState == "out") {
                toastsToExit.Push(t)
                continue
            }
            try t.Tick()
        }
        for t in toastsToExit
            t.StartExit()

        removedAny := false
        i := 1
        while (i <= Toastify.exitingToasts.Length) {
            t := Toastify.exitingToasts[i]
            t.Tick()
            if (t.animState == "out" && (A_TickCount - t.animStartTime > t.animDuration)) {
                removedAny := true
                t.Dismiss(true, false)   ; reflow batched below (E6: O(n²)→O(n))
            } else
                i++
        }
        if (removedAny)
            Toastify.__reflow(true)

        if (Toastify._reflowNeeded) {
            Toastify.__reflow(true)
            Toastify._reflowNeeded := false
        }
        return delay
    }

    static __toastByHwnd(hwnd) {
        if (Toastify.registry.Has(hwnd))
            return Toastify.registry[hwnd].instance
        return 0
    }
    static __wake(*) {
        ; Re-arma el loop tras una suspensión (todo estático) o desde el modo
        ; semi-idle. NO re-arma si ya corre a máxima velocidad: cada
        ; WM_MOUSEMOVE (125-1000 Hz) reiniciaba el SetTimer antes de que
        ; disparara y podía hambrear el tick mientras el cursor estaba encima.
        if (!Toastify.__active && !Toastify.__suspended)
            return
        if (Toastify.__active && !Toastify.__suspended && Toastify.__armedDelay <= 8)
            return
        Toastify.__suspended := false
        Toastify.__lastTickTime := Toastify.__now()
        Toastify.__armedDelay := 8
        SetTimer(Toastify.__globalTimer, -8)
    }
    static __trackLeave(hwnd) {
        ; TRACKMOUSEEVENT: DWORD(4)+DWORD(4)+HWND(8)+DWORD(4) = 20 bytes,
        ; padded to sizeof = 24 on x64 (8-byte alignment from HWND).
        tr := Buffer(24, 0)
        NumPut("uint", 24, tr, 0)      ; cbSize = sizeof
        NumPut("uint", 2, tr, 4)        ; TME_LEAVE
        NumPut("ptr", hwnd, tr, 8)
        NumPut("uint", 0, tr, 16)       ; dwHoverTime
        DllCall("TrackMouseEvent", "ptr", tr)
    }
    static __onMouseMove(lParam, hwnd) {
        Toastify.__wake()
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
        Toastify.__wake()
        t := Toastify.__toastByHwnd(hwnd)
        if t
            t.OnMouseLeave()
    }

    ; ── WM_DPICHANGED: monitor scale changed while toast alive → re-apply
    ;    sizes from base config, resize buffers, reflow (P4) ──
    static __onDpiChanged(hwnd) {
        ToastDPI.ClearCache()
        t := Toastify.__toastByHwnd(hwnd)
        if !t
            return
        t._dpi := ToastDPI.ForWindow(hwnd)
        t._applyDpi()
        if (t.bufferWidth != t.width || t.bufferHeight != t.height)
            t.ResizeBuffer(t.width, t.height)
        t.Invalidate(false)
        t.Draw()
        Toastify.__reflow(true)
    }

    static __Click(wParam, lParam, msg, hwnd) {
        Toastify.__wake()
        ; O(1) por registry (antes recorría toasts + exitingToasts). El registry
        ; conserva la entrada hasta Dismiss(), así que cubre también la salida.
        t := Toastify.__toastByHwnd(hwnd)
        if !t
            return
        x := lParam & 0xFFFF
        y := (lParam >> 16) & 0xFFFF
        try t.OnClick(x, y)
    }
}
