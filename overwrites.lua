-- pfQuest [Séquito del Terror] :: Database Overwrites
-- Este archivo puede usarse para sobrescribir o añadir entradas a la DB
-- que el extractor no detectó. Añadir comentarios con la razón del fix.
-- Las correcciones de Turtle WoW se procesan ANTES que patchtable.lua
-- (que fusiona los datos -turtle en las tablas base), por lo que este
-- archivo opera sobre las tablas ya patched cuando se invoca tarde,
-- pero los bloques do/end garantizan aislamiento de scope.

-- [[ VANILLA ]]
-- Quest: Great Bear Spirit
-- Unit: Great Bear Spirit (11956)
-- Type: Talk/Gossip Menu Requirement (no detectado por extractor)
pfDB["quests"]["data"][5929]["obj"] = { ["U"] = { 11956 } }
pfDB["quests"]["data"][5930]["obj"] = { ["U"] = { 11956 } }


-- [[ TURTLE WOW — PHANTOM ZONE CORRECTIONS ]]
-- Varios Zone IDs comparten nombre con una zona funcional pero no tienen
-- referencias de NPC ni de objetos, convirtiéndolos en "fantasmas".
-- GetMapIDByName itera con pairs() (orden no determinista), y puede
-- devolver un ID fantasma en lugar del funcional, causando que las
-- misiones y nodos del minimapa no aparezcan en esas mazmorras.
--
-- Mapeos Phantom → Funcional (Turtle WoW):
--   5600 "Dragonmaw Retreat"  → 5601 (tiene minimapa + units)
--   5098 "Hateforge Quarry"   → 5103 (tiene minimapa + units)
--   5550 "Ruins of Grim Batol"→ 5639 (tiene units)
--
-- IDs vanilla que aún contienen todos los datos de NPC/object:
--    209  "Shadowfang Keep"  (181 refs de NPC, 35 de objeto)
--   1581  "The Deadmines"
--   1583  "Blackrock Spire"
--   1584  "Blackrock Depths" (1085 refs de NPC, 462 de objeto)
-- Los IDs 5000+ de abajo comparten esos nombres pero tienen cero refs.
-- Se eliminan para que GetMapIDByName resuelva a los IDs con contenido.
--
-- Vanilla ID → Reemplazos fantasma:
--    209 "Shadowfang Keep"  → 5132, 5150, 5161, 5169, 5173, 5177
--   1581 "The Deadmines"   → 5138
--   1583 "Blackrock Spire" → 5139, 5155, 5164, 5170, 5178
--   1584 "Blackrock Depths"→ 5140
do
  local phantom_zones = {
    5600, 5098, 5550,
    5132, 5138, 5139, 5140, 5150, 5161,
    5155, 5164, 5169, 5170, 5173, 5177, 5178,
  }
  local zone_locales = { "enUS", "deDE", "esES", "ptBR", "zhCN" }
  for _, locale in pairs(zone_locales) do
    local tbl = pfDB["zones"][locale .. "-turtle"]
    if tbl then
      for _, zid in pairs(phantom_zones) do
        tbl[zid] = nil
      end
    end
  end
end

do -- area trigger
end

do -- items
  -- "Dark Iron Gunpowder Keg" añadido a objetivos de "Vile Dwarven Pigs"
  -- El extractor no lo detectó: el objetivo se rellena vía Gossip on use.
  if pfDB["quests"]["data-turtle"] and pfDB["quests"]["data-turtle"][41682] then
    pfDB["quests"]["data-turtle"][41682]["obj"] = pfDB["quests"]["data-turtle"][41682]["obj"] or {}
    pfDB["quests"]["data-turtle"][41682]["obj"]["O"] = { 2020173 }
  end

  -- "Head of Geshgan" añadido a la loot table de "Geshgan"
  if pfDB["items"]["data-turtle"] and not pfDB["items"]["data-turtle"][41783] then
    pfDB["items"]["data-turtle"][41783] = {}
  end
  if pfDB["items"]["data-turtle"] and pfDB["items"]["data-turtle"][41783] then
    pfDB["items"]["data-turtle"][41783]["U"] = { [62217] = 1.0 }
  end
end

do -- quests
end
