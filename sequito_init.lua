-- pfQuest [Séquito del Terror Edition] Initializer
-- Born from cheese. Written shirtless.

local color_cyan = { 0, 0.8, 1 }
local color_pink = { 1, 0, 0.8 }

-- Inject Séquito theme into pfQuest
local init = CreateFrame("Frame")
init:RegisterEvent("PLAYER_ENTERING_WORLD")
init:SetScript("OnEvent", function()
  this:UnregisterAllEvents()

  -- Set default colors for some common quest types or random seeds
  -- This ensures Pink/Cyan appear frequently on the map
  if pfQuest_colors then
    pfQuest_colors["Sequito_Cyan"] = color_cyan
    pfQuest_colors["Sequito_Pink"] = color_pink
  end

  -- Welcome message
  local L = pfQuest_Loc
  local ver = (pfQuestConfig and pfQuestConfig.version) or GetAddOnMetadata("pfQuest-El-Sequito-del-Terror-Edition", "Version") or GetAddOnMetadata("pfQuest", "Version") or "v7.0.1-Terror"
  local welcome = "|cff00ccff[Séquito del Terror]|r: " .. 
                  string.format("|cffffffffpfQuest %s detectado. Elnazzareno guía tus pasos.|r", ver)
  
  if GetLocale() ~= "esES" and GetLocale() ~= "esMX" then
    welcome = "|cff00ccff[Séquito del Terror]|r: " .. 
              string.format("|cffffffffpfQuest %s detected. Elnazzareno guides your steps.|r", ver)
  end
  
  DEFAULT_CHAT_FRAME:AddMessage(welcome)
end)

-- Visual Overwrites (ejecutadas en PLAYER_ENTERING_WORLD para garantizar que los frames existen)
local visual_init = CreateFrame("Frame")
visual_init:RegisterEvent("PLAYER_ENTERING_WORLD")
visual_init:SetScript("OnEvent", function()
  this:UnregisterAllEvents()

  -- Brand config window title
  if pfQuestConfig and pfQuestConfig.title then
    pfQuestConfig.title:SetText("|cff33ffccpf|cffffffffQuest |r|cff00ccff[Séquito del Terror]|r")
    -- Pinkish border for the config window
    if pfQuestConfig.backdrop then
      pfQuestConfig.backdrop:SetBackdropBorderColor(1, 0, 0.8, 1)
    end
  end

  -- Brand the First-Run Initialization Window
  if pfQuestInit and pfQuestInit.title then
    local old_title = pfQuestInit.title:GetText() or ""
    pfQuestInit.title:SetText("|cff00ccff[Séquito del Terror]|r\n" .. old_title)
    if pfQuestInit.backdrop then
      pfQuestInit.backdrop:SetBackdropBorderColor(1, 0, 0.8, 1)
    end
  end
end)
