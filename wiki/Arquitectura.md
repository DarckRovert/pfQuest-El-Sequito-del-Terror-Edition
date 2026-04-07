# Arquitectura — pfQuest Sequito Edition 🏛️

## Visión General
pfQuest Sequito Edition es una refactorización de pfQuest diseñada específicamente para el cliente de Turtle WoW. Utiliza un sistema de capas para manejar la base de datos de misiones personalizadas y un motor de rutas optimizado para evitar latencia (Lag-Free Engine).

## Módulos Principales
1. **Motor de Rutas (`route.lua`)**: Gestiona la lógica de la flecha de navegación. Utiliza un sistema de prioridades jerárquico que permite bloquear objetivos manualmente (Sticky Targets).
2. **Sistema de Proyecciones (`projections.lua`)**: Traduce coordenadas del juego a un sistema global coordinado para corregir desviaciones en mapas personalizados de expansión.
3. **Controlador de Base de Datos (`database.lua`)**: Encargado del indexado de misiones, npcs y objetos. Optimizado para búsquedas rápidas mediante tablas de hash.
4. **Rastreador (`tracker.lua`)**: Interfaz minimalista que permite gestionar el seguimiento de misiones sin saturar la pantalla.

## Flujo de Datos
- **Entrada**: Eventos (`QUEST_LOG_UPDATE`, `UNIT_PLAYER_POSITION`).
- **Procesamiento**: Filtrado por zona actual y cálculo de distancias proyectadas.
- **Salida**: Actualización de la flecha (frame-based) e iconos en el mapa.
