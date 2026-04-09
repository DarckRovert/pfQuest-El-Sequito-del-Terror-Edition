## [v5.3.8] — 2026-04-09 [Sync-Fix]

### 🔄 Sincronización Diario-Mapa
- **Fix Log Check**: Corregida la discrepancia de tipos (String vs ID) al validar misiones en el diario. Ahora el addon detecta correctamente las misiones ya tomadas, evitando que aparezcan como disponibles (!) erróneamente.
- **Unified Sanitization**: Sincronizada la limpieza de títulos en el rastreador y el mapa para asegurar emparejamientos exactos.
- **Versión Oficial**: Actualizado a la **v5.3.8**.

---

## [v5.3.7] — 2026-04-09 [Global-Vision]

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
Para más información, visita la [Wiki](wiki/Arquitectura.md).
