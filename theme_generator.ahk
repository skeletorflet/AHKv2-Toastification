#Requires AutoHotkey v2.0
#Include lib\Toastify.ahk

_fontNames := Map()

Toastify.Start("dark", Toastify.ALIGN.BOTTOM_RIGHT)

themeNames := ["dark", "light", "success", "error", "warning", "info", "midnight", "forest", "neon", "vapor", "cyberpunk", "retro", "glass", "minimal", "pastel", "flat", "success-light", "error-light", "warning-light", "info-light", "midnight-light", "forest-light", "neon-light", "vapor-light", "cyberpunk-light", "retro-light", "glass-light", "minimal-light", "pastel-light", "flat-light"]
positionNames := ["top-left", "top-right", "bottom-left", "bottom-right", "left", "right", "top", "bottom", "center"]
iconNames := ["random", "none", "success", "error", "warning", "info",
    "check", "accept", "cross", "error2", "info2",
    "star", "starFill", "heart", "heartFill", "like", "dislike",
    "flag", "shield", "lock", "power", "refresh", "sync",
    "wifi", "bluetooth", "volume", "mute", "play", "pause", "stop", "record",
    "forward", "back", "chevronLeft", "chevronRight",
    "mail", "send", "reply", "message", "phone", "contact", "people", "group",
    "camera", "webcam", "picture", "video", "music", "audio", "microphone", "search",
    "home", "homeFill", "folder", "folderFill", "save", "delete", "download", "upload",
    "copy", "cut", "paste", "edit", "rename", "settings", "filter", "add", "remove",
    "link", "globe", "world", "calendar", "calendarFill", "clock", "location", "mapPin2",
    "cloud", "help", "code", "lightning", "leaf", "car", "bus", "walk",
    "cart", "package", "pdf", "ringer", "checkbox", "list", "fullscreen", "print",
    "attach", "pin", "shop", "train", "page", "move", "keyboard"]
easingNames := [
    "linear", "ease", "easeIn", "easeOut", "easeInOut",
    "easeInQuad", "easeOutQuad", "easeInOutQuad",
    "easeInCubic", "easeOutCubic", "easeInOutCubic",
    "easeInQuart", "easeOutQuart", "easeInOutQuart",
    "easeInQuint", "easeOutQuint", "easeInOutQuint",
    "easeInBack", "easeOutBack", "easeInOutBack",
    "bounceIn", "bounceOut", "bounceInOut",
    "easeInSine", "easeOutSine", "easeInOutSine",
    "easeInExpo", "easeOutExpo", "easeInOutExpo",
    "easeInCirc", "easeOutCirc", "easeInOutCirc",
    "elasticIn", "elasticOut", "elasticInOut",
    "decelerate", "fastOutSlowIn", "slowMiddle",
    "easeInToLinear", "linearToEaseOut", "fastLinearToSlowEaseIn",
    "easeInOutCubicEmphasized",
]
entranceNames := ["auto", "right", "left", "top", "bottom"]
qualityNames := ["Low", "Medium", "High"]
weightNames := ["Regular", "Bold", "Italic", "BoldItalic"]
fontNames := SystemFonts()

ui := Gui(, "Toastify Theme Generator")
ui.BackColor := "F0F0F0"
ui.SetFont("s10", "Segoe UI")

ui.Add("Text", "x20 y15 w880 h30 +Center", "Toastify Theme Generator").SetFont("s15 bold")

tabs := ui.Add("Tab3", "x20 y50 w880 h500", ["Content", "Appearance", "Typography", "Motion", "Global"])

