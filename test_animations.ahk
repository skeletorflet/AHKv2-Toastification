#Requires AutoHotkey v2.0
#Include lib\Toastification.ahk
CoordMode 'Mouse', 'Screen'
; Initialize Toastification
Toastify.Start("dark", "top-right")

; Global config for demo
Toastify.SetConfig({
    width: 250,
    animDuration: 500
})

; GUI for Testing
myGui := Gui(, "Toast Animation Tester")
myGui.BackColor := "F0F0F0"
myGui.SetFont("s10", "Segoe UI")

myGui.Add("Text", "x20 y20 w300 h30 +Center", "Toastification Animation Lab").SetFont("s14 bold")

; --- Global Theme ---
myGui.Add("GroupBox", "x20 y60 w320 h60", "Toast Color Theme")
myGui.Add("Radio", "xp+20 yp+25 vThemeDark Checked", "Dark Mode")
myGui.Add("Radio", "x+40 yp vThemeLight", "Light Mode")

; --- Toast Type ---
myGui.Add("GroupBox", "x20 y+20 w320 h80", "Toast Type")
myGui.Add("DropDownList", "xp+20 yp+30 w280 vToastType Choose1", [
    "Random", "success", "error", "warning", "info", "neon",
    "vapor", "pastel", "flat", "cyberpunk", "retro", "glass", "minimal", "midnight", "forest"
])

; --- Animation Style ---
myGui.Add("GroupBox", "x20 y+20 w320 h150", "Animation Style (Mix & Match)")
myGui.Add("Checkbox", "xp+20 yp+30 vAnimSlide", "Slide")
myGui.Add("Checkbox", "xp y+10 vAnimFade", "Fade")
myGui.Add("Checkbox", "xp y+10 vAnimZoom", "Zoom")
myGui.Add("Checkbox", "xp y+10 vAnimRotate", "Rotate")
myGui.Add("Checkbox", "xp y+20 vAnimRandom Checked", "Random Mix")

; --- Settings ---
myGui.Add("GroupBox", "x20 y+20 w320 h210", "Settings")

myGui.Add("Text", "xp+20 yp+30 w100", "Duration (ms):")
myGui.Add("Slider", "x+10 yp-5 w160 vDuration Range100-2000 ToolTip", 500)
myGui.Add("Checkbox", "x40 y+10 vRandomDuration Checked", "Random Duration")

myGui.Add("Checkbox", "x40 y+20 vShowProgress Checked", "Show Progress Bar")
myGui.Add("Checkbox", "x40 y+10 vPermanent", "Permanent (manual close)")

myGui.Add("Text", "x40 y+20 w100", "Easing:")
myGui.Add("DropDownList", "x+10 yp-5 w160 vEasing Choose1", [
    "Random",
    "easeOutCubic", "linear", "ease", "easeIn", "easeOut", "easeInOut",
    "easeInQuad", "easeOutQuad", "easeInOutQuad",
    "easeInCubic", "easeInOutCubic",
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
    "easeInOutCubicEmphasized"
])

myGui.Add("Text", "x40 y+15 w100", "Entrance:")
myGui.Add("DropDownList", "x+10 yp-5 w160 vEntrance Choose1", ["random", "auto", "right", "left", "top", "bottom"])

myGui.Add("Text", "x40 y+15 w100", "Quality:")
myGui.Add("DropDownList", "x+10 yp-5 w160 vRenderQuality Choose3", ["Low", "Medium", "High"])

; --- Actions ---
myGui.Add("Button", "x20 y+30 w150 h40", "Show Toast").OnEvent("Click", ShowToast)
myGui.Add("Button", "x+20 w150 h40", "Dismiss All").OnEvent("Click", (*) => Toastify.DismissAll())

myGui.Show("w360 h780")

