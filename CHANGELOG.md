# Changelog — El Séquito del Terror Edition (pfQuest) 📈⚖️

Todos los cambios notables en este proyecto serán documentados en este archivo siguiendo el estándar **Diamond Tier** de **DarckRovert**.

---

## [v9.4.0] — 2026-04-07 [Lag-Free Edition]

### ⚡ Optimizaciones Críticas (Rendimiento)
- **`quest.lua`**: Incremento del tick global de `0.05s` a `0.2s`. Adición de *early-exit* en el procesamiento de la cola de misiones.
- **`tracker.lua`**: Throttle de `0.1s` al fader de visibilidad del rastreador.
- **`route.lua`**: Incremento del throttle de distancias de la flecha de navegación de `0.1s` a `0.25s`.
- **`map.lua`**: Control del bucle de animaciones de nodos (`0.05s`) para prevenir micro-cortes al navegar por el mapa.
- **`turtle_db`**: Parche de base de datos nativo para las nuevas zonas de expansión de Turtle WoW.

---

## 📊 Matriz de Versiones

| Versión | Fecha | Nombre Clave | Estado | Resumen |
| :--- | :--- | :--- | :---: | :--- |
| **9.4.0** | 2026-04-07 | **Lag-Free** | ✅ | Throttling Engine, FPS Boost, Bug Fixes. |
| **9.3.0** | 2026-03-25 | **Turtle-Expand** | ⚠️ | Integración Emerald Dream y zonas Custom. |
| **9.2.0** | 2026-02-15 | **Stability** | ❌ | Versión inicial del ecosistema. |

---

## [v9.3.0] — 2026-03-25

### ✨ Características
- **Turtle WoW Support**: Integración de misiones exclusivas (Emerald Dream, Hyjal, etc.).
- **Map Focus**: Se ha mejorado la precisión de las coordenadas en zonas expansivas de Tel'Abim.

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Optimizada para la conquista de Azeroth.*