; ── Tab 1: Content ──
ui.Add("Text", "x40 y90 w70", "Title:")
ui.Add("Edit", "x120 y86 w280 vTitle", "Theme Generator")
ui.Add("Text", "x40 y125 w70", "Body:")
ui.Add("Edit", "x120 y121 w280 h40 vBody Multi", "Your custom toast here.")
ui.Add("Text", "x40 y170 w70", "Icon:")
ui.Add("DropDownList", "x120 y166 w280 vIcon Choose1", iconNames)
ui.Add("Text", "x40 y205 w80", "Icon scale:")
ui.Add("Slider", "x120 y201 w280 vIconScale Range1-4 ToolTip", 1)
ui.Add("Text", "x40 y240 w80", "Icon size:")
ui.Add("Slider", "x120 y236 w280 vIconSize Range16-64 ToolTip", 32)
ui.Add("Text", "x40 y275 w80", "Duration:")
ui.Add("Slider", "x120 y271 w280 vDuration Range0-10000 ToolTip", 4000)
ui.Add("Checkbox", "x40 y310 vPermanent", "Permanent (0)")
ui.Add("Checkbox", "x170 yp vAutoDismiss Checked", "Auto-dismiss")
ui.Add("Checkbox", "x320 yp vShowProgress Checked", "Progress bar")
ui.Add("Checkbox", "x40 y345 vShowClose Checked", "Close button")
ui.Add("Text", "x40 y385 w70", "Action 1:")
ui.Add("Edit", "x120 y381 w280 vAct1", "Open Notepad")
ui.Add("Text", "x40 y420 w70", "Action 2:")
ui.Add("Edit", "x120 y416 w280 vAct2", "Close")
ui.Add("Text", "x40 y455 w70", "Action 3:")
ui.Add("Edit", "x120 y451 w280 vAct3", "")

; ── Tab 2: Appearance ──
tabs.UseTab(2)
ui.Add("Text", "x40 y90 w80", "Theme:")
ui.Add("DropDownList", "x120 y86 w280 vTheme Choose24", themeNames)
ui.Add("Text", "x40 y125 w80", "Position:")
ui.Add("DropDownList", "x120 y121 w280 vPosition Choose8", positionNames)
ui.Add("Text", "x40 y160 w80", "Width (px):")
ui.Add("Slider", "x120 y156 w280 vWidth Range220-600 ToolTip", 340)
ui.Add("Text", "x40 y195 w80", "Min height:")
ui.Add("Slider", "x120 y191 w280 vMinHeight Range80-300 ToolTip", 120)
ui.Add("Text", "x40 y230 w80", "Padding X:")
ui.Add("Slider", "x120 y226 w280 vPaddingX Range0-40 ToolTip", 16)
ui.Add("Text", "x40 y265 w80", "Padding Y:")
ui.Add("Slider", "x120 y261 w280 vPaddingY Range0-40 ToolTip", 14)
ui.Add("Text", "x40 y300 w80", "Radius:")
ui.Add("Slider", "x120 y296 w280 vBorderRadius Range0-40 ToolTip", 18)
ui.Add("Text", "x40 y335 w80", "Border width:")
ui.Add("Slider", "x120 y331 w280 vBorderWidth Range0-6 ToolTip", 0)
ui.Add("Text", "x40 y370 w80", "Opacity (%):")
ui.Add("Slider", "x120 y366 w280 vOpacity Range10-100 ToolTip", 100)
ui.Add("Checkbox", "x40 y405 vOpacityHover Checked", "Fade to 100% on hover")

; ── Tab 3: Typography ──
tabs.UseTab(3)
ui.Add("Text", "x40 y90 w80", "Font:")
ui.Add("DropDownList", "x120 y86 w280 vFontName Choose" Random(1, fontNames.Length), fontNames)
ui.Add("Text", "x40 y125 w80", "Title size:")
ui.Add("Slider", "x120 y121 w280 vFontSizeTitle Range10-32 ToolTip", 16)
ui.Add("Text", "x40 y160 w80", "Body size:")
ui.Add("Slider", "x120 y156 w280 vFontSizeBody Range8-28 ToolTip", 13)
ui.Add("Text", "x40 y195 w80", "Title weight:")
ui.Add("DropDownList", "x120 y191 w280 vFontWeightTitle Choose2", weightNames)
ui.Add("Text", "x40 y230 w80", "Body weight:")
ui.Add("DropDownList", "x120 y226 w280 vFontWeightBody Choose1", weightNames)
ui.Add("Text", "x40 y265 w80", "Render quality:")
ui.Add("DropDownList", "x120 y261 w280 vQuality Choose3", qualityNames)