ShowToast(*) {
    saved := myGui.Submit(false)

    ; === Apply Global Theme ===
    globalTheme := saved.ThemeDark ? "dark" : "light"
    Toastify.theme := globalTheme

    ; === Random Toast Type ===
    types := ["success", "error", "warning", "info", "neon", "vapor", "pastel", "flat", "cyberpunk", "retro", "glass",
        "minimal", "midnight", "forest"]
    toastType := (saved.ToastType = "Random") ? types[Random(1, types.Length)] : saved.ToastType

    ; === Random Animation Style ===
    style := []

    if (saved.AnimRandom) {
        ; Randomly pick styles
        animOptions := ["slide", "fade", "zoom", "rotate"]
        loop Random(1, 4) {
            val := animOptions[Random(1, animOptions.Length)]
            if (!HasValue(style, val))
                style.Push(val)
        }
    } else {
        if (saved.AnimSlide)
            style.Push("slide")
        if (saved.AnimFade)
            style.Push("fade")
        if (saved.AnimZoom)
            style.Push("zoom")
        if (saved.AnimRotate)
            style.Push("rotate")
    }

    ; Default to fade if nothing selected
    if (style.Length == 0)
        style.Push("fade")

    styleStr := ""
    for s in style
        styleStr .= s . " + "
    styleStr := RTrim(styleStr, " + ")

    ; === Random Entrance ===
    entrance := saved.Entrance
    if (entrance = "random") {
        dirs := ["auto", "right", "left", "top", "bottom"]
        entrance := dirs[Random(1, dirs.Length)]
    }

    ; === Random Easing ===
    easingCurves := [
        "easeOutCubic", "linear", "ease", "easeIn", "easeOut", "easeInOut",
        "easeInQuad", "easeOutQuad", "easeInOutQuad",
        "easeInCubic", "easeInOutCubic",
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
        "easeInOutCubicEmphasized"
    ]
    easing := (saved.Easing = "Random") ? easingCurves[Random(1, easingCurves.Length)] : saved.Easing

    ; === Random Duration ===
    duration := saved.RandomDuration ? Random(200, 1500) : saved.Duration

    ; === Random Titles and Bodies ===
    titles := Map(
        "success", ["Success!", "Great Job!", "Well Done!", "Perfect!", "Awesome!"],
        "error", ["Error!", "Oops!", "Failed!", "Something went wrong", "Oh no!"],
        "warning", ["Warning!", "Heads up!", "Careful!", "Notice", "Attention!"],
        "info", ["Info", "Did you know?", "Tip", "Note", "FYI"],
        "neon", ["Neon Style!", "Cyberpunk!", "Futuristic!", "Glow Mode!", "RGB!"],
        "vapor", ["Aesthetics", "Synthwave", "Retro Future", "Vaporwave", "Chill"],
        "pastel", ["Soft & Gentle", "Calm", "Peaceful", "Relaxing", "Smooth"],
        "flat", ["Clean UI", "Minimalist", "Simple", "Flat Design", "Modern"],
        "cyberpunk", ["Wake up Samurai", "High Tech", "Low Life", "System Override", "Glitch"],
        "retro", ["System Ready", "C:\>", "Loading...", "Access Granted", "Terminal"],
        "glass", ["Translucent", "Glassmorphism", "See Through", "Crystal Clear", "Frost"],
        "minimal", ["Less is More", "Simple", "Clean", "Basic", "Pure"],
        "midnight", ["Deep Blue", "Night Mode", "Darkness", "Midnight", "Abyss"],
        "forest", ["Nature", "Greenery", "Fresh", "Eco", "Organic"]
    )

    bodies := Map(
        "success", ["Operation completed successfully!", "Your changes have been saved.", "Task accomplished!",
            "Everything worked perfectly!"],
        "error", ["Could not complete the operation.", "An unexpected error occurred.", "Please try again later.",
            "Failed to process request."],
        "warning", ["This action might have consequences.", "Please review before continuing.", "Proceed with caution!",
            "Something needs your attention."],
        "info", ["This is an informational message.", "Here's something interesting...", "Just letting you know!",
            "Quick update for you."],
        "neon", ["Welcome to the future! ✨", "Glow in the dark mode activated! 🌟", "RGB everything! 🎨",
            "Neon vibes only! 💫"],
        "vapor", ["Listening to synthwave... 🎵", "Sunset drive... 🚗", "Digital dreams... 💾",
            "Retro aesthetics... 🌴"],
        "pastel", ["Soft colors for a calm mind. 🌸", "Gentle vibes only. 🍦", "Relax and enjoy. ☁️",
            "Smooth and sweet. 🍬"],
        "flat", ["No gradients, just color. 🎨", "Clean and simple design. 📐", "Modern flat UI. 🖥️",
            "Less clutter, more focus. 🎯"],
        "cyberpunk", ["System compromised. 🤖", "Neural link established. 🧠", "Hacking the mainframe... 💻",
            "Neon city lights. 🌃"],
        "retro", ["Command executed successfully.", "System initialization complete.", "User authenticated.",
            "Welcome back, user."],
        "glass", ["Blurring the lines... 🌫️", "Crystal clear notification. 💎", "Modern glass effect. 🪟",
            "See-through elegance. ✨"],
        "minimal", ["Just the essentials.", "Black and white.", "High contrast.", "Simple and effective."],
        "midnight", ["Dark mode enabled. 🌙", "Deep blue sea. 🌊", "Night time vibes. 🦉", "Calm and cool. ❄️"],
        "forest", ["Fresh from nature. 🍃", "Greenery", "Fresh", "Eco", "Organic. 🌿"]
    )

    titleList := titles.Has(toastType) ? titles[toastType] : ["Toast!"]
    bodyList := bodies.Has(toastType) ? bodies[toastType] : ["This is a test toast."]

    title := titleList[Random(1, titleList.Length)]
    body := bodyList[Random(1, bodyList.Length)]

    ; === Combine toast type with theme mode ===
    ; If light mode: use "success-light", "error-light", etc.
    ; If dark mode: use "success", "error", etc. (default)
    themeName := toastType
    if (globalTheme = "light") {
        themeName := toastType . "-light"
    }

    lifetime := saved.Permanent ? 0 : 3000
    opts := {
        animStyle: style,
        animEasing: easing,
        animEntrance: entrance,
        animDuration: duration,
        duration: lifetime,
        theme: themeName,
        showProgress: saved.Permanent ? false : saved.ShowProgress,
        renderQuality: saved.RenderQuality,
        permanent: saved.Permanent
    }

    modeStr := saved.Permanent ? "Permanent (manual)" : (saved.ShowProgress ? "Timed with progress" : "Timed")
    Toastify.Show(title, body . "`nType: " . toastType . " | Theme: " . themeName . " | Anim: " . styleStr .
        "`nEasing: " . easing . " | AnimDur: " . duration . "ms" . "`nMode: " . modeStr . " | Quality: " . saved.RenderQuality,
        [], opts)
}

HasValue(haystack, needle) {
    for v in haystack
        if (v == needle)
            return true
    return false
}
