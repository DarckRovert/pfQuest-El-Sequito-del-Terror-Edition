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
