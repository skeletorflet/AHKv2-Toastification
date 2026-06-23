# Toastification - Plan de Mejoras

## 🔴 CRÍTICAS

- [x] **#1 Doble render por frame en zoom/rotate**
  - `Tick()` llama `RenderToWindow()` en líneas 1701/1711 Y luego `UpdateWindow()` al final (1838)
  - Solución: Remover las llamadas directas a `RenderToWindow()` dentro de los bloques zoom/rotate, dejar que `dirty` + `UpdateWindow()` al final se encargue

- [x] **#2 Timer no compensa tiempo de ejecución**
  - `SetTimer(__globalTimer, -16)` se reinicia al inicio del tick sin medir cuánto tardó
  - Solución: Medir `A_TickCount` antes/después y ajustar el delay: `SetTimer(..., -Max(1, 16 - elapsed))`

- [x] **#3 Cálculo de `animEntrance` repetido cada frame**
  - La resolución de `"auto"` → dirección se ejecuta 60+ veces/seg dentro de `Tick()`
  - Solución: Calcular una vez en `InitAnimation()` y guardar en una propiedad `this.resolvedEntrance`

- [x] **#4 Falta DPI awareness**
  - Sin `SetProcessDpiAwareness`, en HiDPI todo se posiciona mal
  - Solución: Agregar `DllCall("SetProcessDpiAwarenessContext", ...)` con fallback a `SetProcessDpiAwareness` al inicio de `Toastify.Start()`

- [x] **#5 `timeBeginPeriod(1)` afecta todo el sistema**
  - Modifica la resolución de timer global de Windows para todos los procesos
  - Solución: Cambiar a 2ms (suficiente para 60fps), documentar impacto系统级 con WARNING comment

- [x] **#6 `bounce` y `bounceOut` son funciones idénticas duplicadas**
  - `ToastEasing.bounce()` (línea 54) y `bounceOut()` (línea 216) tienen la misma lógica
  - Solución: Unificar — `bounce()` ahora es alias de `bounceOut()` en una sola línea

---

## 🟡 MEDIAS

- [x] **#7 `ToastEasing.get()` usa if-else masivo**
  - 50+ comparaciones string por frame por toast
  - Solución: Reemplazar con `Map` de funciones: `static funcs := Map("linear", ToastEasing.linear, ...)`

- [x] **#8 Clonamiento excesivo de arrays**
  - `.Clone()` en `__globalTick` y `__mouseTimerTick` crea basura GC ~120 veces/seg
  - Solución: Iterar directamente con `for i, t in Toastify.toasts` ( AHK v2 lo permite) y usar flag `modified` si se necesita mutar durante iteración

- [x] **#9 GDI+ brushes/pens creados/destruidos en cada `Draw()`**
  - ~4800 operaciones GDI+/seg con 8 toasts a 60fps
  - Solución: Crear brushes/pen una vez por tema en `ToastTheme.Register()` y reutilizarlos; cachear en propiedad estática del tema

- [x] **#10 `StartExit()` tiene búsqueda lineal O(n²)**
  - Loop interno + búsqueda en `Dismiss()`
  - Solución: Usar `hasProp` o un Set/Map para tracking de pertenencia, o simplemente buscar una vez con `for i, t in` y usar `RemoveAt(i)` directo sin loop

- [x] **#11 `ResizeBuffer()` solo crece**
  - Buffers de rotación (~500x500) nunca se liberan
  - Solución: Después de que la animación de entrada completa (`animState == "idle"`), si el buffer es > 1.5x el tamaño del toast, recrear al tamaño original

- [x] **#12 Idle lerp no es framerate-independiente**
  - Factor `0.2` asume 60fps
  - Solución: Usar `factor := 1 - (0.8 ** (elapsed / 16.67))` o multiplicar por `deltaTime / 16.67`

- [x] **#13 Código duplicado de hover en exiting toasts**
  - `__mouseTimerTick()` líneas 617-639 duplica 642-660
  - Solución: Extraer a `__checkHoverForToast(t, x, y)` y llamarlo para ambos arrays

- [x] **#14 Toast al 100% con hover queda vivo indefinidamente**
  - Si el mouse está encima cuando progress = 100%, nunca sale
  - Solución: Agregar un timeout extra (ej: 5s después de 100%) que fuerce `StartExit()` incluso con hover activo

---

## 🟢 LIVIANAS

- [ ] **#15 Constante Pi duplicada 6 veces**
  - `3.14159265359` hardcodeada en múltiples métodos
  - Solución: `static PI := 3.141592653589793` en `ToastEasing` y reemplazar todos los usos

- [ ] **#16 Condicional duplicado en `get()`**
  - Línea 152: `name = "fastOutSlowIn" || name = "fastOutSlowIn"` — idéntico
  - Solución: Eliminar la segunda condición duplicada

- [ ] **#17 `animStyle` default inconsistente entre clases**
  - `ToastConfig` usa `"slide"` (String), `Toast` usa `["fade"]` (Array)
  - Solución: Ambos deben usar `["slide"]` como default consistente

- [ ] **#18 Falta `WM_MOUSELEAVE`**
  - Polling a 50ms es impreciso para mouse rápido
  - Solución: Integrar `ToastMouseHook` (que ya existe pero no se usa) + `TrackMouseEvent` para detección precisa

- [ ] **#19 `__Click` no compensa offset de buffer**
  - `OnClick()` sí compensa pero `__Click()` no verifica
  - Solución: Aplicar misma lógica de offset de `OnClick()` línea 1950-1951 en `__Click()`

- [ ] **#20 Sin manejo de cambio de resolución**
  - `A_ScreenWidth`/`A_ScreenHeight` se leen una vez
  - Solución: Detectar `WM_DISPLAYCHANGE` (0x007E) y llamar `__reflow(true)` para reposicionar

- [ ] **#21 Alias `"bounce"` solo mapea a `bounceOut`**
  - `bounceIn` y `bounceInOut` existen pero `"bounce"` solo es `bounceOut`
  - Solución: Verificar que el comportamiento es intencional; si no, agregar alias `"bounceIn"` y `"bounceInOut"` explícitos

- [ ] **#22 `ProcessSetPriority("High")` es excesivo**
  - Puede causar starvation en otros procesos
  - Solución: Cambiar a `"AboveNormal"`

- [ ] **#23 `__reflow` + `InitAnimation` + `AnimateIn` es redundante**
  - Patrón de 3 pasos en `__createToast` podría simplificarse
  - Solución: Unificar en un solo método `Spawn()` que haga push + reflow + init + animate

---

## 📋 NOTAS DE IMPLEMENTACIÓN

- ~~Empezar por las **CRÍTICAS** (#1-#6)~~ ✅ COMPLETADAS
- Cada cambio debe probarse con `test_toast.ahk`, `test_hover.ahk` y `test_animations.ahk`
- Mantener compatibilidad con la API pública existente (`Toastify.Success()`, etc.)
- No romper el comportamiento de `permanent` toasts ni `hoverPauseEnabled`
