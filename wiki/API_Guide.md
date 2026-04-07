# Guía de API Interna (Para Desarrolladores)

Este documento describe las funciones clave de pfQuest [Séquito Edition] para integración con otros AddOns del ecosistema DarckRovert.

## Funciones de Base de Datos (`database.lua`)

- `pfDatabase:Reload()`: Recarga los accesos directos locales a la base de datos.
- `pfDatabase:BuildNameIndex()`: Reconstruye el índice O(1) de nombres para búsquedas rápidas.
- `pfDatabase:GetIDByName(name, type)`: Devuelve el ID de un NPC, objeto o item dado su nombre localizado.

## Funciones de Mapa (`map.lua`)

- `pfMap:AddNode(title, node, layer, addon)`: Añade un icono personalizado al mapa.
- `pfMap:UpdateNodes()`: Fuerza el redibujado de todos los iconos activos.
- `pfMap:DeleteNode(addon, title)`: Elimina un nodo específico identificándolo por su addon de origen y título.

## Funciones de Ruta y Navegación (`route.lua`)

- `pfQuest.route:LockToQuest(title)`: Bloquea la flecha de navegación a una misión específica por su título.
- `pfDatabase:QueryServer()`: Solicita al servidor Turtle WoW el estado completo de misiones completadas via mensaje de AddOn.

---
© 2026 DarckRovert
