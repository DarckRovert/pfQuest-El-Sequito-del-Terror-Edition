
-- SECTION 1: Alias mapping
-- Free unused locale data to reduce memory (~65MB savings)
-- The "loc" reference already points to the correct table, so we can safely
-- nil out all other locale tables and let them be garbage collected.
-- CRITICAL: Before freeing, save an enUS alias for the noloc fallback check.
for id, db in pairs(dbs) do
  -- Save enUS reference for noloc switch BEFORE freeing
  if noloc[db] and pfDB[db]["enUS"] then
    pfDB[db]["enUS-saved"] = pfDB[db]["enUS"]
  end

  for locale in pairs(pfDB.locales) do
    if pfDB[db][locale] and pfDB[db][locale] ~= pfDB[db]["loc"] then
      pfDB[db][locale] = nil
    end
  end
  -- Also free enUS if it's not the active locale  (enUS-saved still holds the reference)
  if pfDB[db]["enUS"] and pfDB[db]["enUS"] ~= pfDB[db]["loc"] then
    pfDB[db]["enUS"] = nil
  end
  -- Free expansion patch data (already merged into base tables)
  pfDB[db]["data-tbc"] = nil
  pfDB[db]["data-wotlk"] = nil
  -- Free turtle patch data (already merged by patchtable.lua â€” but patchtable runs AFTER
  -- database.lua, so these will be nil-able only after the merge. We skip here;
  -- patchtable.lua itself cleans up after merging.)
end
-- SECTION 2: Noloc switch
-- check for unlocalized servers and fallback to enUS databases when the server
-- returns item names that are different to the database ones. (check via. Hearthstone)
CreateFrame("Frame", "pfQuestLocaleCheck", UIParent):SetScript("OnUpdate", function()
  -- throttle to one check per second
  if (this.tick or 0) > GetTime() then
    return
  else
    this.tick = GetTime() + 0.1
  end

  if not this.dryrun then
    -- give the server one iteration to return the itemname.
    -- this is required for clients that use a clean wdb folder.
    ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE")
    ItemRefTooltip:SetHyperlink("item:6948:0:0:0")
    ItemRefTooltip:Hide()
    this.dryrun = true
    return
  end

  -- try to load hearthstone into tooltip
  ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE")
  ItemRefTooltip:SetHyperlink("item:6948:0:0:0")

  -- check tooltip for results
  if ItemRefTooltip:IsShown() and ItemRefTooltipTextLeft1 and ItemRefTooltipTextLeft1:IsVisible() then
    -- once the tooltip shows up, read the name and hide it
    local name = ItemRefTooltipTextLeft1:GetText()
    ItemRefTooltip:Hide()

    -- check for noloc: if server returns different names, switch noloc DBs to enUS
    -- SAFETY: only switch if enUS-saved actually exists; otherwise keep current loc.
    if name and name ~= "" and pfDB["items"]["loc"] and pfDB["items"]["loc"][6948] then
      if not strfind(name, pfDB["items"]["loc"][6948], 1) then
        local switched = false
        pfDatabase.dbstring = ""
        for id, db in pairs(dbs) do
          -- switch noloc databases to enUS only if enUS-saved is available
          if noloc[db] and pfDB[db]["enUS-saved"] then
            pfDB[db]["loc"] = pfDB[db]["enUS-saved"]
            switched = true
          end
          pfDatabase.dbstring = pfDatabase.dbstring
            .. " |cffcccccc[|cffffffff"
            .. db
            .. "|cffcccccc:|cff33ffcc"
            .. (noloc[db] and (switched and "enUS" or loc) or loc)
            .. "|cffcccccc]"
        end
      end

      pfDatabase.localized = true
      pfDatabase:BuildNameIndex()
      pfDatabase:BuildStaticRejectSet()
      this:Hide()
    end
  end

  -- set a detection timeout to 30 seconds (extended for slow cache clients)
  if GetTime() > 30 then
    pfDatabase.localized = true
    pfDatabase:BuildNameIndex()
    pfDatabase:BuildStaticRejectSet()
    this:Hide()
  end
end)
-- SECTION 3: BuildNameIndex guard
function pfDatabase:BuildNameIndex()
  local idx = self.nameIndex
  -- clear existing index in-place
  for db in pairs(idx) do
    for name in pairs(idx[db]) do
      idx[db][name] = nil
    end
    idx[db] = nil
  end

  for _, db in pairs({ "units", "objects", "items" }) do
    idx[db] = {}
    -- SAFETY: guard against nil loc table (can happen in broken init sequences)
    if pfDB[db] and pfDB[db]["loc"] then
      for id, locname in pairs(pfDB[db]["loc"]) do
        if locname then
          if not idx[db][locname] then
            idx[db][locname] = {}
          end
          insert(idx[db][locname], id)
        end
      end
    end
  end

  -- locale tables may have changed; force SearchQuests to re-add all nodes
  for id in pairs(self.lastQuestGiversSet) do
    self.lastQuestGiversSet[id] = nil
