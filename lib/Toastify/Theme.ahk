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