; ── Tab 4: Motion ──
tabs.UseTab(4)
ui.Add("Checkbox", "x40 y90 vAnimSlide Checked", "Slide")
ui.Add("Checkbox", "x120 yp vAnimFade", "Fade")
ui.Add("Checkbox", "x200 yp vAnimZoom", "Zoom")
ui.Add("Checkbox", "x280 yp vAnimRotate", "Rotate")
ui.Add("Text", "x40 y130 w80", "Easing:")
ui.Add("DropDownList", "x120 y126 w280 vEasing Choose9", easingNames)
ui.Add("Text", "x40 y165 w80", "Entrance:")
ui.Add("DropDownList", "x120 y161 w280 vEntrance Choose1", entranceNames)
ui.Add("Text", "x40 y200 w80", "Anim dur (ms):")
ui.Add("Slider", "x120 y196 w280 vAnimDur Range100-1500 ToolTip", 300)
ui.Add("Text", "x40 y235 w80", "Rotate (deg):")
ui.Add("Slider", "x120 y231 w280 vRotation Range0-45 ToolTip", 10)
ui.Add("Text", "x40 y270 w80", "Repo dur (ms):")
ui.Add("Slider", "x120 y266 w280 vRepoDur Range100-800 ToolTip", 300)

; ── Tab 5: Global ──
tabs.UseTab(5)
ui.Add("Text", "x40 y90 w80", "Margin X:")
ui.Add("Slider", "x120 y86 w280 vMarginX Range0-80 ToolTip", 16)
ui.Add("Text", "x40 y125 w80", "Margin Y:")
ui.Add("Slider", "x120 y121 w280 vMarginY Range0-80 ToolTip", 16)
ui.Add("Text", "x40 y160 w80", "Spacing:")
ui.Add("Slider", "x120 y156 w280 vSpacing Range0-60 ToolTip", 12)
ui.Add("Text", "x40 y195 w80", "Max toasts:")
ui.Add("Slider", "x120 y191 w280 vMaxToasts Range1-20 ToolTip", 8)
ui.Add("Checkbox", "x40 y230 vHoverPause Checked", "Pause progress on hover")

; ── Buttons ──
tabs.UseTab(0)
ui.Add("Button", "x20 y565 w430 h45 Default", "Show Toast").OnEvent("Click", ShowToast)
ui.Add("Button", "x470 y565 w215 h45", "Random").OnEvent("Click", ShowRandom)
ui.Add("Button", "x700 y565 w200 h45", "Generate Code").OnEvent("Click", ShowCode)
ui.Add("Button", "x20 y620 w430 h35", "Dismiss All").OnEvent("Click", (*) => Toastify.DismissAll())

ui.OnEvent("Close", (*) => ExitApp())
ui.Show("w920 h675")
codeGui := 0
randomGui := 0

ShowToast(*) {
    cfg := CollectConfig()
    ShowToastFrom(cfg)
}

ShowRandom(*) {
    global randomGui, randCfg
    if IsObject(randomGui) {
        randomGui.Destroy()
        randomGui := 0
    }
    randCfg := RandomConfig()
    randomGui := Gui(, "Random Theme")
    randomGui.Add("Text", "w360", "Random theme generated:")
    randomGui.Add("Button", "w360 h40", "Generate Random").OnEvent("Click", (*) => RandGenerate())
    randomGui.Add("Button", "w360 h40", "Show Again").OnEvent("Click", (*) => RandShowAgain())
    randomGui.Add("Button", "w360 h40", "Copy Code").OnEvent("Click", (*) => RandCopy())
    randomGui.Show("w400 h220")
}

RandGenerate(*) {
    global randCfg
    randCfg := RandomConfig()
    ShowToastFrom(randCfg, false)
}

RandShowAgain(*) {
    global randCfg
    ShowToastFrom(randCfg, false)
}

RandCopy(*) {
    global randCfg
    A_Clipboard := BuildCode(randCfg)
}

ShowCode(*) {
    ShowCodeWith(CollectConfig())
}

