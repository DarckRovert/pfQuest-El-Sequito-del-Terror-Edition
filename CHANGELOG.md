# Changelog — El Séquito del Terror Edition (pfQuest) 📈⚖️

Todos los cambios notables en este proyecto serán documentados en este archivo siguiendo el estándar **Diamond Tier** de **DarckRovert**.

---

## [v5.3.6] — 2026-04-07 [Legacy-Hybrid]

### ⚡ Optimización Quirúrgica (Restauración de Backup)
- **Math Restore**: Regreso al motor matemático de la copia de seguridad (`x1.5 multiplier`). Eliminado el sistema de proyecciones dinámicas en tiempo real para recuperar los FPS perdidos.
- **Event-Driven Hierarchy**: El caché del diario de misiones ahora se actualiza solo mediante eventos (`QUEST_LOG_UPDATE`), eliminando el bucle de procesamiento pesado en `OnUpdate`.
- **Zero-Stutter Engine**: Unificación de bucles de cálculo. Ahora las distancias y los rangos se procesan en un único paso lineal.
- **Arrow Fix**: Corregida la visibilidad de la flecha al sincronizar las coordenadas del jugador con la escala nativa del addon.

---

## [v5.3.4] — 2026-04-07 [Sovereign-Stability]

## [v5.3.3] — 2026-04-07 [Sticky-Stability]

## 📊 Matriz de Versiones

| Versión | Fecha | Nombre Clave | Estado | Resumen |
| :--- | :--- | :--- | :---: | :--- |
| **5.3.6** | 2026-04-07 | **Legacy-Hybrid** | ✅ | Backup Math, Event-Driven, Zero-Stutter. |
| **5.3.4** | 2026-04-07 | **Sovereign-Stability** | ✅ | ID-Based Tracking, Zero-Flicker, Shagu Vectors. |
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
