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
    repoEasing := "easeOutCubic"
    repoAnimStyle := "slide"
    renderQuality := "High"
    progressHeight := 3
    ; "bottom" (por defecto) | "top": barra fina pegada al borde superior
    progressPos := "bottom"

    rotationDegree := 10

    ; ── Fuente única de keys de config ──
    ;    Agregar una opción nueva = 1 línea acá (en el array que corresponda).
    ;    AllKeys: todo lo que SetConfig() propaga y Toast.__New copia de la config.
    ;    StyleKeys: subset overridable por-toast vía opts (ver Toast._styleKeys).
    ;    NOTA: si la opción nueva es DPI-dependiente, además debe aplicarse
    ;    en Toast._saveBaseCfg() / Toast._applyDpi().
    static AllKeys := ["width", "minHeight", "fontName", "fontSizeTitle", "fontSizeBody",
        "fontWeightTitle", "fontWeightBody", "paddingX", "paddingY", "iconSize", "iconScale",
        "designScale", "borderRadius", "borderWidth", "animDuration", "animEasing", "animStyle",
        "animEntrance", "renderQuality", "repoDuration", "repoEasing", "repoAnimStyle",
        "rotationDegree", "progressHeight", "progressPos"]
    static StyleKeys := ["fontName", "fontSizeTitle", "fontSizeBody", "fontWeightTitle", "fontWeightBody",
        "paddingX", "paddingY", "iconSize", "iconScale", "designScale", "borderRadius", "borderWidth",
        "animDuration", "renderQuality", "rotationDegree", "progressHeight", "progressPos"]

}
