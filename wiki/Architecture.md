# Arquitectura del Sistema - pfQuest [Séquito Edition]

La arquitectura se divide en capas modulares para garantizar la compatibilidad con el motor de WoW 1.12 (Lua 5.0) y la integración de Turtle WoW.

## 1. Capa de Datos (Database Engine)
- **Carga Híbrida:** Vanilla DB -> Turtle DB.
- **Fusión en Caliente (`patchtable.lua`):** Añade NPCs, objetos y misiones exclusivas de Turtle WoW.
- **Optimización de Memoria:** Liberación de tablas locales no activas tras la carga.

## 2. Motor de Visualización (Map Engine)
- **GCPL (Global Coordinate Projection Layer):** Transforma coordenadas visuales de Turtle WoW a coordenadas lógicas (Legacy) para un tracking preciso.
- **Clustering:** Agrupación dinámica de nodos basada en proximidad para reducir la carga de renderizado.

## 3. Lógica de Seguimiento (Quest Logic)
- **Tracking Taint-Free:** Hooks en el QuestLog de Blizzard/Turtle para sincronizar el estado sin bloquear la UI.
- **Navegación Intuitiva:** Sistema de flecha 3D basada en vectores reales calculados contra la proyección del mapa.

## 4. Módulos Extendidos (Plug-ins)
- **ShowLoots:** Tooltips de drops dinámicos.
- **QuestHelper:** Árbol de dependencias de cadenas de misiones.

---
© 2026 DarckRovert
