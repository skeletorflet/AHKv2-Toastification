#Requires AutoHotkey v2.0
; MouseTrail — trail effect GDI+ sobre overlay fullscreen click-through.
; Optimizado para 60fps: HighSpeed smoothing, Gdip_DrawLines por lotes,
; colores inline, frame limiter.
#Include ..\OnMouseMove.ahk
#Include .\AHKv2-Gdip\Gdip_All.ahk

class MouseTrail {
    static Effects := ["mix", "comet", "ribbon", "particles", "snake"]

    __New(opts := {}) {
        this.effect := opts.HasOwnProp("effect") ? opts.effect : "mix"
        this.rgb := opts.HasOwnProp("rgb") ? opts.rgb : 0x00E5FF
        this.maxPoints := opts.HasOwnProp("maxPoints") ? opts.maxPoints : 32
        this.maxAge := opts.HasOwnProp("maxAge") ? opts.maxAge : 450
        this.dotSize := opts.HasOwnProp("dotSize") ? opts.dotSize : 14
        this.ribbonW := opts.HasOwnProp("ribbonW") ? opts.ribbonW : 8
        this.fps := opts.HasOwnProp("fps") ? opts.fps : 60
        this.rainbow := opts.HasOwnProp("rainbow") ? !!opts.rainbow : false
        this.ripplesOn := opts.HasOwnProp("ripples") ? !!opts.ripples : true
        ; Suavizado: filtro adaptativo (One Euro lite) + Catmull-Rom en ribbon
        this.smooth := opts.HasOwnProp("smooth") ? !!opts.smooth : true
        this.minCutoff := opts.HasOwnProp("minCutoff") ? opts.minCutoff : 1.4
        this.beta := opts.HasOwnProp("beta") ? opts.beta : 0.025
        this.dcutoff := opts.HasOwnProp("dcutoff") ? opts.dcutoff : 1.0
        this.splineN := opts.HasOwnProp("splineN") ? opts.splineN : 3
        this.follow := opts.HasOwnProp("follow") ? opts.follow : 0.35
        this.tailAmp := opts.HasOwnProp("tailAmp") ? opts.tailAmp : 10
        this.tailWaves := opts.HasOwnProp("tailWaves") ? opts.tailWaves : 1.0
        this.tailPeriod := opts.HasOwnProp("tailPeriod") ? opts.tailPeriod : 900
        this.tailStart := opts.HasOwnProp("tailStart") ? opts.tailStart : 0.6
        this.pulse := opts.HasOwnProp("pulse") ? opts.pulse : 0.4
        this._fInit := false
        this._fSX := 0, this._fSY := 0, this._fDX := 0, this._fDY := 0
        this._fRX := 0, this._fRY := 0, this._fT := 0
        this._rawX := 0, this._rawY := 0
        this.running := false
        this._disposed := false

        this.points := []
        this.particles := []
        this.ripples := []
        this.snake := []

        this._token := Gdip_Startup()

        this.vx := DllCall("GetSystemMetrics", "Int", 76)
        this.vy := DllCall("GetSystemMetrics", "Int", 77)
        this.vw := DllCall("GetSystemMetrics", "Int", 78)
        this.vh := DllCall("GetSystemMetrics", "Int", 79)

        this._gui := Gui("-Caption +E0x80000 +E0x20 +LastFound +AlwaysOnTop +ToolWindow -DPIScale +OwnDialogs")
        this.hwnd := this._gui.Hwnd
        WinSetExStyle("+0x20 +0x80000 +0x08000000", this.hwnd)

        this.hbm := CreateDIBSection(this.vw, this.vh)
        this.hdc := CreateCompatibleDC()
        this.obm := SelectObject(this.hdc, this.hbm)
        this.G := Gdip_GraphicsFromHDC(this.hdc)
        Gdip_SetSmoothingMode(this.G, 3)

        this._brush := Gdip_BrushCreateSolid(0xFF000000)
        this._pen := Gdip_CreatePen(0xFF000000, 4)

        this._gui.Show(Format("x{1} y{2} w{3} h{4} NA", this.vx, this.vy, this.vw, this.vh))
        UpdateLayeredWindow(this.hwnd, this.hdc, this.vx, this.vy, this.vw, this.vh)

        this._mouseCb := (x, y, px, py) => this._OnMove(x, y)
        this._renderCb := () => this._Render()
        this._lastFrame := 0
        this._frameBudget := 1000 / this.fps
    }

