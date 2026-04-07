# 🛠️ Guía de API — pfQuest [Séquito Edition]

Este documento detalla las funciones internas del motor de pfQuest para desarrolladores de **El Séquito del Terror**.

---

## 🗃️ Funciones de Base de Datos (`database.lua`)

### `pfDatabase:Reload()`
Recarga las referencias locales a las tablas de misiones, NPCs y objetos activos tras un cambio de zona o carga de parche.

### `pfDatabase:GetIDByName(name, type)`
Búsqueda de alta velocidad por nombre localizado.
- **name:** String (ej: "Lich King").
- **type:** "units", "objects" o "items".
- **Retorno:** ID (Integer) o `nil`.

### `pfDatabase:BuildNameIndex()`
Reconstruye el índice asociativo O(1). Usar solo si se inyectan datos dinámicos masivos.

---

## 🗺️ Funciones del Mapa (`map.lua`)

### `pfMap:AddNode(title, node, layer, addon)`
Inyecta un icono en el mapa mundial y el minimapa.
- **title:** Título del nodo (ej: "Misión: Elnazzareno").
- **node:** Tabla de propiedades (x, y, texture, etc.).
- **layer:** Prioridad de renderizado (1-4).
- **addon:** Identificador (ej: "PFQUEST" o "WCS_BRAIN").

### `pfMap:DeleteNode(addon, title)`
Elimina dinámicamente un nodo del mapa. Ideal para limpiezas de tracking.

---

## 🏹 Funciones de Navegación (`route.lua`)

### `pfQuest.route:LockToQuest(title)`
Fija la aguja de navegación a una misión específica.
- **title:** Título exacto de la misión.

### `pfQuest.Projections:UnApply(mapID, x, y)`
Función crítica del sistema GPS. Convierte coordenadas visuales (0-100) en coordenadas reales de base de datos.
- **Retorno:** `px, py` (Float).

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Ingeniería de alta precisión para Turtle WoW.*
