-- pfQuest [Séquito del Terror] :: Turtle WoW Patch Table
-- Fusiona la base de datos vanilla con los datos exclusivos de Turtle WoW.
-- Basado en pfQuest-turtle (Gurky, Antealis, HumbleKagu et al.)
-- Adaptado para pfQuest Séquito del Terror Edition.

-- Initialize locale reference
local loc = GetLocale()
-- Alias para clientes latinoamericanos
if loc == "esMX" then loc = "esES" end

local dbs = { "items", "quests", "quests-itemreq", "objects", "units", "zones", "professions", "areatrigger", "refloot" }

-- Patch databases to merge TurtleWoW data into the vanilla base
local function patchtable(base, diff)
  if not base or not diff then return end
  for k, v in pairs(diff) do
    if type(v) == "string" and v == "_" then
      base[k] = nil
    elseif type(base[k]) == "table" and type(v) == "string" then
      -- No sobrescribir tablas técnicas con strings de localización.
      -- Guardamos el nombre dentro de la tabla para mantener la jerarquía.
      base[k].name = v
    else
      base[k] = v
    end
  end
end

-- Detect a typo from old clients and re-apply the typo to the zones table
-- This is a workaround required until all clients are updated
if pfDB["zones"]["loc"] and pfDB["zones"]["enUS-turtle"] then
  for id, name in pairs({GetMapZones(2)}) do
    if name == "Northwind " then
      pfDB["zones"]["enUS-turtle"][5581] = "Northwind "
    end
  end
end

-- Merge data tables (language-independent)
for _, db in pairs(dbs) do
  if pfDB[db]["data-turtle"] then
    patchtable(pfDB[db]["data"], pfDB[db]["data-turtle"])
  end
end

-- CRITICAL: Merge turtle locale data into pfDB[db]["loc"]
-- At this point database.lua has already freed all locale tables (esES, enUS, etc.)
-- except pfDB[db]["loc"] which points to the active locale.
-- We must FIRST merge enUS-turtle as a generic fallback for custom server data,
-- and THEN merge the specific active locale (esES-turtle) over it to translate what exists.
for _, db in pairs(dbs) do
  if pfDB[db]["loc"] then
    -- 1. Merging english turtle base (Fallback for untranslated custom DB)
    if pfDB[db]["enUS-turtle"] then
      patchtable(pfDB[db]["loc"], pfDB[db]["enUS-turtle"])
    end
    -- 2. Merging active locale turtle patch (Overrides english with available translations)
    if loc ~= "enUS" and pfDB[db][loc.."-turtle"] then
      patchtable(pfDB[db]["loc"], pfDB[db][loc.."-turtle"])
    end
  end
end

-- Merge professions locale (professions loc is not freed by database.lua)
local prof_loc = pfDB["professions"]["loc"] or pfDB["professions"][loc] or pfDB["professions"]["enUS"]
if pfDB["professions"]["enUS-turtle"] then patchtable(prof_loc, pfDB["professions"]["enUS-turtle"]) end
if loc ~= "enUS" and pfDB["professions"][loc.."-turtle"] then patchtable(prof_loc, pfDB["professions"][loc.."-turtle"]) end

-- Merge minimap and meta tables
if pfDB["minimap-turtle"] then patchtable(pfDB["minimap"], pfDB["minimap-turtle"]) end
if pfDB["meta-turtle"] then patchtable(pfDB["meta"], pfDB["meta-turtle"]) end

-- Detect german client patch: re-apply deDE-turtle locale if available
if TURTLE_DE_PATCH then
  for _, db in pairs(dbs) do
    local deDE_turtle = pfDB[db]["deDE-turtle"]
    if deDE_turtle and pfDB[db]["loc"] then
      patchtable(pfDB[db]["loc"], deDE_turtle)
    end
  end
end

-- Update bitmasks to include Turtle WoW custom races
if pfDB.bitraces then
  pfDB.bitraces[256] = "Goblin"
  pfDB.bitraces[512] = "BloodElf"
end

-- Override database URL to Turtle WoW's database
pfQuest.dburl = "https://database.turtlecraft.gg/?quest="

-- HasMinimap: disable in custom Turtle WoW dungeon maps
function pfMap:HasMinimap(map_id)
  local has_minimap = not IsInInstance()
  if IsInInstance() and GetCurrentMapContinent() < 3 then
    has_minimap = true
  end
  return has_minimap
end

-- Reload all pfQuest internal database shortcuts after DB merge,
-- then rebuild the name index to include Turtle WoW NPCs/objects/items.
if pfDatabase.Reload then
  DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[Séquito]|r Recargando accesos directos de la base de datos...")
  pfDatabase:Reload()
