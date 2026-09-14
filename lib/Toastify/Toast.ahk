class Toast {
    title := ""
    body := ""
    actions := []
    tag := ""
    priority := 0
    sound := ""
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
    indeterminate := false
    progressHeight := 0
    progressStriped := false
    stripeSpeed := 40
    stripeWidth := 3
    stripeSpacing := 8
    marginX := -1
    marginY := -1
    spacing := -1
    _stagger := 0
    ; true: la barra avanza al llegar a posición (tras entrada).
    ; false: avanza desde la creación; duration se clampa a entrada+salida (evita flicker).
    progressBarWaitPosition := true
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
    static _cfgKeys := ["width", "minHeight", "fontName", "fontSizeTitle", "fontSizeBody", "fontWeightTitle", "fontWeightBody",
        "paddingX", "paddingY", "iconSize", "iconScale", "designScale", "borderRadius", "borderWidth", "animDuration", "animEasing",
        "animStyle", "animEntrance", "renderQuality", "repoDuration", "rotationDegree", "progressHeight"]
    static _styleKeys := ["fontName", "fontSizeTitle", "fontSizeBody", "fontWeightTitle", "fontWeightBody",
        "paddingX", "paddingY", "iconSize", "iconScale", "designScale", "borderRadius", "borderWidth", "animDuration", "renderQuality",
        "rotationDegree", "progressHeight"]
    pBitmapCache := 0
    GCache := 0
    cacheDirty := true
    _progressBgSnapshot := 0

    ; ── Progress overlay: small bitmap, only it gets redrawn ──
    _progressBitmap := 0
    _GProgress := 0
    _gProgressSmoothSet := false
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
    repoEasing := ""
    repoAnimStyle := 0
    repoActive := false
    _repoHasSlide := false
    _repoHasFade := false
    _repoHasZoom := false
    _repoHasRotate := false
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
    _lastDrawnProgress := -1
    _lastProgressDraw := 0
    _easingFn := 0
    _easingName := ""
    _repoEasingFn := 0
    _repoEasingName := ""
    _stripePen := 0
    _stripePenW := 0
    creationTime := 0
    clickRegions := []
    hovered := false
    closeHovered := false
    onClickCallback := 0
    onCloseCallback := 0
    userInitiatedExit := false
    autoDismiss := true
    progressCompleteTime := 0
    static progressGracePeriod := 500
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
                if opts.HasProp("progressBarWaitPosition")
                    this.progressBarWaitPosition := opts.progressBarWaitPosition
                if opts.HasProp("onClick")
                    this.onClickCallback := opts.onClick
                if opts.HasProp("onClose")
                    this.onCloseCallback := opts.onClose
                if opts.HasProp("opacity")
                    this._baseOpacity := opts.opacity
                if opts.HasProp("opacityOnHover")
                    this.opacityOnHover := !!opts.opacityOnHover
                if opts.HasProp("tag")
                    this.tag := opts.tag
                if opts.HasProp("priority")
                    this.priority := opts.priority
                if opts.HasProp("sound")
                    this.sound := opts.sound
                if opts.HasProp("indeterminate") {
                    this.indeterminate := !!opts.indeterminate
                    if (this.indeterminate) {
                        this.showProgress := true
                        this.autoDismiss := false
                        this.progressBarWaitPosition := false
                    }
                }
                if opts.HasProp("marginX")
                    this.marginX := opts.marginX
                if opts.HasProp("marginY")
                    this.marginY := opts.marginY
                if opts.HasProp("spacing")
                    this.spacing := opts.spacing
                if opts.HasProp("progressStriped")
                    this.progressStriped := !!opts.progressStriped
                if opts.HasProp("stripeSpeed")
                    this.stripeSpeed := opts.stripeSpeed
                if opts.HasProp("stripeWidth")
                    this.stripeWidth := opts.stripeWidth
                if opts.HasProp("stripeSpacing")
                    this.stripeSpacing := opts.stripeSpacing
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
                if opts.HasProp("repoEasing")
                    this.repoEasing := opts.repoEasing
                else
                    this.repoEasing := Toastify.config.repoEasing
            }
            try {
                if opts.HasProp("repoDuration")
                    this.repoDuration := opts.repoDuration
                else
                    this.repoDuration := Toastify.config.repoDuration
            }
            try {
                if opts.HasProp("repoAnimStyle")
                    this.repoAnimStyle := opts.repoAnimStyle
                else
                    this.repoAnimStyle := Toastify.config.repoAnimStyle
            }
            if Type(this.repoAnimStyle) == "String"
                this.repoAnimStyle := [this.repoAnimStyle]
            else if !HasProp(this.repoAnimStyle, "Length")
                this.repoAnimStyle := ["slide"]
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
        ; progressBarWaitPosition=false: la barra corre desde la creación, pero
        ; nunca puede terminar antes de entrada+salida (flicker).
        if (this.showProgress && this.duration > 0 && !this.progressBarWaitPosition && !this.indeterminate)
            this.duration := Max(this.duration, 2 * this.animDuration)
        ; DPI of the destination monitor, computed by __createToast (opts.dpi).
        this._dpi := (IsObject(opts) && opts.HasProp("dpi")) ? opts.dpi : ToastDPI.Primary()
        this._saveBaseCfg()
        this.__createWindow()
    }

    __createBgBrush(pal) {
        ; T4: gradientType "linear" (default) | "radial"; gradientAngle (deg,
        ; 90 = top→bottom, current default). Raw DllCall — wrapper lacks
        ; radial/with-angle creators. Fallback linear on any failure.
        rect := Buffer(16, 0)
        NumPut("float", 0, rect, 0)
        NumPut("float", 0, rect, 4)
        NumPut("float", this.width, rect, 8)
        NumPut("float", this.height, rect, 12)
        gradType := pal.HasOwnProp("gradientType") ? pal.gradientType : "linear"
        if (gradType = "radial") {
            ; Radial: esta gdiplus no exporta GdipCreatePathGradientBrush →
            ; se hornea un bitmap de anillos concéntricos en __initThemeCache.
            ; Acá solo devolvemos el color interior como base.
            return Gdip_BrushCreateSolid(pal.bg1 & 0xFFFFFF)
        } else {
            angle := pal.HasOwnProp("gradientAngle") ? pal.gradientAngle : 90
            if (angle != 90) {
                hBrush := 0
                hr := DllCall("gdiplus\GdipCreateLineBrushFromRectWithAngle", "ptr", rect
                    , "uint", pal.bg1, "uint", pal.bg2, "float", angle, "int", 0, "int", 1, "ptr*", &hBrush)
                if (hr = 0 && hBrush)
                    return hBrush
            }
        }
        return Gdip_CreateLineBrushFromRect(0, 0, this.width, this.height, pal.bg1, pal.bg2, 1, 1)
    }
    __deleteThemeCache() {
        if (this._bgBrush) {
            Gdip_DeleteBrush(this._bgBrush)
            this._bgBrush := 0
        }
        if (this._bgRadialBitmap) {
            Gdip_DisposeImage(this._bgRadialBitmap)
            this._bgRadialBitmap := 0
        }
        if (this._shadowBitmap) {
            Gdip_DisposeImage(this._shadowBitmap)
            this._shadowBitmap := 0
        }
        if (this._customBorderPen) {
            Gdip_DeletePen(this._customBorderPen)
            this._customBorderPen := 0
        }
        this._bgBrushTheme := ""
    }

    __initThemeCache(pal) {
        this._bgBrush := this.__createBgBrush(pal)
        if (!this._bgBrush)
            this._bgBrush := Gdip_BrushCreateSolid(pal.bg1 & 0xFFFFFF)
        this._bgBrushTheme := this.theme

        ; ── Radial baked bitmap (anillos concéntricos bg1 centro → bg2 borde) ──
        if (pal.HasOwnProp("gradientType") && pal.gradientType = "radial") {
            this._bgRadialBitmap := Gdip_CreateBitmap(this.width, this.height)
            G := Gdip_GraphicsFromImage(this._bgRadialBitmap)
            Gdip_SetSmoothingMode(G, 2)
            w := this.width, h := this.height
            steps := 14
            cx := w / 2, cy := h / 2
            maxR := Sqrt(cx * cx + cy * cy)
            c1 := pal.bg1 & 0xFFFFFF, c2 := pal.bg2 & 0xFFFFFF
            loop steps {
                t := (A_Index - 1) / (steps - 1)
                r := maxR * (1 - (A_Index - 1) / steps)
                r2 := Max(1, r + maxR / steps)
                col := 0xFF000000
                col |= Round((((c1 >> 16) & 0xFF) * (1 - t) + ((c2 >> 16) & 0xFF) * t)) << 16
                col |= Round((((c1 >> 8) & 0xFF) * (1 - t) + ((c2 >> 8) & 0xFF) * t)) << 8
                col |= Round(((c1 & 0xFF) * (1 - t) + (c2 & 0xFF) * t))
                br := Gdip_BrushCreateSolid(col)
                Gdip_FillEllipse(G, br, cx - r2, cy - r2, 2 * r2, 2 * r2)
                Gdip_DeleteBrush(br)
            }
            Gdip_DeleteGraphics(G)
        } else
            this._bgRadialBitmap := 0

        ; ── FX1/FX2: sombra suave horneada en bitmap (anillos concéntricos,
        ;    alpha falloff). 1 DrawImage por frame, no N fills. ──
        base := pal.shadow & 0xFFFFFF
        ba := (pal.shadow >> 24) & 0xFF
        layers := pal.HasOwnProp("glow") && pal.glow ? 7 : 5
        spread := pal.HasOwnProp("glow") && pal.glow ? 2.2 : 1.4
        d := this.dpiFactor
        this._shadowBitmap := Gdip_CreateBitmap(this.width, this.height)
        G := Gdip_GraphicsFromImage(this._shadowBitmap)
        Gdip_SetSmoothingMode(G, 2)
        loop layers {
            k := A_Index - 1
            a := Floor(ba * (0.72 - 0.55 * k / Max(1, layers - 1)))
            a := Max(3, Min(255, a))
            o := (2 + k * spread * 0.6) * d
            r := this.borderRadius + 2 * k * d
            br := Gdip_BrushCreateSolid((a << 24) | base)
            Gdip_FillRoundedRectangle(G, br, o, o, this.width - 2 * o, this.height - 2 * o, r)
            Gdip_DeleteBrush(br)
        }
        Gdip_DeleteGraphics(G)

        ; 4) Custom border pen. Width scaled, always created: centered pen
        ;    straddles the path, so path must be inset by half the pen width
        ;    to keep the full stroke inside the bitmap.
        if (this.borderWidth > 0)
            this._borderPenW := this.borderWidth
        else
            this._borderPenW := Round(pal.borderWidth * this.dpiFactor * this._baseCfg.designScale)
        this._customBorderPen := Gdip_CreatePen(pal.border, this._borderPenW)
        this._customBorderTheme := this.theme
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
        if (this.HasProgress())
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
        if (tmpG)
            Gdip_DeleteGraphics(tmpG)
        if (tmpBmp)
            Gdip_DisposeImage(tmpBmp)
        titleBoxH := (this.title = "") ? 0 : Max(this.fontSizeTitle * 1.5, titleH)
        this._titleH := titleH
        bodyY := this.paddingY + titleBoxH + (this.title = "" ? 0 : 4 * d)
        h := bodyY + bodyH + this.paddingY + extras
        if (this.icon != "" && this.icon != "none")
            h := Max(h, this.iconSize * this.iconScale + this.paddingY + extras)
        return Ceil(h)
    }
    static _fontCache := Map()
    static _famCache := Map()
    static _fmtCache := Map()
    static __font(family, size, style) {
        key := family "|" size "|" style
        if Toast._fontCache.Has(key)
            return Toast._fontCache[key]
        hFam := Toast.__family(family)
        if !hFam
            return 0
        h := Gdip_FontCreate(hFam, size, style)
        if h
            Toast._fontCache[key] := h
        return h
    }
    static __family(family) {
        if Toast._famCache.Has(family)
            return Toast._famCache[family]
        h := Gdip_FontFamilyCreate(family)
        if h
            Toast._famCache[family] := h
        return h
    }
    static __format(flags) {
        if Toast._fmtCache.Has(flags)
            return Toast._fmtCache[flags]
        h := Gdip_StringFormatCreate(flags)
        if h
            Toast._fmtCache[flags] := h
        return h
    }
    static FreeFontCache() {
        for k, h in Toast._fontCache
            Gdip_DeleteFont(h)
        for k, h in Toast._famCache
            Gdip_DeleteFontFamily(h)
        for k, h in Toast._fmtCache
            Gdip_DeleteStringFormat(h)
        Toast._fontCache := Map()
        Toast._famCache := Map()
        Toast._fmtCache := Map()
    }
    __measureTextH(G, text, w, fontSize, weight) {
        if (!G)
            return 0
        style := (weight = "Bold") ? 1 : (weight = "Italic") ? 2 : (weight = "BoldItalic") ? 3 : 0
        hFont := Toast.__font(this.fontName, fontSize, style)
        if (!hFont)
            return 0
        hFmt := Toast.__format(0x4000)
        layout := Buffer(16)
        NumPut("float", 0, layout, 0)
        NumPut("float", 0, layout, 4)
        NumPut("float", w, layout, 8)
        NumPut("float", 10000, layout, 12)
        ms := Gdip_MeasureString(G, text, hFont, hFmt, &layout)
        h := IsObject(ms) ? 0 : Ceil(StrSplit(ms, "|")[4])
        return h
    }
    _saveBaseCfg() {
        ; Keeps a copy of the design values at 96 DPI
        ; (as they arrived from ToastConfig/opts) without scaling.
        this._baseCfg := {
            width: this.width,
            minHeight: this.minHeight,
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
        Gdip_SetInterpolationMode(this.G, 6)

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
        if (this._progressBgSnapshot) {
            Gdip_DisposeImage(this._progressBgSnapshot)
            this._progressBgSnapshot := 0
        }
        ; FX1: sombra suave horneada (blit 1:1, sin scale)
        if (this._shadowBitmap)
            Gdip_DrawImage(this.GCache, this._shadowBitmap, 0, 0, this.width, this.height
                , 0, 0, this.width, this.height)
        ; Fill + border share ONE path with identical coordinates. Path inset by
        ; half the pen width so the centered pen stroke stays fully inside the
        ; bitmap (no clipping on straight edges or corner arcs).
        bw := this._borderPenW
        p := Gdip_CreatePath()
        Gdip_AddPathRoundedRect(p, bw / 2, bw / 2, this.width - bw, this.height - bw, this.borderRadius)
        Gdip_FillPath(this.GCache, this._bgBrush, p)
        if (this._bgRadialBitmap) {
            Gdip_SetClipPath(this.GCache, p, 0)
            Gdip_DrawImage(this.GCache, this._bgRadialBitmap, 0, 0, this.width, this.height)
            Gdip_ResetClip(this.GCache)
        }
        if (bw > 0)
            Gdip_DrawPath(this.GCache, this._customBorderPen, p)
        Gdip_DeletePath(p)

        iconX := this.paddingX
        iconSize := this.iconSize * this.iconScale
        textStartX := this.paddingX
        if (this.icon != "" && this.icon != "none") {
            bodyY := (this.title != "") ? (this.paddingY + Max(this.fontSizeTitle * 1.5, this._titleH) + 4 * d) : this.paddingY
            avail := this.height - bodyY - this.paddingY
            if (this.actions.Length > 0)
                avail -= 38 * d
            if (this.HasProgress())
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

        if (this.HasProgress()) {
            this.__ensureProgressBitmap()
            this.__captureProgressBgSnapshot()
            this.__drawProgress()
        }
        this._dirtyRect := "full"
    }

    __ensureProgressBitmap() {
        if (this._progressBitmap)
            return
        d := this.dpiFactor
        ph := (this.progressHeight > 0) ? this.progressHeight : Toastify.config.progressHeight
        this._progressW := this.width - 28 * d
        this._progressH := Max(1, Round(ph * d))
        this._progressBitmap := Gdip_CreateBitmap(this._progressW, this._progressH)
        if (!this._progressBitmap)
            return
        this._GProgress := Gdip_GraphicsFromImage(this._progressBitmap)
        this.__applyRenderQuality(this._GProgress, true)
    }

    __captureProgressBgSnapshot() {
        if (!this._progressBitmap)
            return
        if (!this._progressBgSnapshot)
            this._progressBgSnapshot := Gdip_CreateBitmap(this._progressW, this._progressH)
        pal := ToastTheme.palette(this.theme)
        d := this.dpiFactor
        px := 14 * d
        py := this.height - this._progressH - 7 * d

        ; Bake TRACK once onto GCache directly at real position (horneado en snapshot).
        Gdip_FillRoundedRectangle(this.GCache, pal.progressBgBrush, px, py, this._progressW, this._progressH, 2 * d)

        GSnap := Gdip_GraphicsFromImage(this._progressBgSnapshot)
        try {
            DllCall("gdiplus\GdipSetCompositingMode", "ptr", GSnap, "int", 1)
            Gdip_DrawImage(GSnap, this.pBitmapCache, 0, 0, this._progressW, this._progressH
                , px, py, this._progressW, this._progressH)
        } finally {
            try Gdip_DeleteGraphics(GSnap)
        }
    }

    __drawProgress() {
        if (!this.HasProgress())
            return
        if (this.progress = this._lastDrawnProgress)
            return
        this._lastDrawnProgress := this.progress
        pal := ToastTheme.palette(this.theme)
        d := this.dpiFactor
        this.__ensureProgressBitmap()

        if (!this._gProgressSmoothSet) {
            Gdip_SetSmoothingMode(this._GProgress, 1)
            this._gProgressSmoothSet := true
        }

        Gdip_GraphicsClear(this._GProgress, 0x00000000)
        if (this.indeterminate) {
            ; sliding window 35% ancho — ojo traquea objeto → más fluido que fill 0→W
            blockW := this._progressW * 0.35
            x := (this._progressW - blockW) * this.progress
            r := 2 * d
            Gdip_FillRoundedRectangle(this._GProgress, pal.progressFillBrush, x, 0, blockW, this._progressH, r)
        } else if (this.progress > 0) {
            fillWidth := this._progressW * this.progress
            r := 2 * d
            if (fillWidth > r)
                Gdip_FillRectangle(this._GProgress, pal.progressFillBrush, r, 0, fillWidth - r, this._progressH)
            Gdip_FillRoundedRectangle(this._GProgress, pal.progressFillBrush, 0, 0, Min(fillWidth, r), this._progressH, r)
            ; FX5: diagonal stripes con movimiento marquee infinito (opt-in progressStriped)
            if (this.progressStriped && this.stripeSpacing > 0) {
                penW := this.stripeWidth * d
                if (!this._stripePen || this._stripePenW != penW) {
                    if (this._stripePen)
                        Gdip_DeletePen(this._stripePen)
                    this._stripePen := Gdip_CreatePen(0x26FFFFFF, penW)
                    this._stripePenW := penW
                }
                off := Mod((A_TickCount - this.progressStartTime) * this.stripeSpeed / 1000, this.stripeSpacing)
                loop Ceil(fillWidth / (this.stripeSpacing * d)) + 1 {
                    sx := (A_Index - 1) * this.stripeSpacing * d - off * d
                    Gdip_DrawLine(this._GProgress, this._stripePen, sx, 0, sx + this._progressH, this._progressH)
                }
            }
        }
        px := 14 * d
        py := this.height - this._progressH - 7 * d
        if (this._progressBgSnapshot) {
            DllCall("gdiplus\GdipSetCompositingMode", "ptr", this.GCache, "int", 1)
            Gdip_DrawImage(this.GCache, this._progressBgSnapshot, px, py, this._progressW, this._progressH
                , 0, 0, this._progressW, this._progressH)
            DllCall("gdiplus\GdipSetCompositingMode", "ptr", this.GCache, "int", 0)
        }
        Gdip_DrawImage(this.GCache, this._progressBitmap, px, py, this._progressW, this._progressH
            , 0, 0, this._progressW, this._progressH)
        this._dirtyRect := { x: px, y: py, w: this._progressW, h: this._progressH }
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
            bodyY := (this.title != "") ? (this.paddingY + Max(this.fontSizeTitle * 1.5, this._titleH) + 4 * d) : this.paddingY
            availableHeight := this.height - bodyY - this.paddingY
            if (this.actions.Length > 0)
                availableHeight -= 38 * d
            if (this.HasProgress())
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
            btnFg := ToastTheme.onAccent(pal.accent)
            ; Custom buttons: measure each label → width by text, no wrap.
            ; If the row doesn't fit, shrink the button font (one pass).
            hFmt := Toast.__format(0x1000)
            layout := Buffer(16)
            NumPut("float", 0, layout, 0)
            NumPut("float", 0, layout, 4)
            NumPut("float", 10000, layout, 8)
            NumPut("float", 10000, layout, 12)
            btnFont := this.fontSizeBody
            availW := this.width - 32 * d - (this.actions.Length - 1) * 8 * d
            if (this.actions.Length = 0 || availW <= 0)
                return
            loop {
                widths := []
                total := 0
                for act in this.actions {
                    label := act.HasProp("text") ? act.text : act[1]
                    hFont := Toast.__font(font, btnFont, 1)
                    ms := Gdip_MeasureString(this._GText, label, hFont, hFmt, &layout)
                    w := Ceil(Number(StrSplit(ms, "|")[3])) + 20 * d
                    widths.Push(w)
                    total += w
                }
                if (total <= availW || btnFont <= 8)
                    break
                if (total <= 0)
                    break
                btnFont := Max(8, Floor(btnFont * availW / total))
            }
            leftover := Max(0, availW - total)
            factor := (total > availW && total > 0) ? (availW / total) : 1
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
        compositeDone := false    ; frame recomposed
        drawX := (this.bufferWidth - this.width) / 2
        drawY := (this.bufferHeight - this.height) / 2
        if (this.scale != 1.0 || this.rotation != 0) {
            if (this.scale < 0.01) {
                this.UpdateWindow(this.currentX, this.currentY, 0)
                return
            }
            Gdip_GraphicsClear(this.G, 0x00000000)
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
            this._dirtyRect := "full"
        } else if (this._dirtyRect) {
            if (this._dirtyRect = "full") {
                Gdip_GraphicsClear(this.G, 0x00000000)
                Gdip_DrawImage(this.G, this.pBitmapCache, drawX, drawY, this.width, this.height, 0, 0, this.width, this.height)
            } else {
                r := this._dirtyRect
                DllCall("gdiplus\GdipSetCompositingMode", "ptr", this.G, "int", 1)
                Gdip_DrawImage(this.G, this.pBitmapCache, drawX + r.x, drawY + r.y, r.w, r.h, r.x, r.y, r.w, r.h)
                DllCall("gdiplus\GdipSetCompositingMode", "ptr", this.G, "int", 0)
            }
            compositeDone := true
            this._dirtyRect := false
        }

        alpha := Floor(this.opacity * 255)
        alpha := Max(0, Min(255, alpha))
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
        if (alpha = -1)
            alpha := Floor(this.opacity * 255)
        ; Negative alpha (elastic/back easing dips) wraps the BLENDFUNCTION
        ; AlphaFormat byte → ULW ignores per-pixel alpha → opaque black flash.
        alpha := Max(0, Min(255, alpha))
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
        ; Dot radius scales with DPI (was hardcoded 2px → thin at 200%)
        dot := Max(3 * this.dpiFactor, size * 0.125)
        switch iconType {
            case "success":
                Gdip_FillEllipse(this.GCache, pal.accentBrush, x, y, size, size)
                points := x "," (y + size / 2) "|" (x + size / 3) "," (y + size * 2 / 3) "|" (x + size * 4 / 5) "," (y +
                    size / 4)
                Gdip_DrawLines(this.GCache, pal.iconFgPen, points)
            case "error":
                Gdip_FillEllipse(this.GCache, pal.accentBrush, x, y, size, size)
                Gdip_DrawLine(this.GCache, pal.iconFgPen, x + size / 4, y + size / 4, x + size * 3 / 4, y + size * 3 / 4)
                Gdip_DrawLine(this.GCache, pal.iconFgPen, x + size * 3 / 4, y + size / 4, x + size / 4, y + size * 3 / 4)
            case "warning":
                points := (x + size / 2) "," y "|" x "," (y + size) "|" (x + size) "," (y + size)
                Gdip_FillPolygon(this.GCache, pal.accentBrush, points)
                Gdip_DrawLine(this.GCache, pal.iconFgPen2, x + size / 2, y + size / 4, x + size / 2, y + size / 2)
                Gdip_FillEllipse(this.GCache, pal.iconFgBrush, x + size / 2 - dot / 2, y + size * 2 / 3, dot, dot)
            case "info":
                Gdip_FillEllipse(this.GCache, pal.accentBrush, x, y, size, size)
                Gdip_FillEllipse(this.GCache, pal.iconFgBrush, x + size / 2 - dot / 2, y + size / 4, dot, dot)
                Gdip_DrawLine(this.GCache, pal.iconFgPen2, x + size / 2, y + size / 2.5, x + size / 2, y + size * 3 / 4)
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
        if (this._closeHoveredRendered == this.closeHovered
            && this._closeRenderedTheme == this.theme)
            return
        this._closeHoveredRendered := this.closeHovered
        this._closeRenderedTheme := this.theme
        Gdip_GraphicsClear(this._GClose, 0x00000000)
        accent := pal.accent & 0xFFFFFF
        if (this.closeHovered) {
            circleCol := 0xFF000000 | accent
            glyphCol := Format("{:x}", ToastTheme.onAccent(pal.accent))
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
        hFont := Toast.__font(Toast.__iconFontName(), s, 0)
        hFmt := Toast.__format(0x1000)
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
        this._dirtyRect := "full"
        this.Draw()
    }

    static __resolveEntrance(pos) {
        if (InStr(pos, "right"))
            return "right"
        if (InStr(pos, "left"))
            return "left"
        if (InStr(pos, "top"))
            return "top"
        return "bottom"
    }
    HasAnim(name) {
        for style in this.animStyle
            if (style == name)
                return true
        return false
    }
    HasRepoAnim(name) {
        for style in this.repoAnimStyle
            if (style == name)
                return true
        return false
    }
    __updateRepoFlags() {
        this._repoHasSlide := this.HasRepoAnim("slide")
        this._repoHasFade := this.HasRepoAnim("fade")
        this._repoHasZoom := this.HasRepoAnim("zoom")
        this._repoHasRotate := this.HasRepoAnim("rotate")
    }
    HasProgress() => this.showProgress && (this.duration > 0 || this.indeterminate)
    AnimateIn() {
        this._hasSlide := this.HasAnim("slide")
        this._hasFade := this.HasAnim("fade")
        this._hasZoom := this.HasAnim("zoom")
        this._hasRotate := this.HasAnim("rotate")
        this.__updateRepoFlags()
        ; PR5: reduced motion → land instantly, no animation
        if (Toastify.reducedMotion) {
            this._hasSlide := this._hasFade := this._hasZoom := this._hasRotate := false
            this.animState := "visible"
            this.currentX := this.targetX
            this.currentY := this.targetY
            this.opacity := this._baseOpacity
            this.scale := 1
            this.rotation := 0
            this._initialized := true
            this.progressStartTime := A_TickCount
            this.__playSound()
            return
        }
        if (this._repoHasRotate || this._hasZoom) {
            safetyFactor := 1.15
            diag := Sqrt(this.width ** 2 + this.height ** 2) * safetyFactor
            this.ResizeBuffer(Ceil(diag), Ceil(diag))
        }
        this.resolvedEntrance := this.animEntrance
        if (this.resolvedEntrance == "auto")
            this.resolvedEntrance := Toast.__resolveEntrance(this.position)

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
        this.opacity := this._hasFade ? 0 : this._baseOpacity
        this.scale := this._hasZoom ? 0.5 : 1
        this.rotation := this._hasRotate ? this.rotationDegree : 0
        this.animState := "in"
        this.animStartTime := A_TickCount + this._stagger
        this._initialized := true
        this.__playSound()
    }
    __playSound() {
        ; PR1: system sound by alias, e.g. "SystemAsterisk", "SystemExclamation"
        if (this.sound = "")
            return
        DllCall("winmm\PlaySoundW", "wstr", this.sound, "ptr", 0, "uint", 0x10001)
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
        ; Repos easing: per-toast repoEasing, else inherit the entrance easing.
        repoEase := (this.repoEasing != "") ? this.repoEasing : Toastify.config.repoEasing
        if (repoEase = "")
            repoEase := this.animEasing
        if (this._repoEasingFn = 0 || this._repoEasingName != repoEase) {
            this._repoEasingFn := ToastEasing.resolve(repoEase)
            this._repoEasingName := repoEase
        }
        eased := this._repoEasingFn.Call(ToastEasing, rp)
        this.currentX := this.repoStartX + (this.repoTargetX - this.repoStartX) * eased
        this.currentY := this.repoStartY + (this.repoTargetY - this.repoStartY) * eased
        ; Repos reposition gains the toast's animation style: the position slide
        ; always runs (repos is a move), plus a brief pulse for zoom/rotate/fade
        ; so it matches the entrance's visual character. Pulse peaks at the
        ; midpoint and returns to rest at the end (no jump). Gating on _has*
        ; reuses the flags set by AnimateIn; opacity pulse skips when
        ; opacityOnHover owns opacity (else the visible-block hover code fights it).
        pp := 4 * rp * (1 - rp)
        if (this._repoHasZoom)
            this.scale := 1 + 0.06 * pp
        if (this._repoHasRotate && this.rotationDegree > 0)
            this.rotation := 3 * pp
        if (this._repoHasFade && !this.opacityOnHover)
            this.opacity := this._baseOpacity * (1 - 0.18 * pp)
        if (rp >= 1.0) {
            this.repoActive := false
            this.currentX := this.repoTargetX
            this.currentY := this.repoTargetY
            this.scale := 1.0
            this.rotation := 0
            if (this._repoHasFade && !this.opacityOnHover)
                this.opacity := this._baseOpacity
        }
        }

        ; ── 2) Entrance animation ──
        if (this.animState == "in") {
            ; FX6: stagger hold — sit at start position until the delay elapses
            if (now < this.animStartTime) {
                this.Draw()
                return
            }
            elapsed := now - this.animStartTime
            progress := Min(1.0, elapsed / Max(1, this.animDuration))
            if (this._easingFn = 0 || this._easingName != this.animEasing) {
                this._easingFn := ToastEasing.resolve(this.animEasing)
                this._easingName := this.animEasing
            }
            eased := this._easingFn.Call(ToastEasing, progress)
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
                if (this.indeterminate)
                    this.progressStartTime := Toastify.__now()
                else if (this.progressBarWaitPosition)
                    this.progressStartTime := now
                else
                    this.progressStartTime := this.creationTime + this._stagger
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
            if (this._easingFn = 0 || this._easingName != this.animEasing) {
                this._easingFn := ToastEasing.resolve(this.animEasing)
                this._easingName := this.animEasing
            }
            eased := this._easingFn.Call(ToastEasing, progress)
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
                    k := 1 - (1 - e) * (1 - e) * (1 - e)
                    this.opacity := this._hoverOpacityFrom + (this._hoverOpacityTarget - this._hoverOpacityFrom) * k
                    if (e >= 1.0) {
                        this._hoverOpacityActive := false
                        this.opacity := this._hoverOpacityTarget
                    }
                    this.Draw()
                    drew := true
                }
            }
            if (this.HasProgress() && !this.progressPaused) {
                if (this.indeterminate) {
                    elapsed := Toastify.__now() - this.progressStartTime
                    phase := Mod(elapsed, 1600) / 1600
                    p := (phase < 0.5) ? phase * 2 : 2 * (1 - phase)
                    this.progress := p
                } else {
                    elapsed := now - this.progressStartTime
                    this.progress := Min(1.0, elapsed / this.duration)
                }
                diff := Abs(this.progress - this.lastProgress)
                animating := this.indeterminate || this.progressStriped
                qnow := Toastify.__now()
                needsDraw := animating ? (qnow - this._lastProgressDraw >= 8)
                    : (diff > 0.005 && (this.progress >= 1.0 || qnow - this._lastProgressDraw >= 33))
                if (needsDraw) {
                    this._lastProgressDraw := qnow
                    this.lastProgress := this.progress
                    ; Solo se redibuja el overlay de la barra (no el cache completo)
                    this.__drawProgress()
                    this.Draw()
                    drew := true
                }
                if (this.progress >= 1.0 && this.autoDismiss) {
                    if (!this.progressCompleteTime)
                        this.progressCompleteTime := now
                    else if (now - this.progressCompleteTime > Toast.progressGracePeriod)
                        this.StartExit()
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
        ; Repo fights exit: Tick applies repo before the out branch, so kill it
        ; here or exit jitters toward the stale repo target for 1 frame.
        this.repoActive := false
        this.scale := 1.0
        this.rotation := 0
        this.progressCompleteTime := 0
        if ((this._hasRotate || this._hasZoom) && this.bufferWidth == this.width && this.bufferHeight == this.height) {
            safetyFactor := 1.15
            diag := Sqrt(this.width ** 2 + this.height ** 2) * safetyFactor
            this.ResizeBuffer(Ceil(diag), Ceil(diag))
        }
        ; Anchor the exit work area to the settled target, not to current:
        ; mid-entrance current is off-screen → NEAREST returns the neighbor
        ; monitor and the toast flies across screens.
        waX := (this.targetX != 0 || this.targetY != 0) ? this.targetX : this.currentX
        waY := (this.targetX != 0 || this.targetY != 0) ? this.targetY : this.currentY
        wa := ToastDPI.WorkArea(waX, waY)
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
        if (!wasHovered && Toastify.hoverPauseEnabled && this.autoDismiss && this.duration > 0 && !this.indeterminate) {
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
        static ptLeave := Buffer(8, 0)
        pt := ptLeave
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
        if (this.autoDismiss && this.duration > 0 && !this.indeterminate) {
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
    ; ── Live style changes (fontSize, padding, width…): re-render + reflow ──
    ;    P5: _textRendered cache must be invalidated; AHKv2 has no property
    ;    setters, so the user calls t.Invalidate() after mutating props.
    Invalidate(remeasure := true) {
        this.cacheDirty := true
        this._textRendered := false
        this._closeHoveredRendered := -1
        this._dirtyRect := "full"
        if (remeasure && this._initialized)
            this.height := Max(Toastify.config.minHeight, this.__autoHeight())
        if (this.animState == "visible" && !this.repoActive
            && (this.bufferWidth != this.width || this.bufferHeight != this.height))
            this.ResizeBuffer(this.width, this.height)
        this._lastAlpha := -1
        this._lastRenderX := -999999
        this._lastRenderY := -999999
        Toastify._reflowNeeded := true
        Toastify.__wake()
    }
    Dismiss(instant := false, reflow := true) {
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
        if (reflow)
            Toastify.__reflow(true)
    }
    ResizeBuffer(newW, newH) {
        if (newW == this.bufferWidth && newH == this.bufferHeight)
            return

        ; Release previous presentation resources
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
        ; Derivative caches are sized to width×height: drop them here so a
        ; DPI change / rotate-expand never leaves stale-size bitmaps behind
        ; (leak + clipped drawing). __drawCache rebuilds them lazily.
        this.__deleteThemeCache()
        if (this.GCache) {
            Gdip_DeleteGraphics(this.GCache)
            this.GCache := 0
        }
        if (this.pBitmapCache) {
            Gdip_DisposeImage(this.pBitmapCache)
            this.pBitmapCache := 0
        }
        if (this._GText) {
            Gdip_DeleteGraphics(this._GText)
            this._GText := 0
        }
        if (this._textBitmap) {
            Gdip_DisposeImage(this._textBitmap)
            this._textBitmap := 0
        }
        if (this._GProgress) {
            Gdip_DeleteGraphics(this._GProgress)
            this._GProgress := 0
        }
        if (this._progressBitmap) {
            Gdip_DisposeImage(this._progressBitmap)
            this._progressBitmap := 0
        }
        if (this._progressBgSnapshot) {
            Gdip_DisposeImage(this._progressBgSnapshot)
            this._progressBgSnapshot := 0
        }
        if (this._GClose) {
            Gdip_DeleteGraphics(this._GClose)
            this._GClose := 0
        }
        if (this._closeBitmap) {
            Gdip_DisposeImage(this._closeBitmap)
            this._closeBitmap := 0
        }
        if (this._stripePen) {
            Gdip_DeletePen(this._stripePen)
            this._stripePen := 0
            this._stripePenW := 0
        }

        ; Create new buffer
        this.bufferWidth := newW
        this.bufferHeight := newH
        this.hbm := CreateDIBSection(newW, newH)
        this.hdc := CreateCompatibleDC()
        this.obm := SelectObject(this.hdc, this.hbm)
        this.G := Gdip_GraphicsFromHDC(this.hdc)
        this.__applyRenderQuality(this.G, false)
        Gdip_SetInterpolationMode(this.G, 6)
        ; Recreate the content cache at content size (not the expanded diag)
        this.pBitmapCache := Gdip_CreateBitmap(this.width, this.height)
        this.GCache := Gdip_GraphicsFromImage(this.pBitmapCache)
        this.__applyRenderQuality(this.GCache, false)
        ; Fix #P2: clear immediately → any stray UpdateLayeredWindow (DWM
        ; refresh, stale size) shows transparent, never black garbage.
        Gdip_GraphicsClear(this.G, 0x00000000)
        this.cacheDirty := true
        this._textRendered := false
        this._closeHoveredRendered := -1
        this._dirtyRect := "full"
        this._lastAlpha := -1
        this._lastRenderX := -999999
        this._lastRenderY := -999999
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
        if (this._progressBgSnapshot) {
            Gdip_DisposeImage(this._progressBgSnapshot)
            this._progressBgSnapshot := 0
        }
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
        if (this._stripePen) {
            Gdip_DeletePen(this._stripePen)
            this._stripePen := 0
            this._stripePenW := 0
        }
        hwnd := this.hwnd
        this.hwnd := 0
        this.gui := 0
        ; onClose fires exactly once, on every teardown path
        ; (auto-dismiss, user close, button, KillAll, Shutdown).
        if (this.onCloseCallback) {
            cb := this.onCloseCallback
            this.onCloseCallback := 0
            try cb()
        }
        ; Break reference cycles (clickRegions closures capture this)
        this.clickRegions := []
        this._buttonClickRegions := []
        this.onClickCallback := 0
        this.actions := []
        Toastify.__destroyCount++
        if (DllCall("IsWindow", "ptr", hwnd))
            DllCall("DestroyWindow", "ptr", hwnd)
    }
}
