-- ============================================================
--  pfQuest :: Extend Module :: Client Compatibility Layer
--  Fuente: Cliencer/pfExtend v1.0.5
--  Eliminadas referencias a pfExtend standalone - DarckRovert
-- ============================================================

local _, _, _, client = GetBuildInfo()
client = client or 11200

local _G    = client == 11200 and getfenv(0) or _G
local gfind = string.gmatch or string.gfind

-- Helper functions moved here to ensure they are available to all modules
ShowTooltip = function()
    if not this.tooltips then return end
    GameTooltip_SetDefaultAnchor(GameTooltip, this)
    GameTooltip:ClearLines()
    for k, v in pairs(this.tooltips) do
        if k == 1 then GameTooltip:AddLine(v, 1, 1, 1)
        else            GameTooltip:AddLine(v) end
    end
    GameTooltip:Show()
end

EnableTooltips = function(frame, tooltips)
    frame.tooltips = tooltips
    frame:SetScript("OnEnter", ShowTooltip)
    frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

-- Tabla de compatibilidad (antes era pfExtendCompat, conservamos el nombre
-- para no romper el resto del código del módulo)
pfExtendCompat = {}
pfExtendCompat.mod         = mod or math.mod
pfExtendCompat.gfind       = string.gmatch or string.gfind
pfExtendCompat.itemsuffix  = client > 11200 and ":0:0:0:0:0:0:0" or ":0:0:0"
pfExtendCompat.rotateMinimap = client > 11200 and GetCVar("rotateMinimap") ~= "0" and true or nil
pfExtendCompat.client      = client

local GetQuestLogTitle = CT_QuestLevels_oldGetQuestLogTitle or GetQuestLogTitle

pfExtendCompat.GetQuestLogTitle = function(id)
    local title, level, tag, group, header, collapsed, complete, daily, _
    if client <= 11200 then
        title, level, tag, header, collapsed, complete = GetQuestLogTitle(id)
    else
        title, level, tag, group, header, collapsed, complete, daily = GetQuestLogTitle(id)
    end
    return title, level, tag, header, collapsed, complete
end

pfExtendCompat.GetDifficultyColor = GetQuestDifficultyColor or GetDifficultyColor

pfExtendCompat.QuestWatchFrame       = QuestWatchFrame or WatchFrame
pfExtendCompat.QuestLogQuestTitle    = QuestLogQuestTitle or QuestInfoTitleHeader
pfExtendCompat.QuestLogObjectivesText = QuestLogObjectivesText or QuestInfoObjectivesText
pfExtendCompat.QuestLogQuestDescription = QuestLogQuestDescription or QuestInfoDescriptionText
pfExtendCompat.QuestLogDescriptionTitle = QuestLogDescriptionTitle or QuestInfoDescriptionHeader

if client >= 30300 then
    SetCVar("showQuestTrackingTooltips", 0)
end

pfExtendCompat.InsertQuestLink = function(questid, name)
    local questid  = questid or 0
    local fallback = name or UNKNOWN
    local level    = pfDB["quests"]["data"][questid] and pfDB["quests"]["data"][questid]["lvl"] or 0
    local name     = pfDB["quests"]["loc"][questid] and pfDB["quests"]["loc"][questid]["T"] or fallback
    local hex      = pfUI.api.rgbhex(pfExtendCompat.GetDifficultyColor(level))
    ChatFrameEditBox:Show()
    if pfQuest_config["questlinks"] == "1" then
        ChatFrameEditBox:Insert(hex .. "|Hquest:" .. questid .. ":" .. level .. "|h[" .. name .. "]|h|r")
    else
        ChatFrameEditBox:Insert("[" .. name .. "]")
    end
end

-- Minimap arrow detection (vanilla/tbc)
local minimaparrow = ({ Minimap:GetChildren() })[9]
for k, v in pairs({ Minimap:GetChildren() }) do
    if v:IsObjectType("Model") and not v:GetName() then
        if string.find(strlower(v:GetModel()), "interface\\minimap\\minimaparrow") then
            minimaparrow = v
            break
        end
    end
end

pfExtendCompat.GetPlayerFacing = GetPlayerFacing or function()
    if pfExtendCompat.rotateMinimap then
        return (MiniMapCompassRing:GetFacing() * -1)
    else
        return minimaparrow:GetFacing()
    end
end

-- Polyfill C_Timer para clientes vanilla
if not C_Timer then
    local function GenerateTimer()
        local Timer      = CreateFrame("Frame")
        local TimerObject = {}
        Timer.Infinite    = 0
        Timer.ElapsedTime = 0
        function Timer:Start(duration, callback)
            if type(duration) ~= "number" then duration = 0 end
            self:SetScript("OnUpdate", function()
                self.ElapsedTime = self.ElapsedTime + arg1
                if self.ElapsedTime >= duration and type(callback) == "function" then
                    callback()
                    self.ElapsedTime = 0
                    if self.Infinite == 0 then
                        self:SetScript("OnUpdate", nil)
                    elseif self.Infinite > 0 then
                        self.Infinite = self.Infinite - 1
                    end
                end
            end)
        end
        function TimerObject:IsCancelled() return not Timer:GetScript("OnUpdate") end
        function TimerObject:Cancel()
            if Timer:GetScript("OnUpdate") then
                Timer:SetScript("OnUpdate", nil)
                Timer.Infinite    = 0
                Timer.ElapsedTime = 0
            end
        end
        return Timer, TimerObject
    end
    C_Timer = {
        After = function(duration, callback)
            GenerateTimer():Start(duration, callback)
        end,
        NewTimer = function(duration, callback)
            local timer, timerObj = GenerateTimer()
            timer:Start(duration, callback)
            return timerObj
        end,
        NewTicker = function(duration, callback, ...)
            local timer, timerObj = GenerateTimer()
            local iterations      = unpack(arg)
            if type(iterations) ~= "number" or iterations < 0 then iterations = 0 end
            timer.Infinite = iterations - 1
            timer:Start(duration, callback)
            return timerObj
        end,
    }
end