CollectConfig() {
    g := ui.Submit(false)
    animStyle := []
    for pair in [["AnimSlide", "slide"], ["AnimFade", "fade"], ["AnimZoom", "zoom"], ["AnimRotate", "rotate"]]
        if g.%pair[1]%
            animStyle.Push(pair[2])
    if animStyle.Length = 0
        animStyle := ["fade"]
    actions := []
    for label in [g.Act1, g.Act2, g.Act3]
        if Trim(label) != ""
            actions.Push(Trim(label))
    return {
        title: (Trim(g.Title) = "" ? "Theme Generator" : g.Title),
        body: (Trim(g.Body) = "" ? "Your custom toast." : g.Body),
        theme: g.Theme,
        position: g.Position,
        icon: (g.Icon = "random" ? Pick(iconNames) : g.Icon),
        iconScale: g.IconScale,
        iconSize: g.IconSize,
        duration: g.Permanent ? 0 : g.Duration,
        permanent: g.Permanent,
        autoDismiss: g.AutoDismiss,
        showProgress: g.ShowProgress,
        showClose: g.ShowClose,
        actions: actions,
        width: g.Width,
        minHeight: g.MinHeight,
        paddingX: g.PaddingX,
        paddingY: g.PaddingY,
        borderRadius: g.BorderRadius,
        borderWidth: g.BorderWidth,
        opacity: g.Opacity / 100,
        opacityOnHover: g.OpacityHover,
        fontName: g.FontName,
        fontSizeTitle: g.FontSizeTitle,
        fontSizeBody: g.FontSizeBody,
        fontWeightTitle: g.FontWeightTitle,
        fontWeightBody: g.FontWeightBody,
        quality: g.Quality,
        animStyle: animStyle,
        easing: g.Easing,
        entrance: g.Entrance,
        animDuration: g.AnimDur,
        rotationDegree: g.Rotation,
        repoDuration: g.RepoDur,
        marginX: g.MarginX,
        marginY: g.MarginY,
        spacing: g.Spacing,
        maxToasts: g.MaxToasts,
        hoverPauseEnabled: g.HoverPause,
    }
}

RandomConfig() {
    styles := ["slide", "fade", "zoom", "rotate"]
    animStyle := []
    loop Random(1, 3) {
        s := styles[Random(1, styles.Length)]
        if !HasValue(animStyle, s)
            animStyle.Push(s)
    }
    if animStyle.Length = 0
        animStyle := ["fade"]
    actionPool := ["Open Notepad", "Open Calculator", "Open GitHub", "Say Hello", "Copy Link", "Open Settings", "Open Explorer", "Task Manager", "Toggle Mute", "Close"]
    actions := []
    loop Random(0, 3) {
        a := actionPool[Random(1, actionPool.Length)]
        if !HasValue(actions, a)
            actions.Push(a)
    }
    titles := ["Update Available", "Download Complete", "New Message", "Battery Low", "Backup Finished", "Meeting in 10", "Installation Ready", "Sync Completed"]
    bodies := ["v2.1.0 is ready.", "3 files saved.", "You have 1 unread notification.", "Plug in your charger soon.", "Backup finished successfully.", "Don't forget to join the call.", "The new build is ready.", "All files are up to date."]
    return {
        title: Pick(titles),
        body: Pick(bodies),
        theme: Pick(themeNames),
        position: Pick(positionNames),
        icon: Pick(iconNames),
        iconScale: Random(0.8, 1.2),
        iconSize: Random(16, 64),
        duration: Random(0, 1) ? 0 : Random(1500, 8000),
        permanent: false,
        autoDismiss: true,
        showProgress: Random(0, 1) ? true : false,
        showClose: true,
        actions: actions,
        width: Random(240, 480),
        minHeight: Random(80, 200),
        paddingX: Random(8, 24),
        paddingY: Random(8, 24),
        borderRadius: Random(0, 30),
        borderWidth: Random(0, 3),
        opacity: 1,
        opacityOnHover: true,
        fontName: Pick(fontNames),
        fontSizeTitle: Random(12, 24),
        fontSizeBody: Random(10, 18),
        fontWeightTitle: Pick(weightNames),
        fontWeightBody: Pick(weightNames),
        quality: Pick(qualityNames),
        animStyle: animStyle,
        easing: Pick(easingNames),
        entrance: Pick(entranceNames),
        animDuration: Random(150, 900),
        rotationDegree: Random(0, 30),
        repoDuration: Random(150, 500),
        marginX: Random(8, 40),
        marginY: Random(8, 40),
        spacing: Random(6, 30),
        maxToasts: Random(3, 12),
        hoverPauseEnabled: Random(0, 1) ? true : false,
    }
}

