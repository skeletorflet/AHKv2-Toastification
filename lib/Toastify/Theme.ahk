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
            shadow: 0x99D946EF, progress: 0xFFC026D3,
            glow: true
        })
        ToastTheme.Register("vapor", {
            bg1: 0xEE10002B, bg2: 0xEE240046,
            fg: 0xFFE0AAFF, accent: 0xFF22D3EE,
            shadow: 0x7700FFFF, progress: 0xFFE879F9,
            glow: true
        })
        ToastTheme.Register("cyberpunk", {
            bg1: 0xEE000000, bg2: 0xEE0A0A0A,
            fg: 0xFFFCEE0A, accent: 0xFF00F0FF,
            shadow: 0x88FCEE0A, progress: 0xFFFF003C,
            gradientAngle: 45, glow: true
        })
        ToastTheme.Register("retro", {
            bg1: 0xEE0A0A0A, bg2: 0xEE000000,
            fg: 0xFF33FF00, accent: 0xFF33FF00,
            shadow: 0x4433FF00, progress: 0xFF33FF00
        })
        ToastTheme.Register("glass", {
            bg1: 0xCC1F2937, bg2: 0xCC111827,
            fg: 0xFFFFFFFF, accent: 0xCCFFFFFF,
            shadow: 0x44000000, progress: 0xFFFFFFFF, progressBg: 0x40FFFFFF,
            borderWidth: 0, gradientType: "radial"
        })
        ToastTheme.Register("minimal", {
            bg1: 0xFF0A0A0A, bg2: 0xFF000000,
            fg: 0xFFFFFFFF, accent: 0xFFFFFFFF,
            shadow: 0x33000000, progress: 0xFFAAAAAA, progressBg: 0x40FFFFFF,
            borderWidth: 0
        })
        ToastTheme.Register("pastel", {
            bg1: 0xEE1F1F23, bg2: 0xEE18181B,
            fg: 0xFFFFD1DC, accent: 0xFFFB7185,
            shadow: 0x55000000, progress: 0xFFFB7185
        })
        ToastTheme.Register("flat", {
            bg1: 0xFF1E293B, bg2: 0xFF0F172A,
            fg: 0xFFF1F5F9, accent: 0xFFCBD5E1,
            shadow: 0x33000000, progress: 0xFF94A3B8, progressBg: 0x40FFFFFF,
            borderWidth: 0
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
            shadow: 0x33000000, progress: 0xCC6366F1,
            borderWidth: 0
        })
        ToastTheme.Register("minimal-light", {
            bg1: 0xFFFFFFFF, bg2: 0xFFF1F5F9,
            fg: 0xFF000000, accent: 0xFF000000,
            shadow: 0x33000000, progress: 0xFF525252, progressBg: 0x59000000,
            borderWidth: 0
        })
        ToastTheme.Register("pastel-light", {
            bg1: 0xFFFFE4E6, bg2: 0xFFFFC9D6,
            fg: 0xFF4A1942, accent: 0xFFE11D48,
            shadow: 0x44E11D48, progress: 0xFFBE123C
        })
        ToastTheme.Register("flat-light", {
            bg1: 0xFFF1F5F9, bg2: 0xFFCBD5E1,
            fg: 0xFF0F172A, accent: 0xFF475569,
            shadow: 0x33000000, progress: 0xFF1E293B,
            borderWidth: 0
        })

        ; ═══════════════════════════════════════════════════════════════
        ; MODERN THEMES — community palettes (T2)
        ; ═══════════════════════════════════════════════════════════════

        ToastTheme.Register("dracula", {
            bg1: 0xEE282A36, bg2: 0xEE1E1F29,
            fg: 0xFFF8F8F2, accent: 0xFFBD93F9,
            shadow: 0x77BD93F9, progress: 0xFF50FA7B
        })
        ToastTheme.Register("dracula-light", {
            bg1: 0xFFF8F8F2, bg2: 0xFFECEAF3,
            fg: 0xFF44475A, accent: 0xFF6272A4,
            shadow: 0x446272A4, progress: 0xFF2EB66A
        })
        ToastTheme.Register("tokyo-night", {
            bg1: 0xEE1A1B26, bg2: 0xEE16161E,
            fg: 0xFFA9B1D6, accent: 0xFF7AA2F7,
            shadow: 0x777AA2F7, progress: 0xFFBB9AF7
        })
        ToastTheme.Register("tokyo-night-light", {
            bg1: 0xFFE1E2E7, bg2: 0xFFD0D4DE,
            fg: 0xFF3760BF, accent: 0xFF1664D9,
            shadow: 0x441664D9, progress: 0xFF8B5CF6
        })
        ToastTheme.Register("catppuccin-mocha", {
            bg1: 0xEE1E1E2E, bg2: 0xEE181825,
            fg: 0xFFCDD6F4, accent: 0xFF89B4FA,
            shadow: 0x7789B4FA, progress: 0xFFA6E3A1
        })
        ToastTheme.Register("catppuccin-latte", {
            bg1: 0xFFEFF1F5, bg2: 0xFFE6E9EF,
            fg: 0xFF4C4F69, accent: 0xFF1E66F5,
            shadow: 0x441E66F5, progress: 0xFF40A02B
        })
        ToastTheme.Register("nord", {
            bg1: 0xEE2E3440, bg2: 0xEE242933,
            fg: 0xFFD8DEE9, accent: 0xFF88C0D0,
            shadow: 0x7788C0D0, progress: 0xFFA3BE8C
        })
        ToastTheme.Register("nord-light", {
            bg1: 0xFFE5E9F0, bg2: 0xFFD8DEE9,
            fg: 0xFF2E3440, accent: 0xFF5E81AC,
            shadow: 0x445E81AC, progress: 0xFFA3BE8C
        })
        ToastTheme.Register("solarized", {
            bg1: 0xEE073642, bg2: 0xEE002B36,
            fg: 0xFFEEE8D5, accent: 0xFF268BD2,
            shadow: 0x77268BD2, progress: 0xFF2AA198
        })
        ToastTheme.Register("solarized-light", {
            bg1: 0xFFFDF6E3, bg2: 0xFFEEE8D5,
            fg: 0xFF657B83, accent: 0xFF268BD2,
            shadow: 0x44268BD2, progress: 0xFF2AA198
        })
        ToastTheme.Register("gruvbox", {
            bg1: 0xEE282828, bg2: 0xEE1D2021,
            fg: 0xFFEBDBB2, accent: 0xFFB8BB26,
            shadow: 0x77B8BB26, progress: 0xFF83A598
        })
        ToastTheme.Register("gruvbox-light", {
            bg1: 0xFFFBF1C7, bg2: 0xFFEBDBB2,
            fg: 0xFF3C3836, accent: 0xFF79740E,
            shadow: 0x4479740E, progress: 0xFF427B58
        })
        ToastTheme.Register("one-dark", {
            bg1: 0xEE282C34, bg2: 0xEE21252B,
            fg: 0xFFABB2BF, accent: 0xFF61AFEF,
            shadow: 0x7761AFEF, progress: 0xFF98C379
        })
        ToastTheme.Register("one-light", {
            bg1: 0xFFFAFAFA, bg2: 0xFFEFF1F5,
            fg: 0xFF383A42, accent: 0xFF4078F2,
            shadow: 0x444078F2, progress: 0xFF50A14F
        })
        ToastTheme.Register("synthwave", {
            bg1: 0xEE241B2F, bg2: 0xEE1A1124,
            fg: 0xFFF4D0FF, accent: 0xFFFF7EDB,
            shadow: 0x99FF7EDB, progress: 0xFF36F9F6,
            glow: true
        })
        ToastTheme.Register("synthwave-light", {
            bg1: 0xFFFFF0F7, bg2: 0xFFFFD9EC,
            fg: 0xFF5C2A6E, accent: 0xFFD81B8A,
            shadow: 0x44D81B8A, progress: 0xFF0E9BA8
        })
        ToastTheme.Register("monokai", {
            bg1: 0xEE272822, bg2: 0xEE1E1F1C,
            fg: 0xFFF8F8F2, accent: 0xFFF92672,
            shadow: 0x77F92672, progress: 0xFFA6E22E
        })
        ToastTheme.Register("monokai-light", {
            bg1: 0xFFF8F8F2, bg2: 0xFFEDEDE0,
            fg: 0xFF49483E, accent: 0xFFF92672,
            shadow: 0x44F92672, progress: 0xFF5C9E24
        })
        ToastTheme.Register("material-you", {
            bg1: 0xEE1D1B20, bg2: 0xEE141218,
            fg: 0xFFE6E0E9, accent: 0xFFD0BCFF,
            shadow: 0x77D0BCFF, progress: 0xFFF2B8C6
        })
        ToastTheme.Register("material-you-light", {
            bg1: 0xFFFEF7FF, bg2: 0xFFF3EDF7,
            fg: 0xFF1D1B20, accent: 0xFF6750A4,
            shadow: 0x446750A4, progress: 0xFFB3261E
        })
        ToastTheme.Register("carbon", {
            bg1: 0xEE161616, bg2: 0xEE0B0B0C,
            fg: 0xFFF4F4F4, accent: 0xFF78A9FF,
            shadow: 0x7778A9FF, progress: 0xFF08BDBA
        })
        ToastTheme.Register("carbon-light", {
            bg1: 0xFFF4F4F4, bg2: 0xFFE8E8E8,
            fg: 0xFF161616, accent: 0xFF0F62FE,
            shadow: 0x440F62FE, progress: 0xFF24A148
        })
        ToastTheme.Register("ayu", {
            bg1: 0xEE0D1017, bg2: 0xEE0B0E14,
            fg: 0xFFB8C2CC, accent: 0xFFFFB454,
            shadow: 0x77FFB454, progress: 0xFF39BAE6
        })
        ToastTheme.Register("ayu-light", {
            bg1: 0xFFFAFAFA, bg2: 0xFFF2F1ED,
            fg: 0xFF5C6166, accent: 0xFFFF9940,
            shadow: 0x44FF9940, progress: 0xFF39BAE6
        })
    }

    ; Accepts 0xAARRGGBB ints or CSS strings (#RGB/#RRGGBB/#AARRGGBB).
    static ParseARGB(v, fallback := 0xFF000000) {
        if (IsInteger(v))
            return Integer(v)
        if (IsFloat(v))
            return Integer(Round(v))
        if (Type(v) = "String") {
            s := Trim(v)
            if (SubStr(s, 1, 1) = "#")
                s := SubStr(s, 2)
            if (RegExMatch(s, "^[0-9a-fA-F]+$") && (StrLen(s) = 3 || StrLen(s) = 6 || StrLen(s) = 8)) {
                if (StrLen(s) = 3) {
                    r := SubStr(s, 1, 1), g := SubStr(s, 2, 1), b := SubStr(s, 3, 1)
                    s := r r g g b b
                }
                if (StrLen(s) = 6)
                    s := "FF" s
                return Integer("0x" s)
            }
        }
        return fallback
    }
    static Register(name, palette) {
        if (ToastTheme.themes.Has(name))
            ToastTheme.DeletePalette(ToastTheme.themes[name])
        ; Strict validation: missing/invalid keys used to crash deep in GDI+
        ; (palette.accent & ...) with garbage colors. Fail fast with OutputDebug.
        ok := true
        for key in ["bg1", "bg2", "fg", "accent", "shadow", "progress"] {
            if (!palette.HasOwnProp(key)) {
                if (key = "progress" && palette.HasOwnProp("accent"))
                    continue
                OutputDebug("Toastify: Register('" name "') missing required key '" key "'")
                ok := false
            }
        }
        if (!ok)
            return ""
        for key in ["bg1", "bg2", "fg", "accent", "shadow", "progress", "progressBg", "border"] {
            if (palette.HasOwnProp(key))
                palette.%key% := ToastTheme.ParseARGB(palette.%key%)
        }
        if (!palette.HasOwnProp("progress"))
            palette.progress := palette.accent
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
        ; Lazy: acá NO se crea ningún handle GDI+. Solo colores + defaults +
        ; contraste. Los pens/brushes se materializan en __materialize() ante
        ; el primer palette(name) que pida el tema.
        palette.__materialized := false
        ToastTheme.CheckContrast(name, palette)
        ToastTheme.themes[name] := palette
    }

    ; Crea los pens/brushes GDI+ de un tema ya registrado. Corre una sola vez
    ; por tema (on-demand desde palette()); el resultado queda cacheado en el
    ; propio objeto paleta.
    static __materialize(palette) {
        palette.borderPen := Gdip_CreatePen(palette.border, palette.borderWidth)
        palette.accentBrush := Gdip_BrushCreateSolid(palette.accent)
        ; Button border: WCAG-onAccent at 20% alpha — adapts to light/dark accents
        ; (fixed 0x44FFFFFF was invisible on light themes).
        btnBorder := ToastTheme.onAccent(palette.accent)
        palette.btnBorderPen := Gdip_CreatePen(0x33000000 | (btnBorder & 0xFFFFFF), 1)
        palette.btnFillBrush := Gdip_BrushCreateSolid(0x33000000)
        palette.progressBgBrush := Gdip_BrushCreateSolid(palette.progressBg)
        palette.progressFillBrush := Gdip_BrushCreateSolid(palette.progress)
        ; ── Icon glyphs: WCAG-onAccent, not fixed white (white on light
        ;    accents like #34D399/#FB923C has ~1.8:1 ratio — unreadable) ──
        iconFg := ToastTheme.onAccent(palette.accent)
        palette.iconFgBrush := Gdip_BrushCreateSolid(iconFg)
        palette.iconFgPen := Gdip_CreatePen(iconFg, 3)
        palette.iconFgPen2 := Gdip_CreatePen(iconFg, 2)
        palette.__materialized := true
        return palette
    }

    static luminance(c) {
        r := (c >> 16) & 0xFF, g := (c >> 8) & 0xFF, b := c & 0xFF
        lr := r / 255, lg := g / 255, lb := b / 255
        lr := lr <= 0.03928 ? lr / 12.92 : ((lr + 0.055) / 1.055) ** 2.4
        lg := lg <= 0.03928 ? lg / 12.92 : ((lg + 0.055) / 1.055) ** 2.4
        lb := lb <= 0.03928 ? lb / 12.92 : ((lb + 0.055) / 1.055) ** 2.4
        return 0.2126 * lr + 0.7152 * lg + 0.0722 * lb
    }
    static onAccent(c) {
        L := ToastTheme.luminance(c)
        return ((L + 0.05) / 0.05 > 1.05 / (L + 0.05)) ? 0xFF0F172A : 0xFFFFFFFF
    }
    static ratio(c1, c2) {
        L1 := ToastTheme.luminance(c1)
        L2 := ToastTheme.luminance(c2)
        hi := Max(L1, L2), lo := Min(L1, L2)
        return (hi + 0.05) / (lo + 0.05)
    }
    static CheckContrast(name, palette) {
        ; C5: WCAG AA warn (OutputDebug, non-blocking)
        fgBg := ToastTheme.ratio(palette.fg, palette.bg1)
        accFg := ToastTheme.ratio(palette.accent, palette.fg)
        if (fgBg < 4.5)
            OutputDebug("Toastify: theme '" name "' fg/bg=" Round(fgBg, 2) " < 4.5 (WCAG AA)")
        if (accFg < 3)
            OutputDebug("Toastify: theme '" name "' accent/fg=" Round(accFg, 2) " < 3")
    }
    static palette(theme) {
        if (theme == "auto")
            theme := ToastTheme.ResolveAuto()
        if (ToastTheme.themes.Has(theme))
            return ToastTheme.__ensureMaterialized(ToastTheme.themes[theme])
        OutputDebug("Toastify: unknown theme '" theme "' → fallback 'dark'")
        return ToastTheme.__ensureMaterialized(ToastTheme.themes["dark"])
    }

    ; Devuelve la paleta materializada (crea los handles GDI+ solo la primera vez).
    static __ensureMaterialized(palette) {
        if (!palette.HasOwnProp("__materialized") || !palette.__materialized)
            ToastTheme.__materialize(palette)
        return palette
    }

    ; ── "auto" follows the Windows app theme ──
    static ResolveAuto() {
        try {
            v := RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize", "AppsUseLightTheme")
            return (v = 1) ? "light" : "dark"
        }
        return "dark"
    }

    static DeletePalette(pal) {
        ; Lazy: sin materializar no hay handles que liberar.
        if (pal.HasOwnProp("__materialized") && !pal.__materialized)
            return
        try Gdip_DeletePen(pal.borderPen)
        try Gdip_DeleteBrush(pal.accentBrush)
        try Gdip_DeletePen(pal.btnBorderPen)
        try Gdip_DeleteBrush(pal.btnFillBrush)
        try Gdip_DeleteBrush(pal.progressBgBrush)
        try Gdip_DeleteBrush(pal.progressFillBrush)
        try Gdip_DeleteBrush(pal.iconFgBrush)
        try Gdip_DeletePen(pal.iconFgPen)
        try Gdip_DeletePen(pal.iconFgPen2)
    }
    static Shutdown() {
        for name, pal in ToastTheme.themes
            ToastTheme.DeletePalette(pal)
        ToastTheme.themes.Clear()
    }
}
