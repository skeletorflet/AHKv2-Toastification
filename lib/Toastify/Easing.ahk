class ToastEasing {
    static defaultEasing := "easeOutCubic"
    static funcs := 0
    static linear(t) => t
    static easeInQuad(t) => t * t
    static easeOutQuad(t) => t * (2 - t)
    static easeInOutQuad(t) => (t < 0.5) ? (2 * t * t) : (-1 + (4 - 2 * t) * t)
    static easeInCubic(t) => t * t * t
    static easeOutCubic(t) => (--t) * t * t + 1
    static easeInOutCubic(t) => (t < 0.5) ? (4 * t * t * t) : ((t - 1) * (2 * t - 2) * (2 * t - 2) + 1)
    static easeInQuart(t) => t * t * t * t
    static easeOutQuart(t) => 1 - (--t) * t * t * t
    static easeInOutQuart(t) => (t < 0.5) ? (8 * t * t * t * t) : (1 - 8 * (--t) * t * t * t)
    static easeInBack(t) {
        c1 := 1.70158
        c3 := c1 + 1
        return c3 * t * t * t - c1 * t * t
    }
    static easeOutBack(t) {
        c1 := 1.70158
        c3 := c1 + 1
        return 1 + c3 * ((t - 1) ** 3) + c1 * ((t - 1) ** 2)
    }
    static easeInOutBack(t) {
        c1 := 1.70158
        c2 := c1 * 1.525
        return (t < 0.5)
            ? ((2 * t) ** 2 * ((c2 + 1) * 2 * t - c2)) / 2
        : ((2 * t - 2) ** 2 * ((c2 + 1) * (t * 2 - 2) + c2) + 2) / 2
    }
    static easeInQuint(t) => t * t * t * t * t
    static easeOutQuint(t) => 1 + (--t) * t * t * t * t
    static easeInOutQuint(t) => (t < 0.5) ? (16 * t * t * t * t * t) : (1 + 16 * (--t) * t * t * t * t)
    static easeInSine(t) => 1 - Cos((t * 3.14159265359) / 2)
    static easeOutSine(t) => Sin((t * 3.14159265359) / 2)
    static easeInOutSine(t) => -(Cos(3.14159265359 * t) - 1) / 2
    static easeInExpo(t) => (t = 0) ? 0 : (2 ** (10 * t - 10))
    static easeOutExpo(t) => (t = 1) ? 1 : (1 - 2 ** (-10 * t))
    static easeInOutExpo(t) {
        if (t = 0)
            return 0
        if (t = 1)
            return 1
        return (t < 0.5) ? (2 ** (20 * t - 10)) / 2 : (2 - 2 ** (-20 * t + 10)) / 2
    }
    static easeInCirc(t) => 1 - Sqrt(1 - (t ** 2))
    static easeOutCirc(t) => Sqrt(1 - ((t - 1) ** 2))
    static easeInOutCirc(t) => (t < 0.5)
        ? (1 - Sqrt(1 - (2 * t) ** 2)) / 2
        : (Sqrt(1 - (-2 * t + 2) ** 2) + 1) / 2
    static elasticIn(t) {
        c4 := (2 * 3.14159265359) / 3
        return (t = 0) ? 0 : (t = 1) ? 1 : -(2 ** (10 * t - 10)) * Sin((t * 10 - 10.75) * c4)
    }
    static elasticOut(t) {
        c4 := (2 * 3.14159265359) / 3
        return (t = 0) ? 0 : (t = 1) ? 1 : (2 ** (-10 * t)) * Sin((t * 10 - 0.75) * c4) + 1
    }
    static elasticInOut(t) {
        c5 := (2 * 3.14159265359) / 4.5
        return (t = 0) ? 0
        : (t = 1) ? 1
        : (t < 0.5) ? -((2 ** (20 * t - 10)) * Sin((20 * t - 11.125) * c5)) / 2
        : ((2 ** (-20 * t + 10)) * Sin((20 * t - 11.125) * c5)) / 2 + 1
    }
    static bounce(t) => ToastEasing.bounceOut(t)
    static bounceOut(t) {
        n1 := 7.5625
        d1 := 2.75
        if (t < 1 / d1) {
            return n1 * t * t
        } else if (t < 2 / d1) {
            t -= 1.5 / d1
            return n1 * t * t + 0.75
        } else if (t < 2.5 / d1) {
            t -= 2.25 / d1
            return n1 * t * t + 0.9375
        } else {
            t -= 2.625 / d1
            return n1 * t * t + 0.984375
        }
    }
    static bounceIn(t) => 1 - ToastEasing.bounceOut(1 - t)
    static bounceInOut(t) => (t < 0.5)
        ? (1 - ToastEasing.bounceOut(1 - 2 * t)) / 2
        : (1 + ToastEasing.bounceOut(2 * t - 1)) / 2
    static decelerate(t) => 1 - ((1 - t) * (1 - t))
    static ease(t) => ToastEasing.easeInOutCubic(t)
    static easeIn(t) => ToastEasing.easeInCubic(t)
    static easeOut(t) => ToastEasing.easeOutCubic(t)
    static easeInOut(t) => ToastEasing.easeInOutCubic(t)
    static fastOutSlowIn(t) => ToastEasing.easeInOutCubic(t)
    static slowMiddle(t) {
        if (t < 0.5)
            return ToastEasing.easeInCubic(t * 2) / 2
        return 0.5 + ToastEasing.easeOutCubic((t - 0.5) * 2) / 2
    }
    static easeInToLinear(t) => (t < 0.5) ? ToastEasing.easeInCubic(t * 2) / 2 : 0.5 + (t - 0.5)
    static linearToEaseOut(t) => (t < 0.5) ? t : 0.5 + ToastEasing.easeOutCubic((t - 0.5) * 2) / 2
    static fastLinearToSlowEaseIn(t) {
        linearEnd := 0.5
        if (t < linearEnd)
            return t / linearEnd * 0.5
        return 0.5 + ToastEasing.easeInCubic((t - linearEnd) / (1 - linearEnd)) / 2
    }
    static easeInOutCubicEmphasized(t) {
        c := 1.4
        if (t < 0.5)
            return (c * 4 * t * t * t)
        return (c / 2) + (1 - c / 2) * (1 - ((-2 * t + 2) ** 3))
    }
    static getEasing(name, t) {
        ; NOTE: class-method Funcs take `this` as hidden first arg.
        return ToastEasing.resolve(name).Call(ToastEasing, t)
    }
    ; Resolve once, call per-frame: avoids Map lookup + dynamic dispatch at 60Hz.
    static resolve(name) {
        if (!ToastEasing.funcs)
            ToastEasing._init()
        if (ToastEasing.funcs.Has(name))
            return ToastEasing.funcs[name]
        return ToastEasing.easeOutCubic
    }
    static _init() {
        ToastEasing.funcs := Map(
                "linear", ToastEasing.linear,
                "easeInQuad", ToastEasing.easeInQuad,
                "easeOutQuad", ToastEasing.easeOutQuad,
                "easeInOutQuad", ToastEasing.easeInOutQuad,
                "easeInCubic", ToastEasing.easeInCubic,
                "easeOutCubic", ToastEasing.easeOutCubic,
                "easeInOutCubic", ToastEasing.easeInOutCubic,
                "easeInQuart", ToastEasing.easeInQuart,
                "easeOutQuart", ToastEasing.easeOutQuart,
                "easeInOutQuart", ToastEasing.easeInOutQuart,
                "easeInBack", ToastEasing.easeInBack,
                "easeOutBack", ToastEasing.easeOutBack,
                "easeInOutBack", ToastEasing.easeInOutBack,
                "bounce", ToastEasing.bounceOut,
                "bounceOut", ToastEasing.bounceOut,
                "bounceIn", ToastEasing.bounceIn,
                "bounceInOut", ToastEasing.bounceInOut,
                "easeInSine", ToastEasing.easeInSine,
                "easeOutSine", ToastEasing.easeOutSine,
                "easeInOutSine", ToastEasing.easeInOutSine,
                "easeInExpo", ToastEasing.easeInExpo,
                "easeOutExpo", ToastEasing.easeOutExpo,
                "easeInOutExpo", ToastEasing.easeInOutExpo,
                "easeInCirc", ToastEasing.easeInCirc,
                "easeOutCirc", ToastEasing.easeOutCirc,
                "easeInOutCirc", ToastEasing.easeInOutCirc,
                "easeInQuint", ToastEasing.easeInQuint,
                "easeOutQuint", ToastEasing.easeOutQuint,
                "easeInOutQuint", ToastEasing.easeInOutQuint,
                "elasticIn", ToastEasing.elasticIn,
                "elasticOut", ToastEasing.elasticOut,
                "elasticInOut", ToastEasing.elasticInOut,
                "decelerate", ToastEasing.decelerate,
                "ease", ToastEasing.ease,
                "easeIn", ToastEasing.easeIn,
                "easeOut", ToastEasing.easeOut,
                "easeInOut", ToastEasing.easeInOut,
                "fastOutSlowIn", ToastEasing.fastOutSlowIn,
                "slowMiddle", ToastEasing.slowMiddle,
                "easeInToLinear", ToastEasing.easeInToLinear,
                "linearToEaseOut", ToastEasing.linearToEaseOut,
                "fastLinearToSlowEaseIn", ToastEasing.fastLinearToSlowEaseIn,
                "easeInOutCubicEmphasized", ToastEasing.easeInOutCubicEmphasized
            )
    }
}
