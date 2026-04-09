# Changelog - pfQuest [Séquito del Terror Edition]

Todos los cambios notables en este proyecto serán documentados en este archivo.

## [v5.3.3] - 2026-04-09 [Lag-Free 1.17]

### Añadido
- **Sincronización Turtle WoW v1.17**: Integración completa de coordenadas y misiones para Isla Lapidis y Balor (incluyendo NPC 92005 Sergeant Blackwell).
- **Smart Localization Fusion**: Nuevo motor de unión de bases de datos que permite nombres en español sin romper la jerarquía técnica de las zonas custom.
- **Suite de Documentación Diamond-Tier**: Wiki corporativa completa y gobernanza de repo.

### Corregido
- **Navegación Nivel 60**: Eliminado el filtro restrictivo de "bajo nivel" que ocultaba la flecha de navegación al alcanzar el nivel máximo.
- **Inconsistencia esES**: Corregido el error de tipos de datos en la tabla de zonas que causaba mapas vacíos en el cliente español.

### Optimizado
- **Motor Reactivo [Lag-Free]**: Eliminación total del bucle de escaneo persistente (polling) en el diario de misiones, delegando el procesamiento a eventos disparados por el juego.
- **Throttling de Movimiento**: Reducción drástica del uso de CPU en el motor de rutas mediante la detección de inactividad del jugador.

## [v5.3.2] - 2026-04-01
- Estabilización inicial de traducciones esES.
- Implementación de `/db status` para auditoría técnica.

---
Para más información, visita la [Wiki](file:///e:/Turtle Wow/Interface/AddOns/pfQuest/wiki/Arquitectura.md).
