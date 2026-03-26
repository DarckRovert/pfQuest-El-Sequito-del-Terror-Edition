# pfQuest Séquito del Terror — Localización

## Sistema de Localización esES / esMX

pfQuest detecta automáticamente el idioma del cliente:

1. **esES** (España): carga directamente `db/esES/quests.lua`
2. **esMX** (México): el archivo `sequito_init.lua` copia los datos de esES a esMX en tiempo de carga, garantizando soporte completo

### Código de compatibilidad (sequito_init.lua)

```lua
if GetLocale() == "esMX" and pfDB then
    for k, v in pairs(pfDB) do
        if type(v) == "table" and v["esES"] then
            v["esMX"] = v["esES"]
        end
    end
end
```

## Cómo añadir traducción de un Quest

El archivo `db/esES/quests.lua` usa este formato exacto:

```lua
pfDB["quests"]["esES"] = {
  [ID_QUEST] = {
    T = "Nombre del Quest en Español",
    D = "Descripción completa del quest en español.",
    O = "Texto del objetivo del quest.",
  },
}
```

### Ejemplo (Quest ID 1)
```lua
  [1] = {
    T = "Una Corona para el Rey de la Montaña",
    D = "Recupera la corona del Rey Magni Barbabronce...",
    O = "Obtén la corona.",
  },
```

## Campos disponibles

| Campo | Descripción |
|---|---|
| `T` | Título del quest |
| `D` | Descripción / lore del quest |
| `O` | Texto del objetivo |

> Las traducciones son **opcionales** — si un quest no está traducido, pfQuest muestra el texto en inglés del cliente.

## Prioridad de Carga

1. `pfDB["quests"]["enUS"]` — base de datos inglesa (siempre presente)
2. `pfDB["quests"]["esES"]` — sobreescribe strings puntuales para el cliente ES
3. `pfDB["quests"]["esMX"]` — alias de esES (aplicado en `sequito_init.lua`)

## Colores del Clan en el Mapa

El `sequito_init.lua` inyecta colores del clan en el sistema de marcadores de pfQuest:
- `Sequito_Cyan` = `{0, 0.8, 1}` — azul cian
- `Sequito_Pink` = `{1, 0, 0.8}` — rosa fucsia