    Start() {
        if (this.running || this._disposed)
            return
        this.running := true
        OnMouseMove_Start(this._mouseCb)
        if (this.ripplesOn)
            Hotkey("~LButton", (hk) => this._OnClick(), "On")
        this._EnsureTimer()
    }

    Stop() {
        this.running := false
        try OnMouseMove_Remove(this._mouseCb)
        try Hotkey("~LButton", "Off")
        SetTimer(this._renderCb, 0)
        this.points := []
        this.particles := []
        this.ripples := []
        this.snake := []
        this._ResetFilter()
        if (!this._disposed) {
            Gdip_GraphicsClear(this.G, 0x00000000)
            UpdateLayeredWindow(this.hwnd, this.hdc, this.vx, this.vy, this.vw, this.vh)
        }
    }

    Toggle() {
        if (this.running)
            this.Stop()
        else
            this.Start()
    }

    Dispose() {
        if (this._disposed)
            return
        this.Stop()
        this._disposed := true
        Gdip_DeleteBrush(this._brush)
        Gdip_DeletePen(this._pen)
        Gdip_DeleteGraphics(this.G)
        SelectObject(this.hdc, this.obm)
        DeleteObject(this.hbm)
        DeleteDC(this.hdc)
        try this._gui.Destroy()
        Gdip_Shutdown(this._token)
    }

    SetEffect(name) {
        name := StrLower(name)
        for e in MouseTrail.Effects {
            if (e = name) {
                this.effect := name
                this.snake := []
                return true
            }
        }
        return false
    }

    SetColor(rgb) => (this.rgb := rgb & 0xFFFFFF)
    SetLength(n) => (this.maxPoints := Max(4, Min(80, n)))
    SetSize(n) => (this.dotSize := Max(4, Min(32, n)))
    SetFps(n) {
        this.fps := Max(24, Min(120, n))
        this._frameBudget := 1000 / this.fps
        if (this.running)
            this._EnsureTimer()
    }
    SetRainbow(on) => (this.rainbow := !!on)
    EnableRipples(on) {
        this.ripplesOn := !!on
        if (!this.running)
            return
        if (this.ripplesOn)
            Hotkey("~LButton", (hk) => this._OnClick(), "On")
        else
            try Hotkey("~LButton", "Off")
    }
    SetSmoothing(on) => (this.smooth := !!on)
    SetFollow(f) => (this.follow := Max(0, Min(1, f)))
    SetTension(n) => (this.splineN := Max(0, Min(6, n)))
    SetTail(amp) => (this.tailAmp := Max(0, Min(30, amp)))
    SetTailStart(pct) => (this.tailStart := Max(0, Min(90, pct)) / 100)
    SetPulse(v) => (this.pulse := Max(-100, Min(100, v)) / 100)
    Clear() {
        this.points := []
        this.particles := []
        this.ripples := []
        this.snake := []
        this._ResetFilter()
    }

    _ResetFilter() {
        this._fInit := false
        this._fSX := 0, this._fSY := 0, this._fDX := 0, this._fDY := 0
        this._fRX := 0, this._fRY := 0, this._fT := 0
    }

    static _Alpha(cutoff, dt) {
        tau := 1.0 / (6.2831853 * cutoff)
        return 1.0 / (1.0 + tau / dt)
    }

