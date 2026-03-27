# Localización en Español — pfQuest Séquito Edition

## Locales Soportados

| Locale | Estado |
|---|---|
| enUS | ✅ Completo (original) |
| esES | ✅ Completo |
| esMX | ✅ Alias de esES |
| rFR | ✅ Completo (original) |
| deDE | ✅ Completo (original) |
| koKR | ✅ Completo (original) |
| zhCN | ✅ Completo (original) |
| uRU | ✅ Completo (original) |
| ptBR | ✅ Completo (original) |

## Alias esMX

El cliente de Turtle WoW en algunos sistemas reporta esMX. Para asegurar la carga del locale en español:

`lua
-- En init/esES.xml se registra:
if GetLocale() == "esES" or GetLocale() == "esMX" then
    -- Cargar cadenas en español
end
`

## Cadenas Clave Traducidas

| Inglés | Español |
|---|---|
| Quest Tracker | Rastreador de Misiones |
| Objectives | Objetivos |
| Turn In | Entregar |
| Accept | Aceptar |
| Scan Server | Escanear Servidor |