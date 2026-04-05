# Arquitectura — pfQuest Sequito 🪐

mermaid
graph TD
    CORE[pfQuest Core]
    DB[Quest Database]
    WORLD[World Map Projections]
    LOCALES[Spanish Translation Module]

    CORE --> DB
    CORE --> WORLD
    LOCALES --> DB


## Componentes
- **db/**: Base de datos estática de misiones de Turtle WoW.
- **projections.lua**: Motor de proyección de coordenadas en el mapa.
- **locales.lua**: Módulo de traducción dinámica para El Séquito.