    ; One Euro lite: cutoff adaptativo según velocidad. Rápido=>pegado,
    ; lento=>suave. Devuelve [sx, sy].
    _Smooth(x, y, now) {
        if (!this.smooth)
            return [x, y]
        if (!this._fInit) {
            this._fInit := true
            this._fSX := x, this._fSY := y, this._fDX := 0, this._fDY := 0
            this._fRX := x, this._fRY := y, this._fT := now
            return [x, y]
        }
        dt := (now - this._fT) / 1000.0
        if (dt <= 0.0005)
            dt := 0.0005
        if (dt > 0.1)
            dt := 0.1
        this._fT := now
        ad := MouseTrail._Alpha(this.dcutoff, dt)
        dx := (x - this._fRX) / dt
        dy := (y - this._fRY) / dt
        this._fRX := x, this._fRY := y
        this._fDX += ad * (dx - this._fDX)
        this._fDY += ad * (dy - this._fDY)
        speed := Sqrt(this._fDX * this._fDX + this._fDY * this._fDY)
        cutoff := this.minCutoff + this.beta * speed
        a := MouseTrail._Alpha(cutoff, dt)
        this._fSX += a * (x - this._fSX)
        this._fSY += a * (y - this._fSY)
        return [this._fSX, this._fSY]
    }