ShowToastFrom(cfg, applyLayout := true) {
    if applyLayout {
        Toastify.marginX := cfg.marginX
        Toastify.marginY := cfg.marginY
        Toastify.spacing := cfg.spacing
        Toastify.maxToasts := cfg.maxToasts
        Toastify.hoverPauseEnabled := cfg.hoverPauseEnabled
        Toastify.SetConfig({ minHeight: cfg.minHeight, repoDuration: cfg.repoDuration })
    }
    buttons := []
    for label in cfg.actions
        buttons.Push({ text: label, onClick: ActionCallback(label) })
    opts := {
        position: cfg.position,
        theme: cfg.theme,
        icon: cfg.icon,
        iconScale: cfg.iconScale,
        iconSize: cfg.iconSize,
        animStyle: cfg.animStyle,
        animEasing: cfg.easing,
        animEntrance: cfg.entrance,
        renderQuality: cfg.quality,
        animDuration: cfg.animDuration,
        rotationDegree: cfg.rotationDegree,
        duration: cfg.duration,
        permanent: cfg.permanent,
        showProgress: cfg.showProgress,
        autoDismiss: cfg.autoDismiss,
        opacity: cfg.opacity,
        opacityOnHover: cfg.opacityOnHover,
        width: cfg.width,
        showClose: cfg.showClose,
        borderWidth: cfg.borderWidth,
        paddingX: cfg.paddingX,
        paddingY: cfg.paddingY,
        borderRadius: cfg.borderRadius,
        fontName: cfg.fontName,
        fontSizeTitle: cfg.fontSizeTitle,
        fontSizeBody: cfg.fontSizeBody,
        fontWeightTitle: cfg.fontWeightTitle,
        fontWeightBody: cfg.fontWeightBody,
    }
    Toastify.Show(cfg.title, cfg.body, buttons, opts)
}

ActionCallback(label) {
    if label = "Close"
        return (*) => {}
    if label = "Open Notepad"
        return (*) => Run("notepad.exe")
    if label = "Open Calculator"
        return (*) => Run("calc.exe")
    if label = "Open GitHub"
        return (*) => Run("https://github.com")
    if label = "Say Hello"
        return (*) => ComObject("SAPI.SpVoice").Speak("Hello from Toastify")
    if label = "Copy Link"
        return (*) => (A_Clipboard := "https://github.com/skeletorflet/AHKv2-Toastification")
    if label = "Open Settings"
        return (*) => Run("ms-settings:")
    if label = "Open Explorer"
        return (*) => Run("explorer.exe")
    if label = "Task Manager"
        return (*) => Run("taskmgr.exe")
    if label = "Toggle Mute"
        return (*) => Send("{Volume_Mute}")
    return (*) => MsgBox(label " pressed")
}

ShowCodeWith(cfg) {
    global codeGui, codeEdit
    if IsObject(codeGui) {
        codeGui.Destroy()
        codeGui := 0
    }
    codeGui := Gui(, "Replication Code")
    codeGui.SetFont("s9", "Consolas")
    codeEdit := codeGui.Add("Edit", "w680 h460 Multi ReadOnly", BuildCode(cfg))
    codeGui.Add("Button", "w330", "Copy to Clipboard").OnEvent("Click", (*) => (A_Clipboard := codeEdit.Text))
    codeGui.Add("Button", "x+10 w330", "Show Again").OnEvent("Click", (*) => ShowToastFrom(cfg))
    codeGui.Show("w700 h520")
}

