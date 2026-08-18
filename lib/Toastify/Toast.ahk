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
        this._titleH := titleH
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
            bodyY := (this.title != "") ? (this.paddingY + Max(this.fontSizeTitle * 1.5, this._titleH) + 4 * d) : this.paddingY
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
            bodyY := (this.title != "") ? (this.paddingY + Max(this.fontSizeTitle * 1.5, this._titleH) + 4 * d) : this.paddingY
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
            btnFg := ToastTheme.onAccent(pal.accent)
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
    __contrastOn(c) => ToastTheme.luminance(c) > 0.4
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
    InitAnimation() {
        this._hasSlide := this.HasAnim("slide")
        this._hasFade := this.HasAnim("fade")
        this._hasZoom := this.HasAnim("zoom")
        this._hasRotate := this.HasAnim("rotate")
        this.opacity := 1.0
        this.scale := 1.0
        ; this.rotation := 0.0
        entrance := this.animEntrance
        if (entrance == "auto")
            entrance := Toast.__resolveEntrance(this.position)
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
