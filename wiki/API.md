# Guía de API Técnica - pfQuest [Séquito]

Esta guía documenta las funciones principales para desarrolladores y auditoría técnica del motor de pfQuest.

## pfDatabase

### `pfDatabase:GetStatus()`
Retorna una tabla con el estado de salud del addon.
- `total_quests`: Conteo total de misiones cargadas.
- `turtle_quests`: Misiones específicas de Turtle WoW (IDs > 40000).
- `loc`: Localización activa del cliente.

### `pfDatabase:SearchQuests(meta, maps)`
Escanea misiones disponibles y añade nodos al mapa.
**Nota:** En la v5.3.3, esta función ignora el filtro de nivel si el jugador es nivel 60.

## pfMap

### `pfMap:GetMapIDByName(search)`
Resuelve el ID técnico de un mapa a partir de su nombre localizado.
**Smart Fusion [NEW]:** Ahora soporta la búsqueda dentro de tablas técnicas (campo `.name`), eliminando colisiones en clientes esES.

## Eventos Custom
- `PFQUEST_CACHE_CLEANED`: Se dispara tras un purgado forzado de la base de datos de misiones.
