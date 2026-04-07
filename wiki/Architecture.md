# 📐 Arquitectura de Sistema — pfQuest [Séquito Edition]

Este documento detalla la estructura interna de la **v9.3.1 [God-Tier]**. La arquitectura se basa en un diseño modular para garantizar la compatibilidad con el motor de WoW 1.12 (Lua 5.0) y la integración profunda con la base de datos de Turtle WoW.

---

## 🏗️ Capas de Software

### 1. Database Engine (Núcleo de Datos)
- **Carga Híbrida Inteligente:** El AddOn inicializa la DB original de Vanilla y aplica parches dinámicos (`*-turtle.lua`) mediante la `patchtable.lua`.
- **GC System:** Liberación de tablas de locales no activas para reducir el impacto en RAM (~65MB).
- **Indexación O(1):** `nameIndex` para búsquedas inmediatas.

### 2. Global Coordinate Projection Layer (GCPL)
La capa más crítica para Turtle WoW. Convierte las coordenadas visuales de los mapas expandidos de vuelta al espacio lógico de Vanilla para que la flecha y el tracking sean 100% precisos.
- **Mapping:** Sincronización con coordenadas de zonas expandidas (Hyjal, Gilneas, etc.).
- **UnApply System:** Convierte XY visuales en coordenadas de base de datos.

### 3. Navigation Engine (Vectores)
- **Vector Calculation:** Cálculo de deltas entre el jugador y el objetivo más cercano en tiempo real.
- **Frame Projection Cache:** Caché de 0.15s que evita micro-stutters al mover la cámara o el personaje.
- **Arrow Visualization:** Renderizado de flecha 3D optimizada para el motor gráfico legado.

### 4. Interface & Tracker Layer
- **Taint-Free Hooks:** Sistema de enganche seguro al QuestLog de Blizzard/Turtle.
- **Atomic Queue:** Contador `queueCount` para gestionar actualizaciones del tracker sin iteraciones pesadas.

---

## 📦 Gestión de Flujo de Datos

```mermaid
graph TD
    A[Inicio WoW] --> B[Carga de DB Vanilla]
    B --> C[Aplicación Parches Turtle WoW]
    C --> D[Liberación de Memoria Locales]
    D --> E[Inyección de Nodos en Mapa]
    E --> F[Cálculo de Proyección GCPL]
    F --> G[Navegación Vectorial (Flecha)]
```

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Ingeniería de alta precisión para Turtle WoW.*
