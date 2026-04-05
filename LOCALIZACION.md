# Localización en Español — pfQuest Séquito Edition

## Locale Soportados

| Locale | Estado |
|---|---|
| enUS | ✅ Completo (original) |
| esES | ✅ Localización Dinámica (esES -> enUS) |
| esMX | ✅ Alias de esES |
| frFR | ✅ Completo (original) |
| deDE | ✅ Completo (original) |
| koKR | ✅ Completo (original) |
| zhCN | ✅ Completo (original) |
| ruRU | ✅ Completo (original) |
| ptBR | ✅ Completo (original) |

## 🔄 Sistema de Fallback Dinámico (v9.3.1)

Se ha implementado un sistema de **metatables** en `database.lua`. Si una entrada de la base de datos (misión, objeto, NPC) no tiene traducción en `esES`, el addon consultará automáticamente la entrada en `enUS`. 

Esto asegura que:
1. No aparezcan tooltips vacíos.
2. Los nuevos items de Turtle WoW (que solo están en inglés) se muestren correctamente en el cliente español.
3. El rendimiento sea óptimo al no duplicar tablas completas en memoria.

## 🧹 Limpieza de Base de Datos

Se realizó una auditoría masiva para corregir **180 errores de sintaxis** en `quests-tbc.lua` y eliminar miles de prefijos `OLD` y `Deprecated` en toda la base de datos `esES`.

## Alias esMX

El cliente de Turtle WoW en algunos sistemas reporta esMX. Para asegurar la carga del locale en español, se ha configurado un alias automático.

## Cadenas Clave Traducidas

| Inglés | Español |
|---|---|
| Quest Tracker | Rastreador de Misiones |
| Objectives | Objetivos |
| Turn In | Entregar |
| Accept | Aceptar |
| Scan Server | Escanear Servidor |