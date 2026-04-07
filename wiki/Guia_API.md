# Guía de API [pfQuest Séquito del Terror]

Esta guía detalla las funciones internas y puntos de entrada para desarrolladores e integradores del ecosistema pfQuest.

## Core API

### `pfQuest:ResetAll()`
Recarga todos los componentes del addon, limpia la caché de misiones y reinicia el sistema de rastreo. Útil tras cambios masivos en la base de datos local.

### `pfDatabase:Reload()`
Actualiza los atajos internos de la base de datos. Debe llamarse siempre que el `patchtable.lua` finalice una unión de datos.

### `pfDatabase:BuildNameIndex()`
Reconstruye el índice inversio de nombres de NPCs, objetos e items. Fundamental para que la búsqueda dinámica en español funcione correctamente.

## Funciones del Séquito

### `pfDatabase:QueryServer()`
Realiza una consulta masiva al servidor mediante mensajes de addon (`TWQUEST`) para sincronizar el historial de misiones completadas.

## Eventos Personalizados
- `PFQUEST_DB_LOADED`: Se dispara cuando la base de datos (incluyendo Turtle WoW) está lista.
- `PFQUEST_TRACK_UPDATE`: Se dispara cuando el objetivo de navegación cambia.

---
© 2026 DarckRovert. Documentación Técnica.
