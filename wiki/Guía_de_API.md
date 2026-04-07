# Guía de API — pfQuest Sequito Edition 🛠️

## Funciones Globales
El addon expone la tabla `pfQuest` con las siguientes funciones críticas para interacción externa o scripts:

### Navegación
- **`pfQuest.route:LockToQuest(title)`**: Bloquea la flecha de navegación a una misión específica por su título.
- **`pfQuest.route:Reset()`**: Limpia todos los puntos de ruta actuales y oculta la flecha.

### Mapa e Iconos
- **`pfMap:AddNode(meta)`**: Inyecta un nodo personalizado en el mapa. Requiere tabla `meta` con `x`, `y`, `zone`, `title`.
- **`pfMap:ShowMapID(mapID)`**: Abre el mapa mundial en la zona especificada por ID.

### Base de Datos
- **`pfDatabase:SearchQuestID(id, meta)`**: Realiza una búsqueda profunda en la base de datos para localizar objetivos de una misión por ID.

## Ejemplo de Uso (Script)
```lua
-- Forzar la flecha a apuntar a la misión de Rito de la Visión
pfQuest.route:LockToQuest("Rito de la Visión")
```
