# ðŸ“ Wiki: Arquitectura 'Diamond Tier' â€” pfQuest [v5.3.2]

Estructura tÃ©cnica de la **Optimized Edition** mantenida por **DarckRovert**.

## ðŸ—ï¸ JerarquÃ­a del Motor de Misiones (Engine hierarchy)

El core de pfQuest interactÃºa directamente con los eventos del cliente de WoW (1.12.1) y gestiona la visualizaciÃ³n mediante capas:

1.  **Hueso Central (`quest.lua`)**: Escucha `QUEST_LOG_UPDATE` y `UNIT_QUEST_LOG_CHANGED`. Gestiona la base de datos de misiones activas y completadas.
2.  **Motor de Capas (`map.lua`)**: Dibuja texturas sobre el WorldMapFrame y Minimap. Gestiona los iconos de las misiones.
3.  **Sistema de NavegaciÃ³n (`route.lua`)**: Calcula distancias geogrÃ¡ficas y activa la flecha de proximidad.
4.  **Buscador Interno (`db.xml / locales.xml`)**: Carga los datos de NPCs, objetos y misiones (ES-EN).

---

## ðŸ§­ Diagrama de Flujo: Throttling Engine v5.3.2

```mermaid
graph TD
    A[Evento WoW: QUEST_LOG_UPDATE] --> B{Filtro de Frecuencia}
    B -- Menos de 0.2s --> Z[Bypass / Idle]
    B -- Mas de 0.2s --> C[Escaneo de Base de Datos]
    C --> D[Actualizar Estado de Tracker]
    D --> E[Llamar al Navegador]
    E --> F{Â¿Jugador en Movimiento?}
    F -- No --> G[Sin RecÃ¡lculo de Ruta]
    F -- SÃ­ --> H[Actualizar Distancias Route.lua]
    H --> I[Render de Iconos: Map.lua]
    I --> J[FPS Boost: Animaciones Throttled 0.05s]
```

## âš¡ Estrategias de OptimizaciÃ³n Diamond Tier

- **Throttled OnUpdate**: ReducciÃ³n de la carga de CPU mediante el espaciado de ciclos de cÃ¡lculo.
- **Early-Exit Logic**: Si el escaneo detecta que no hay cambios en la cola de misiones, el motor detiene la ejecuciÃ³n inmediatamente (`return`).
- **Asynchronous GUI**: El procesamiento del fader del tracker se desvincula del motor principal para evitar picos de FPS.

---
Â© 2026 **DarckRovert** â€” El SÃ©quito del Terror.
*IngenierÃ­a de alto rendimiento para la conquista de Azeroth.*