BuildCode(cfg) {
    lines := []
    lines.Push("#Requires AutoHotkey v2.0")
    lines.Push("#Include lib\Toastify.ahk")
    lines.Push("")
    lines.Push('Toastify.Start("dark", "bottom-right")')
    lines.Push('Toastify.SetConfig({ minHeight: ' cfg.minHeight ', repoDuration: ' cfg.repoDuration ' })')
    lines.Push('Toastify.marginX := ' cfg.marginX)
    lines.Push('Toastify.marginY := ' cfg.marginY)
    lines.Push('Toastify.spacing := ' cfg.spacing)
    lines.Push('Toastify.maxToasts := ' cfg.maxToasts)
    lines.Push('Toastify.hoverPauseEnabled := ' (cfg.hoverPauseEnabled ? "true" : "false"))
    lines.Push("")
    actions := ""
    if cfg.actions.Length > 0 {
        parts := []
        for label in cfg.actions {
            if label = "Close"
                parts.Push('{ text: "Close", onClick: (*) => {} }')
            else
                parts.Push('{ text: "' label '", onClick: (*) => Run("notepad.exe") }')
        }
        actions := "[" JoinParts(parts) "]"
    } else
        actions := "[]"
    lines.Push('Toastify.Show("' cfg.title '", "' cfg.body '", ' actions ', {')
    lines.Push('    position: "' cfg.position '",')
    lines.Push('    theme: "' cfg.theme '",')
    lines.Push('    icon: "' cfg.icon '",')
    lines.Push('    iconScale: ' cfg.iconScale ',')
    lines.Push('    iconSize: ' cfg.iconSize ',')
    lines.Push('    width: ' cfg.width ',')
    lines.Push('    paddingX: ' cfg.paddingX ',')
    lines.Push('    paddingY: ' cfg.paddingY ',')
    lines.Push('    borderRadius: ' cfg.borderRadius ',')
    lines.Push('    borderWidth: ' cfg.borderWidth ',')
    lines.Push('    fontName: "' cfg.fontName '",')
    lines.Push('    fontSizeTitle: ' cfg.fontSizeTitle ',')
    lines.Push('    fontSizeBody: ' cfg.fontSizeBody ',')
    lines.Push('    fontWeightTitle: "' cfg.fontWeightTitle '",')
    lines.Push('    fontWeightBody: "' cfg.fontWeightBody '",')
    styleStr := '['
    for i, s in cfg.animStyle
        styleStr .= (i > 1 ? ", " : "") '"' s '"'
    styleStr .= ']'
    lines.Push('    animStyle: ' styleStr ',')
    lines.Push('    animEasing: "' cfg.easing '",')
    lines.Push('    animEntrance: "' cfg.entrance '",')
    lines.Push('    renderQuality: "' cfg.quality '",')
    lines.Push('    animDuration: ' cfg.animDuration ',')
    lines.Push('    rotationDegree: ' cfg.rotationDegree ',')
    lines.Push('    duration: ' cfg.duration ',')
    if cfg.permanent
        lines.Push('    permanent: true,')
    lines.Push('    autoDismiss: ' (cfg.autoDismiss ? "true" : "false") ',')
    lines.Push('    showProgress: ' (cfg.showProgress ? "true" : "false") ',')
    lines.Push('    showClose: ' (cfg.showClose ? "true" : "false") ',')
    lines.Push('    opacity: ' cfg.opacity ',')
    lines.Push('    opacityOnHover: ' (cfg.opacityOnHover ? "true" : "false") ',')
    lines.Push('})')
    out := ""
    for line in lines
        out .= line "`n"
    return RTrim(out, "`n")
}

JoinParts(parts) {
    out := ""
    for i, p in parts
        out .= (i > 1 ? ", " : "") p
    return out
}

HasValue(haystack, needle) {
    for v in haystack
        if v == needle
            return true
    return false
}

Pick(arr) => arr[Random(1, arr.Length)]

; ── all fonts installed on the system ──────────────────────
SystemFonts() {
    hdc := DllCall("GetDC", "ptr", 0, "ptr")
    lf := Buffer(92, 0)
    NumPut("uchar", 1, lf, 23)          ; lfCharSet = DEFAULT_CHARSET → every family
    cb := CallbackCreate(EnumFontFamProc, 0, 4)
    DllCall("EnumFontFamiliesEx", "ptr", hdc, "ptr", lf, "ptr", cb, "ptr", 0, "uint", 0)
    DllCall("ReleaseDC", "ptr", 0, "ptr", hdc)
    CallbackFree(cb)
    s := ""
    for n in _fontNames
        s .= n "`n"
    Sort(s)
    arr := StrSplit(s, "`n")
    if arr.Length && arr[arr.Length] = ""
        arr.Pop()
    return arr
}
EnumFontFamProc(lf, ntm, fontType, lParam) {
    name := StrGet(lf + 28, 32, "UTF-16")
    if name && SubStr(name, 1, 1) != "@"        ; skip @ vertical variants
        _fontNames[name] := true
    return 1
}