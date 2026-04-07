# Registro de Cambios (Changelog)

## [9.3.1] - 2026-04-06
### Añadido
- **Fusión Turtle WoW:** Integración dinámica de 10 archivos de base de datos (`db/*-turtle.lua`).
- **Nodos de Mazmorra:** Desactivación de minimapa en instancias personalizadas de Turtle WoW mediante `pfMap:HasMinimap`.
- **Identidad Séquito:** Inyectado el branding de "El Séquito del Terror" en la UI y sistema de bienvenida.

### Mejorado
- **Motor de Navegación:** Refactorización de `route.lua` con caché de proyección de 0.15s, eliminando stuttering.
- **Rendimiento de Memoria:** Recolección de basura agresiva de tablas de locales no usadas (~65MB ahorrados).
- **Consistencia del Tracker:** Hooks manuales para `CollapseQuestHeader` y `ExpandQuestHeader` para evitar que las misiones desaparezcan al colapsar zonas.
- **Optimización de Búsqueda:** Implementación de `nameIndex` (O(1)) y `staticRejectSet` (O(n) pre-filtrado).

### Corregido
- **Bug Crítico:** Falla en el merge de locales turtle sobre tablas ya liberadas por `database.lua`.
- **Bug de Nodos:** Corrección de `xmax` duplicado en `database.lua`.
- **Micro-cortes:** Recálculo del `sortfunc` optimizado para evitar calls redundantes.

---
Atentamente,
**DarckRovert**