end

if pfDatabase.BuildNameIndex then
  DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[Séquito]|r Reconstruyendo índice de nombres...")
  pfDatabase:BuildNameIndex()
end

-- Free turtle locale patch tables now that they've been merged into loc
for _, db in pairs(dbs) do
  if pfDB[db] then
    pfDB[db]["data-turtle"] = nil
    pfDB[db][loc.."-turtle"]  = nil
    pfDB[db]["enUS-turtle"]   = nil
    if TURTLE_DE_PATCH then pfDB[db]["deDE-turtle"] = nil end
  end
end
pfDB["minimap-turtle"] = nil
pfDB["meta-turtle"]    = nil

-- Utility: split a string by delimiter
local function strsplit(delimiter, subject)
  if not subject then return nil end
  local delimiter, fields = delimiter or ":", {}
  local pattern = string.format("([^%s]+)", delimiter)
  string.gsub(subject, pattern, function(c) fields[table.getn(fields)+1] = c end)
  return unpack(fields)
end


local function complete(history, qid)
  if not qid or not tonumber(qid) then return end

  -- mark quest as complete preserving existing timestamp/level
  local time_val = pfQuest_history[qid] and pfQuest_history[qid][1] or 0
  local level_val = pfQuest_history[qid] and pfQuest_history[qid][2] or 0
  history[qid] = { time_val, level_val }

  -- complete all quests that are mutually exclusive with the selected one
  local close = pfDB["quests"]["data"][qid] and pfDB["quests"]["data"][qid]["close"]
  if close then
    for _, cqid in pairs(close) do
      if not history[cqid] then complete(history, cqid) end
    end
  end

  -- complete all pre-requisite quests as well
  local prequests = pfDB["quests"]["data"][qid] and pfDB["quests"]["data"][qid]["pre"]
  if prequests then
    for _, pqid in pairs(prequests) do
      if not history[pqid] then complete(history, pqid) end
    end
  end
end

-- Server-side query frame: receives quest completion data via addon message
local query = CreateFrame("Frame")
query:Hide()

query:SetScript("OnEvent", function()
  if arg1 == "TWQUEST" then
    for _, qid in pairs({strsplit(" ", arg2)}) do
      complete(this.history, tonumber(qid))
    end
  end
end)

query:SetScript("OnShow", function()
  this.history = {}
  this.time = GetTime()
  this:RegisterEvent("CHAT_MSG_ADDON")
  SendChatMessage(".queststatus", "GUILD")
end)

query:SetScript("OnHide", function()
  this:UnregisterEvent("CHAT_MSG_ADDON")

  local count = 0
  for qid in pairs(this.history) do count = count + 1 end

  DEFAULT_CHAT_FRAME:AddMessage("|cff33ffccpf|cffffffffQuest|r: " ..
    "|cff00ccff[Séquito del Terror]|r: " .. count .. " misiones marcadas como completadas desde el servidor.")

  pfQuest_history = this.history
  this.history = nil

  pfQuest:ResetAll()
end)

query:SetScript("OnUpdate", function()
  if GetTime() > this.time + 3 then this:Hide() end
end)

-- Public function to query server quest status
function pfDatabase:QueryServer()
  DEFAULT_CHAT_FRAME:AddMessage("|cff33ffccpf|cffffffffQuest|r |cff00ccff[Séquito del Terror]|r: Recibiendo datos de misiones del servidor...")
  query:Show()
end



local updatecheck = CreateFrame("Frame")
updatecheck:RegisterEvent("PLAYER_ENTERING_WORLD")
updatecheck:SetScript("OnEvent", function()
  -- Count turtle-specific quests by checking the turtle-extended ID range.
  -- Turtle WoW quest IDs start at 40000 (custom range).
  -- This avoids needing data-turtle which was freed after the merge.
  local count = 0
  for id in pairs(pfDB["quests"]["data"]) do
    if tonumber(id) and tonumber(id) >= 40000 then
      count = count + 1
    end
  end

  if count > 0 then
    pfQuest:Debug("|cff00ccff[Sequito]|r TurtleWoW: |cff33ffcc" .. count .. "|r misiones exclusivas cargadas.")
  end

  if not pfQuest_turtlecount or pfQuest_turtlecount ~= count or count == 0 then
    pfQuest:Debug("|cff00ccff[Sequito]|r Sincronización de misiones detectada. Limpiando |cff33ffccCache|r...")
    pfQuest_questcache = {}
  end

  pfQuest_turtlecount = count

  -- Unregister after first fire to avoid counting every relog
  this:UnregisterAllEvents()
end)

