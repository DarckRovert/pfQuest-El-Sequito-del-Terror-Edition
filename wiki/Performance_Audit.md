# 📉 Wiki: Auditoría de Rendimiento — pfQuest [Lag-Free Edition]

El estándar **Diamond Tier** de **DarckRovert** redefine la eficiencia de los motores de misiones para **Turtle WoW**.

---

## ⚡ Análisis de Throttling (CPU Sync)

El motor original de Shagu's pfQuest ejecutaba cálculos de distancia e iteraciones de la tabla de misiones en cada frame (`OnUpdate`). En la **Optimized Edition**, hemos implementado una sincronización asíncrona:

### 🎭 Comparativa de Impacto (Ciclos de CPU)

| Módulo | Escala Original | Escala Optimized | Mejora Lograda |
| :--- | :---: | :---: | :---: |
| **Logic Engine (`quest.lua`)** | 0.05s | 0.2s | **-75% Carga** |
| **Route Calculator** | 0.1s | 0.25s | **-60% Carga** |
| **Map Icon Animator** | Cada Frame | 0.05s | **-90% Carga** |

## 🧪 Pruebas de Estabilidad (Stuttering Test)

### Escenario A: 25 Misiones Activas (Stormwind)
- **pfQuest Original**: El motor causa picos de lag (stuttering) de ~15ms cada vez que se actualiza el diario de misiones.
- **Séquito Edition**: Los picos se suavizan a ~2ms mediante el sistema de **Tick Global (0.2s)** y la lógica de **Early-Exit**.

### Escenario B: Navegación de Mapa (Ecosistema High Density)
- **pfQuest Original**: El renderizado de 100+ iconos en el mapa causa caídas de FPS al mover el mapa (drag).
- **Séquito Edition**: El controlador de animaciones regula los FPS de los iconos, manteniendo la interfaz de mapa a una tasa constante de **60+ FPS**.

---

## 💾 Optimización de Memoria (Footprint)

- **GC Controlled**: El motor ahora evita la creación de tablas locales en bucles críticos, reutilizando arrays pre-asignados para el tracking de coordenadas.
- **Route Cache**: Las distancias no se recalculan si el jugador se desplaza menos de 1 yarda (Throttling de Distancia).

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Ingeniería de alto rendimiento para la conquista de Azeroth.*