    ; Catmull-Rom uniforme: subdivide cada segmento en splineN tramos,
    ; interpola t para que el fade siga parejo. Cap ~128 pts.
    ; headLast=false para snake (cabeza en índice 1). Mezcla la cabeza
    ; hacia el raw según follow => curva+follow valen en todos los efectos.
    ; Siempre devuelve array fresco (nunca muta los puntos guardados).
    _Resample(pts, headLast := true) {
        n := pts.Length
        if (!this.smooth)
            return pts
        out := []
        if (n >= 3 && this.splineN >= 2) {
            subdiv := this.splineN
            if ((n - 1) * subdiv + 1 > 128)
                subdiv := Max(2, (128 - 1) // (n - 1))
            loop n - 1 {
                i := A_Index
                p0 := pts[i = 1 ? 1 : i - 1]
                p1 := pts[i]
                p2 := pts[i + 1]
                p3 := pts[i + 2 > n ? n : i + 2]
                loop subdiv {
                    t := (A_Index - 1) / subdiv
                    t2 := t * t, t3 := t2 * t
                    x := 0.5 * ((2 * p1.x) + (-p0.x + p2.x) * t +
                        (2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x) * t2 +
                        (-p0.x + 3 * p1.x - 3 * p2.x + p3.x) * t3)
                    y := 0.5 * ((2 * p1.y) + (-p0.y + p2.y) * t +
                        (2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) * t2 +
                        (-p0.y + 3 * p1.y - 3 * p2.y + p3.y) * t3)
                    tt := p1.t + (p2.t - p1.t) * t
                    out.Push({ x: x, y: y, t: tt })
                }
            }
            out.Push({ x: pts[n].x, y: pts[n].y, t: pts[n].t })
        } else {
            loop n
                out.Push({ x: pts[A_Index].x, y: pts[A_Index].y, t: pts[A_Index].t })
        }
        if (this.follow > 0 && out.Length) {
            bi := headLast ? out.Length : 1
            b := out[bi]
            out[bi] := { x: b.x + (this._rawX - b.x) * this.follow,
                         y: b.y + (this._rawY - b.y) * this.follow, t: b.t }
        }
        return out
    }

    _OnMove(x, y) {
        if (!this.running)
            return
        now := A_TickCount
        this._rawX := x, this._rawY := y
        sp := this._Smooth(x, y, now)
        sx := sp[1], sy := sp[2]
        pts := this.points
        if (pts.Length) {
            lp := pts[pts.Length]
            ddx := sx - lp.x, ddy := sy - lp.y
            if (ddx * ddx + ddy * ddy < 1.44)
                return
        }
        pts.Push({ x: sx, y: sy, t: now })
        while (pts.Length > this.maxPoints)
            pts.RemoveAt(1)
        if (this.effect = "particles" || this.effect = "mix")
            this._Spawn(sx, sy, pts)
        this._EnsureTimer()
    }

    _OnClick() {
        if (!this.running || !this.ripplesOn)
            return
        CoordMode("Mouse", "Screen")
        MouseGetPos(&x, &y)
        this.ripples.Push({ x: x, y: y, t: A_TickCount })
        this._EnsureTimer()
    }

    _EnsureTimer() {
        if (!this.running)
            return
        SetTimer(this._renderCb, 4)
    }

    _Spawn(x, y, pts) {
        n := pts.Length
        if (n >= 2) {
            dx := x - pts[n - 1].x
            dy := y - pts[n - 1].y
        } else {
            dx := 0
            dy := 0
        }
        loop 2 {
            if (this.particles.Length >= 90)
                break
            this.particles.Push({
                x: x, y: y,
                vx: -dx * 2.2 + Random(-90, 90),
                vy: -dy * 2.2 + Random(-110, 30),
                t: A_TickCount, life: Random(280, 480)
            })
        }
    }

    _Render() {
        if (!this.running) {
            SetTimer(this._renderCb, 0)
            return
        }
        now := A_TickCount
        if (now - this._lastFrame < this._frameBudget)
            return
        this._lastFrame := now

        pts := this.points

        ; Snake persiste quieto: sin cull por edad, la cabeza queda viva
        if (this.effect != "snake") {
            while (pts.Length && now - pts[1].t > this.maxAge)
                pts.RemoveAt(1)
        }

        i := this.particles.Length
        while (i >= 1) {
            if (now - this.particles[i].t > this.particles[i].life)
                this.particles.RemoveAt(i)
            i--
        }
        i := this.ripples.Length
        while (i >= 1) {
            if (now - this.ripples[i].t > 600)
                this.ripples.RemoveAt(i)
            i--
        }

        if (!pts.Length && !this.particles.Length && !this.ripples.Length && !this.snake.Length) {
            SetTimer(this._renderCb, 0)
            Gdip_GraphicsClear(this.G, 0x00000000)
            UpdateLayeredWindow(this.hwnd, this.hdc, this.vx, this.vy, this.vw, this.vh)
            return
        }

        Gdip_GraphicsClear(this.G, 0x00000000)
        ox := this.vx
        oy := this.vy
        maxAge := this.maxAge

        switch this.effect {
            case "comet": this._DrawComet(pts, now, ox, oy, maxAge)
            case "ribbon": this._DrawRibbon(pts, now, ox, oy, maxAge)
            case "particles":
                this._DrawComet(pts, now, ox, oy, maxAge, true)
                this._DrawParticles(now, ox, oy)
            case "snake":
                count := Max(4, Min(48, this.maxPoints))
                if (pts.Length) {
                    lp := pts[pts.Length]
                    this._UpdateSnake(lp.x, lp.y, count)
                }
                this._DrawSnake(now, ox, oy)
            default:
                this._DrawRibbon(pts, now, ox, oy, maxAge)
                this._DrawComet(pts, now, ox, oy, maxAge)
                this._DrawParticles(now, ox, oy)
        }
        if (this.ripples.Length)
            this._DrawRipples(now, ox, oy)

        UpdateLayeredWindow(this.hwnd, this.hdc, this.vx, this.vy, this.vw, this.vh)
    }

    _ColorFor(age01, idx, total) {
        if (this.rainbow)
            return MouseTrail._Hsv((Mod(idx * 9 + A_TickCount // 18, 360)), 0.85, 1.0)
        return this.rgb
    }

    _DrawComet(pts, now, ox, oy, maxAge, small := false) {
        pts := this._Resample(pts)
        total := pts.Length
        if (!total)
            return
        glowN := Min(2, total)
        rainbow := this.rainbow
        dotSz := this.dotSize
        mainR := small ? dotSz * 0.45 : dotSz
        loop total {
            p := pts[A_Index]
            age := (now - p.t) / maxAge
            if (age >= 1)
                continue
            a01 := (1 - age) ** 1.6
            if (rainbow)
                rgb := MouseTrail._Hsv((Mod(A_Index * 9 + now // 18, 360)), 0.85, 1.0)
            else
                rgb := this.rgb
            alpha := Round(a01 * 235) + 20
            r := mainR * (0.25 + 0.75 * a01)
            lx := p.x - ox
            ly := p.y - oy
            if (A_Index > total - glowN) {
                DllCall("gdiplus\GdipSetSolidFillColor", "Ptr", this._brush, "UInt", (0x28 << 24) | rgb)
                Gdip_FillEllipse(this.G, this._brush, lx - r, ly - r, r * 2, r * 2)
            }
            DllCall("gdiplus\GdipSetSolidFillColor", "Ptr", this._brush, "UInt", (alpha << 24) | rgb)
            Gdip_FillEllipse(this.G, this._brush, lx - r * 0.55, ly - r * 0.55, r * 1.1, r * 1.1)
        }
    }

    _DrawRibbon(pts, now, ox, oy, maxAge) {
        pts := this._Resample(pts)
        total := pts.Length
        if (total < 2)
            return
        rainbow := this.rainbow
        rgbBase := this.rgb
        ribbonW := this.ribbonW
        nBuckets := 5
        segCount := total - 1

        loop nBuckets {
            b := A_Index
            first := (b - 1) * segCount // nBuckets
            last := b * segCount // nBuckets
            if (first >= last)
                continue
            sumA01 := 0.0
            cnt := 0
            coords := ""
            loop last - first {
                segIdx := first + A_Index
                bp := pts[segIdx + 1]
                age := (now - bp.t) / maxAge
                if (age >= 1)
                    continue
                a01 := (1 - age) ** 1.3
                sumA01 += a01
                cnt++
                if (coords != "")
                    coords .= "|"
                coords .= (bp.x - ox) "," (bp.y - oy)
            }
            if (!cnt)
                continue
            firstPt := pts[first + 1]
            coords := (firstPt.x - ox) "," (firstPt.y - oy) "|" coords
            avgA01 := sumA01 / cnt
            if (rainbow)
                bRgb := MouseTrail._Hsv(Mod((first + 1) * 9 + now // 18, 360), 0.85, 1.0)
            else
                bRgb := rgbBase
            bWidth := 1 + (ribbonW - 1) * avgA01
            alpha := Round(avgA01 * 200 + 30)
            DllCall("gdiplus\GdipSetPenColor", "Ptr", this._pen, "UInt", (alpha << 24) | bRgb)
            DllCall("gdiplus\GdipSetPenWidth", "Ptr", this._pen, "Float", bWidth)
            Gdip_DrawLines(this.G, this._pen, coords)
        }
    }

    _DrawParticles(now, ox, oy) {
        dt := 0.016
        rainbow := this.rainbow
        rgbBase := this.rgb
        for p in this.particles {
            age := (now - p.t) / p.life
            if (age >= 1)
                continue
            p.vx *= 0.97
            p.vy := p.vy * 0.97 + 900 * dt
            p.x += p.vx * dt
            p.y += p.vy * dt
            a01 := 1 - age
            if (rainbow)
                rgb := MouseTrail._Hsv(Mod(p.x + p.y + now // 20, 360), 0.8, 1.0)
            else
                rgb := rgbBase
            DllCall("gdiplus\GdipSetSolidFillColor", "Ptr", this._brush,
                "UInt", (Round(a01 * 220 + 20) << 24) | rgb)
            r := 1.5 + 3.5 * a01
            Gdip_FillEllipse(this.G, this._brush, p.x - ox - r, p.y - oy - r, r * 2, r * 2)
        }
    }

    ; Snake: follow-the-leader con gap fijo. La cabeza es el punto ya
    ; suavizado (sin mezcla raw) => 100% smooth; la relajación por frame
    ; le da a la cola su retardo natural de serpiente.
    _UpdateSnake(hx, hy, count) {
        sn := this.snake
        if (!sn.Length || sn.Length != count) {
            sn := []
            loop count
                sn.Push({ x: hx, y: hy, t: 0 })
            this.snake := sn
            return
        }
        sn[1].x := hx, sn[1].y := hy
        gap := Max(6, this.dotSize * 0.85)
        loop sn.Length - 1 {
            i := A_Index + 1
            a := sn[i - 1], b := sn[i]
            dx := b.x - a.x, dy := b.y - a.y
            d := Sqrt(dx * dx + dy * dy)
            if (d > gap) {
                k := gap / d
                b.x := a.x + dx * k
                b.y := a.y + dy * k
            }
        }
    }

    _DrawSnake(now, ox, oy) {
        sn := this._Resample(this.snake, false)
        n := sn.Length
        if (!n)
            return
        rainbow := this.rainbow
        headR := this.dotSize * 0.9
        wagOn := this.tailAmp > 0 && n >= 4
        loop n {
            i := A_Index
            s := sn[i]
            f := n = 1 ? 1 : (i - 1) / (n - 1)
            r := headR * (1 - 0.75 * f)
            if (rainbow)
                rgb := MouseTrail._Hsv(Mod(f * 300 + now // 40, 360), 0.85, 1.0)
            else
                rgb := this.rgb
            alpha := Round(235 * (1 - f) + 20)
            ; Latido: onda senoidal de radio+brillo. Signo = dirección.
            if (this.pulse != 0) {
                sdir := this.pulse > 0 ? f : 1 - f
                w := 0.5 + 0.5 * Sin(6.2831853 * (sdir * 1.2 - now / 750))
                w := w * w
                r *= 1 + Abs(this.pulse) * 0.45 * w
                alpha := Min(255, Round(alpha + 120 * Abs(this.pulse) * w))
            }
            lx := s.x - ox, ly := s.y - oy
            ; Coletazo: onda lateral viajera desde tailStart. Solo visual.
            if (wagOn && f >= this.tailStart && this.tailStart < 1) {
                u := (f - this.tailStart) / (1 - this.tailStart)
                env := u * u * (3 - 2 * u)
                pa := sn[i = 1 ? 1 : i - 1]
                pb := sn[i = n ? n : i + 1]
                tx := pb.x - pa.x, ty := pb.y - pa.y
                tl := Sqrt(tx * tx + ty * ty)
                if (tl >= 0.001) {
                    off := env * this.tailAmp * Sin(6.2831853 * (u * this.tailWaves - now / this.tailPeriod))
                    lx += (-ty / tl) * off
                    ly += (tx / tl) * off
                }
            }
            if (i = 1) {
                DllCall("gdiplus\GdipSetSolidFillColor", "Ptr", this._brush, "UInt", (0x28 << 24) | rgb)
                Gdip_FillEllipse(this.G, this._brush, lx - r * 1.4, ly - r * 1.4, r * 2.8, r * 2.8)
            }
            DllCall("gdiplus\GdipSetSolidFillColor", "Ptr", this._brush, "UInt", (alpha << 24) | rgb)
            Gdip_FillEllipse(this.G, this._brush, lx - r * 0.55, ly - r * 0.55, r * 1.1, r * 1.1)
        }
    }

    _DrawRipples(now, ox, oy) {
        rgb := this.rainbow ? MouseTrail._Hsv(Mod(now // 10, 360), 0.7, 1.0) : this.rgb
        for rp in this.ripples {
            age := (now - rp.t) / 600
            if (age >= 1)
                continue
            e := 1 - (1 - age) ** 3
            DllCall("gdiplus\GdipSetPenColor", "Ptr", this._pen,
                "UInt", (Round((1 - age) * 220 + 20) << 24) | rgb)
            DllCall("gdiplus\GdipSetPenWidth", "Ptr", this._pen, "Float", 3.5 * (1 - age) + 1)
            r := 6 + e * 64
            Gdip_DrawEllipse(this.G, this._pen, rp.x - ox - r, rp.y - oy - r, r * 2, r * 2)
        }
    }

    static _Hsv(h, s, v) {
        c := v * s
        x := c * (1 - Abs(Mod(h / 60, 2) - 1))
        m := v - c
        if (h < 60)
            r1 := c, g1 := x, b1 := 0
        else if (h < 120)
            r1 := x, g1 := c, b1 := 0
        else if (h < 180)
            r1 := 0, g1 := c, b1 := x
        else if (h < 240)
            r1 := 0, g1 := x, b1 := c
        else if (h < 300)
            r1 := x, g1 := 0, b1 := c
        else
            r1 := c, g1 := 0, b1 := x
        return (Round((r1 + m) * 255) << 16) | (Round((g1 + m) * 255) << 8) | Round((b1 + m) * 255)
    }
}
