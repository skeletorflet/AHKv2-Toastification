#Requires AutoHotkey v2.0
#Include lib\Toastify.ahk
#Include lib\MouseTrail.ahk
#Include OnMouseMove.ahk
CoordMode 'Mouse', 'Screen'
; Initialize Toastification
Toastify.Start("dark", "top-right")

; Global config for demo
Toastify.SetConfig({
    width: 500,
    animDuration: 500,
    rotationDegree: 90,
})

; GUI for Testing
myGui := Gui(, "Toast Animation Tester")
myGui.BackColor := "F0F0F0"
myGui.SetFont("s10", "Segoe UI")

myGui.Add("Text", "x20 y20 w680 h30 +Center", "Toastification Animation Lab").SetFont("s14 bold")

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

; --- Mouse Trail (GDI+ overlay, tracker OnMouseMove) ---
trail := 0  ; se crea lazy en ToggleTrail
myGui.Add("GroupBox", "x360 y60 w340 h400", "Mouse Trail (GDI+)")
myGui.Add("Text", "xp+20 yp+30 w100", "Effect:")
effCtl := myGui.Add("DropDownList", "x+10 yp-5 w160 vTrailEffect Choose1", ["mix", "comet", "ribbon", "particles", "snake"])
effCtl.OnEvent("Change", (*) => (IsObject(trail) && trail.SetEffect(effCtl.Text)))
myGui.Add("Text", "x400 y+15 w100", "Length:")
lenCtl := myGui.Add("Slider", "x+10 yp-5 w160 vTrailLength Range4-80 ToolTip", 32)
lenCtl.OnEvent("Change", (*) => (IsObject(trail) && trail.SetLength(lenCtl.Value)))
myGui.Add("Text", "x400 y+15 w100", "Size:")
sizeCtl := myGui.Add("Slider", "x+10 yp-5 w160 vTrailSize Range4-32 ToolTip", 14)
sizeCtl.OnEvent("Change", (*) => (IsObject(trail) && trail.SetSize(sizeCtl.Value)))
rainbowCtl := myGui.Add("Checkbox", "x400 y+15 vTrailRainbow", "Rainbow")
rainbowCtl.OnEvent("Click", (*) => (IsObject(trail) && trail.SetRainbow(rainbowCtl.Value)))
ripplesCtl := myGui.Add("Checkbox", "x+20 yp vTrailRipples Checked", "Ripples on click")
ripplesCtl.OnEvent("Click", (*) => (IsObject(trail) && trail.EnableRipples(ripplesCtl.Value)))
smoothCtl := myGui.Add("Checkbox", "x400 y+15 vTrailSmooth Checked", "Smooth follow")
smoothCtl.OnEvent("Click", (*) => (IsObject(trail) && trail.SetSmoothing(smoothCtl.Value)))
myGui.Add("Text", "x400 y+15 w100", "Follow:")
followCtl := myGui.Add("Slider", "x+10 yp-5 w160 vTrailFollow Range0-100 ToolTip", 35)
followCtl.OnEvent("Change", (*) => (IsObject(trail) && trail.SetFollow(followCtl.Value / 100)))
myGui.Add("Text", "x400 y+15 w100", "Curve:")
tensionCtl := myGui.Add("Slider", "x+10 yp-5 w160 vTrailTension Range0-6 ToolTip", 3)
tensionCtl.OnEvent("Change", (*) => (IsObject(trail) && trail.SetTension(tensionCtl.Value)))
myGui.Add("Text", "x400 y+15 w100", "Tail:")
tailCtl := myGui.Add("Slider", "x+10 yp-5 w160 vTrailTail Range0-24 ToolTip", 10)
tailCtl.OnEvent("Change", (*) => (IsObject(trail) && trail.SetTail(tailCtl.Value)))
myGui.Add("Text", "x400 y+15 w100", "Tail%:")
tailStartCtl := myGui.Add("Slider", "x+10 yp-5 w160 vTrailTailStart Range0-90 ToolTip", 60)
tailStartCtl.OnEvent("Change", (*) => (IsObject(trail) && trail.SetTailStart(tailStartCtl.Value)))
myGui.Add("Text", "x400 y+15 w100", "Pulse:")
pulseCtl := myGui.Add("Slider", "x+10 yp-5 w160 vTrailPulse Range-100-100 ToolTip", 40)
pulseCtl.OnEvent("Change", (*) => (IsObject(trail) && trail.SetPulse(pulseCtl.Value)))
trailBtn := myGui.Add("Button", "x400 y+15 w280 h30", "Start Trail (F9)")
trailBtn.OnEvent("Click", ToggleTrail)

; --- Actions ---
myGui.Add("Button", "x380 y480 w150 h40", "Show Toast").OnEvent("Click", ShowToast)
myGui.Add("Button", "x550 y480 w150 h40", "Dismiss All").OnEvent("Click", (*) => Toastify.DismissAll())
myGui.Add("Text", "x380 y535 w320 h40", "Atajos con trail activo: 1 mix · 2 comet · 3 ribbon · 4 particles · 5 snake")
myGui.OnEvent('Close', (*) => (IsObject(trail) ? trail.Dispose() : 0, ExitApp()))
myGui.Show("w720 h660")

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
    ; MsgBox opts.theme
    modeStr := saved.Permanent ? "Permanent (manual)" : (saved.ShowProgress ? "Timed with progress" : "Timed")
    Toastify.Show(
        title,
        body . "`nType: " . toastType . " | Theme: " . themeName . " | Anim: " . styleStr .
        "`nEasing: " . easing . " | AnimDur: " . duration . "ms" . "`nMode: " . modeStr . " | Quality: " . saved.RenderQuality,
        [], opts)
}

HasValue(haystack, needle) {
    for v in haystack
        if (v == needle)
            return true
    return false
}

; === Mouse Trail wiring ===
ToggleTrail(*) {
    global trail, trailBtn, myGui
    saved := myGui.Submit(false)
    if (!IsObject(trail))
        trail := MouseTrail({ effect: saved.TrailEffect })
    trail.SetEffect(saved.TrailEffect)
    trail.SetLength(saved.TrailLength)
    trail.SetSize(saved.TrailSize)
    trail.SetRainbow(saved.TrailRainbow)
    trail.SetSmoothing(saved.TrailSmooth)
    trail.SetFollow(saved.TrailFollow / 100)
    trail.SetTension(saved.TrailTension)
    trail.SetTail(saved.TrailTail)
    trail.SetTailStart(saved.TrailTailStart)
    trail.SetPulse(saved.TrailPulse)
    trail.EnableRipples(saved.TrailRipples)
    trail.Toggle()
    trailBtn.Text := trail.running ? "Stop Trail (F9)" : "Start Trail (F9)"
}

F9::ToggleTrail()

SetTrailEffect(name, idx) {
    global trail, effCtl
    trail.SetEffect(name)
    try effCtl.Value := idx
}

#HotIf IsObject(trail) && trail.running
1::SetTrailEffect("mix", 1)
2::SetTrailEffect("comet", 2)
3::SetTrailEffect("ribbon", 3)
4::SetTrailEffect("particles", 4)
5::SetTrailEffect("snake", 5)
#HotIf