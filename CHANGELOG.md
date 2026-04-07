# Changelog - pfQuest [Séquito Edition]

## [9.4.0-Omni-Tier] - 2026-04-07
### Corregido / Optimizado
- **Arquitectura de Memoria (Lua 5.0):** Resolución completa de error crítico `too many upvalues` en `route.lua` reorganizando la declaratoria local en la secuencia OnUpdate.
- **Soporte Regional Híbrido:** Reestructuración jerárquica en `patchtable.lua` para forzar la inyección de NPCs custom de Turtle WoW (enUS) antes de fusionar el español, impidiendo la pérdida del entorno no traducido.
- **Auto-Preservación (NoLoc):** Amputación forzosa del protocolo legacy `noloc` en `database.lua`. El AddOn ya no sobrescribirá las tablas `esES` a inglés al detectar latencia o el diccionario nativo del núcleo del servidor inglés.
- **Sintaxis Legacy:** Sustitución de operador `%` por función `modulo` garantizando operatividad de vectores (flechas) del Vanilla.

## [12.2.0-Séquito] - 2026-04-07
- **Estructura de Datos esES-turtle:** Creación de archivos `db/esES/` para items, unidades y objetos exclusivos de Turtle WoW.
- **Suite de Documentación:** README corporativo, Wiki técnica completa y protocolos de seguridad.
- **Gravity AI Bridge Integration:** Scripts de automatización para traducción técnica masiva.

## [12.2.0] - 2026-04-06
### Añadido
- Versión optimizada para el ecosistema "El Séquito del Terror".
- Documentación corporativa inicial.
