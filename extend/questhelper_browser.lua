-- ============================================================
--  pfQuest :: Extend Module :: QuestHelper Browser UI
--  Fuente: Cliencer/pfExtend v1.0.5
--  Rutas TGA actualizadas a pfQuest\extend\compat\
--  El Séquito del Terror - DarckRovert
-- ============================================================

local items, units, objects, quests, zones, refloot, itemreq, areatrigger, professions
items       = pfDB["items"]["data"]
units       = pfDB["units"]["data"]
objects     = pfDB["objects"]["data"]
quests      = pfDB["quests"]["data"]
zones       = pfDB["zones"]["data"]
refloot     = pfDB["refloot"]["data"]
itemreq     = pfDB["quests-itemreq"]["data"]
areatrigger = pfDB["areatrigger"]["data"]
professions = pfDB["professions"]["loc"]

-- Asset path (dentro de pfQuest)
local COMPAT = pfExtend_Path .. "\\extend\\compat\\"

-- ============================================================
-- Frame principal del browser (anclado al WorldMapFrame)
-- ============================================================
PFEXQuestHelper.Browser = CreateFrame("Frame", "QuestHelperBrowser", WorldMapFrame)
PFEXQuestHelper.Browser:Hide()
PFEXQuestHelper.Browser:SetWidth(500)
PFEXQuestHelper.Browser:SetPoint("TOPLEFT",    WorldMapFrame, "TOPRIGHT",    0, 0)
PFEXQuestHelper.Browser:SetPoint("BOTTOMLEFT", WorldMapFrame, "BOTTOMRIGHT", 0, 0)
PFEXQuestHelper.Browser:SetFrameStrata("FULLSCREEN_DIALOG")

PFEXQuestHelper.Browser:SetScript("OnHide", function()
    PFEXQuestHelper.MapToggleButton:Show()
end)
PFEXQuestHelper.Browser:SetScript("OnShow", function()
    PFEXQuestHelper.OnMapChange()
    PFEXQuestHelper.Browser:BuildTree(PFEXQuestHelper.TreeData)
end)
pfUI.api.CreateBackdrop(PFEXQuestHelper.Browser, nil, true, 0.75)

-- Título
PFEXQuestHelper.Browser.title = PFEXQuestHelper.Browser:CreateFontString("Status", "LOW", "GameFontNormal")
PFEXQuestHelper.Browser.title:SetFontObject(GameFontWhite)
PFEXQuestHelper.Browser.title:SetPoint("TOP", PFEXQuestHelper.Browser, "TOP", 0, -8)
PFEXQuestHelper.Browser.title:SetJustifyH("LEFT")
PFEXQuestHelper.Browser.title:SetFont(pfUI.font_default, 14)
PFEXQuestHelper.Browser.title:SetText("|cff33ffccpf|rQuest-" .. pfExtend_Loc["windowTitle_QuestHelper"])

-- Estadísticas
PFEXQuestHelper.Browser.questStats = PFEXQuestHelper.Browser:CreateFontString("QuestStats", "LOW", "GameFontNormal")
PFEXQuestHelper.Browser.questStats:SetFontObject(GameFontWhite)
PFEXQuestHelper.Browser.questStats:SetPoint("TOP", PFEXQuestHelper.Browser, "TOP", 0, -28)
PFEXQuestHelper.Browser.questStats:SetJustifyH("CENTER")
PFEXQuestHelper.Browser.questStats:SetFont(pfUI.font_default, 12)
PFEXQuestHelper.Browser.questStats:SetText("")

-- Botón cerrar
PFEXQuestHelper.Browser.close = CreateFrame("Button", "QuestHelperBrowserClose", PFEXQuestHelper.Browser)
PFEXQuestHelper.Browser.close:SetPoint("TOPRIGHT", -5, -5)
PFEXQuestHelper.Browser.close:SetHeight(20)
PFEXQuestHelper.Browser.close:SetWidth(20)
PFEXQuestHelper.Browser.close.texture = PFEXQuestHelper.Browser.close:CreateTexture("QHBrowserCloseTex")
PFEXQuestHelper.Browser.close.texture:SetTexture(COMPAT .. "close")
PFEXQuestHelper.Browser.close.texture:ClearAllPoints()
PFEXQuestHelper.Browser.close.texture:SetVertexColor(1, .25, .25, 1)
PFEXQuestHelper.Browser.close.texture:SetPoint("TOPLEFT",     PFEXQuestHelper.Browser.close, "TOPLEFT",     4, -4)
PFEXQuestHelper.Browser.close.texture:SetPoint("BOTTOMRIGHT", PFEXQuestHelper.Browser.close, "BOTTOMRIGHT", -4, 4)
PFEXQuestHelper.Browser.close:SetScript("OnClick", function() this:GetParent():Hide() end)
EnableTooltips(PFEXQuestHelper.Browser.close, { pfExtend_Loc["Close"], pfExtend_Loc["Hide browser window"] })
pfUI.api.SkinButton(PFEXQuestHelper.Browser.close, 1, .5, .5)

-- Botón configuración
PFEXQuestHelper.Browser.setting = CreateFrame("Button", "QuestHelperSettingOpen", PFEXQuestHelper.Browser)
PFEXQuestHelper.Browser.setting:SetPoint("TOPRIGHT", -30, -5)
PFEXQuestHelper.Browser.setting:SetHeight(20)
PFEXQuestHelper.Browser.setting:SetWidth(20)
PFEXQuestHelper.Browser.setting.texture = PFEXQuestHelper.Browser.setting:CreateTexture("QHSettingOpenTex")
PFEXQuestHelper.Browser.setting.texture:SetTexture(COMPAT .. "tracker_settings")
PFEXQuestHelper.Browser.setting.texture:ClearAllPoints()
PFEXQuestHelper.Browser.setting.texture:SetPoint("TOPLEFT",     PFEXQuestHelper.Browser.setting, "TOPLEFT",     2, -2)
PFEXQuestHelper.Browser.setting.texture:SetPoint("BOTTOMRIGHT", PFEXQuestHelper.Browser.setting, "BOTTOMRIGHT", -2, 2)
PFEXQuestHelper.Browser.setting:SetScript("OnClick", function()
    WorldMapFrame:Hide()
    pfExtendConfig:Show()
    CaptionClick("QuestHelper")
end)
EnableTooltips(PFEXQuestHelper.Browser.setting, { pfExtend_Loc["Setting"], pfExtend_Loc["Open Config Window"] })
pfUI.api.SkinButton(PFEXQuestHelper.Browser.setting)

-- Área de scroll
PFEXQuestHelper.Browser.scroll = pfUI.api.CreateScrollFrame("QuestHelperBrowserScroll", PFEXQuestHelper.Browser)
PFEXQuestHelper.Browser.scroll:SetPoint("TOPLEFT",     PFEXQuestHelper.Browser, "TOPLEFT",     10, -65)
PFEXQuestHelper.Browser.scroll:SetPoint("BOTTOMRIGHT", PFEXQuestHelper.Browser, "BOTTOMRIGHT", -10, 10)
PFEXQuestHelper.Browser.scroll:Show()
PFEXQuestHelper.Browser.scroll.buttons = {}
PFEXQuestHelper.Browser.scroll.backdrop = CreateFrame("Frame", "QuestHelperBrowserScrollBackdrop", PFEXQuestHelper.Browser.scroll)
PFEXQuestHelper.Browser.scroll.backdrop:SetFrameLevel(1)
PFEXQuestHelper.Browser.scroll.backdrop:SetPoint("TOPLEFT",     PFEXQuestHelper.Browser.scroll, "TOPLEFT",     -5, 5)
PFEXQuestHelper.Browser.scroll.backdrop:SetPoint("BOTTOMRIGHT", PFEXQuestHelper.Browser.scroll, "BOTTOMRIGHT", 5, -5)
pfUI.api.CreateBackdrop(PFEXQuestHelper.Browser.scroll.backdrop, nil, true)

PFEXQuestHelper.Browser.content = pfUI.api.CreateScrollChild("QuestHelperBrowserScrollScroll", PFEXQuestHelper.Browser.scroll)
PFEXQuestHelper.Browser.content:SetWidth(PFEXQuestHelper.Browser:GetWidth() - 30)
PFEXQuestHelper.Browser.content:SetHeight(PFEXQuestHelper.Browser:GetHeight() - 75)

PFEXQuestHelper.Browser.nodes      = {}
PFEXQuestHelper.Browser.rootNodes  = {}
PFEXQuestHelper.Browser.lineHeight = 20
PFEXQuestHelper.Browser.indent     = 20
PFEXQuestHelper.Browser.pinTitles  = {}
PFEXQuestHelper.nodes = {}
PFEXQuestHelper.pins  = {}
PFEXQuestHelper.expandToId = {}

-- ============================================================
-- Frame Pool (reutilización de widgets)
-- ============================================================
function PFEXQuestHelper.Browser:InitFramePool()
    self.framePool = { buttons = {}, used = {} }
    for i = 1, 50 do self:CreatePooledButton(i) end
end

function PFEXQuestHelper.Browser:CreatePooledButton(index)
    local button = CreateFrame("Button", nil, self.content)
    button:SetHeight(self.lineHeight)
    pfUI.api.SkinButton(button)
    button.tex = button:CreateTexture("BACKGROUND")
    button.tex:SetAllPoints()
    button.tex:SetTexture(1, 1, 1, .05)
    button.tex:Hide()
    button.texClickable = button:CreateTexture("BACKGROUND")
    button.texClickable:SetAllPoints()
    button.texClickable:SetTexture(1, 0.84, 0, .5)
    button.texClickable:Hide()

    local toggle = CreateFrame("Button", nil, button)
    toggle:SetWidth(16)
    toggle:SetHeight(16)
    toggle.tex = toggle:CreateTexture(nil, "ARTWORK")
    toggle.tex:SetAllPoints()

    button.text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    button.text:SetPoint("LEFT", toggle, "RIGHT", 5, 0)

    button.pin = button:CreateTexture(nil, "ARTWORK")
    button.pin:SetWidth(8)
    button.pin:SetHeight(8)
    button.pin:ClearAllPoints()
    button.pin:SetPoint("TOPLEFT", toggle, "TOPRIGHT", 1, 0)
    button.pin:SetTexture(COMPAT .. "track")
    button.pin:Hide()

    button:Hide()
    toggle:Hide()
    table.insert(self.framePool.buttons, { button = button, toggle = toggle, used = false, nodeRef = nil })
end

function PFEXQuestHelper.Browser:AcquireFrame()
    for _, pooled in ipairs(self.framePool.buttons) do
        if not pooled.used then
            pooled.used = true
            pooled.button:Show()
            pooled.toggle:Show()
            pooled.button.pin:Hide()
            return pooled
        end
    end
    self:CreatePooledButton(table.countNum(self.framePool.buttons) + 1)
    local pooled = self.framePool.buttons[table.countNum(self.framePool.buttons)]
    pooled.used = true
    pooled.button:Show()
    pooled.toggle:Show()
    pooled.button.pin:Hide()
    return pooled
end

function PFEXQuestHelper.Browser:ReleaseFrame(pooled)
    pooled.used    = false
    pooled.nodeRef = nil
    pooled.button:Hide()
    pooled.button.tex:Hide()
    pooled.button.texClickable:Hide()
    pooled.toggle:Hide()
    pooled.button:SetScript("OnClick",  nil)
    pooled.button:SetScript("OnEnter",  nil)
    pooled.button:SetScript("OnLeave",  nil)
    pooled.toggle:SetScript("OnClick",       nil)
    pooled.toggle:SetScript("OnDoubleClick", nil)
end

function PFEXQuestHelper.Browser:ReleaseAllFrames()
    for _, pooled in ipairs(self.framePool.buttons) do
        if pooled.used then self:ReleaseFrame(pooled) end
    end
end

-- ============================================================
-- Creación de nodos del árbol
-- ============================================================
function PFEXQuestHelper.Browser:CreateNode(data, parentNode, level, pooledFrame)
    local pooled = pooledFrame or self:AcquireFrame()
    local node = {
        data = data, parent = parentNode, level = level or 0,
        expanded = false, children = {}, visible = true,
        pooled = pooled, clickType = nil, mapNode = false, mapNodeTitle = nil,
    }
    pooled.nodeRef  = node
    node.clickTimer = nil

    local button = pooled.button
    local toggle = pooled.toggle
    button:SetWidth(self.content:GetWidth() - (level * self.indent))
    toggle:SetPoint("LEFT", 5 + (level * self.indent), 0)

    local flag = data.flag
    local color, tag, text = nil, "", nil

    if flag.UNKNOWN then
        text = "|cff9d9d9dDesconocido|r"
    elseif flag.FINISHED and not flag.AFTERFINISHED then
        color = "|cffffff2b";  tag = pfExtend_Loc["QuestHelper_FLAG_Finished"]
    elseif flag.FINISHED and flag.AFTERFINISHED then
        color = "|cff5a5a5a";  tag = pfExtend_Loc["QuestHelper_FLAG_Finished"]
    elseif flag.DOING then
        PFEXQuestHelper.expandToId[data.id] = true
        color = "|cff3eff2b";  tag = pfExtend_Loc["QuestHelper_FLAG_Active"]
    elseif flag.WRONGRACE  then color = "|cff5a5a5a"; tag = pfExtend_Loc["QuestHelper_FLAG_Race"]
    elseif flag.WRONGCLASS then color = "|cff5a5a5a"; tag = pfExtend_Loc["QuestHelper_FLAG_Class"]
    elseif flag.WRONGSKILL then color = "|cff5a5a5a"; tag = pfExtend_Loc["QuestHelper_FLAG_Skill"]
    elseif flag.EVENT      then color = "|cff2b3eff"; tag = pfExtend_Loc["QuestHelper_FLAG_Event"]
    elseif flag.UNDOPRE    then color = "|cffff2b2b"; tag = pfExtend_Loc["QuestHelper_FLAG_Prereq"]
    elseif flag.LOWLEVEL   then color = "|cffff2b2b"; tag = pfExtend_Loc["QuestHelper_FLAG_High-Level"]
    elseif flag.STARTITEM  then color = "|cffffff2b"; tag = pfExtend_Loc["QuestHelper_FLAG_Hidden"]
    else                        color = "|cffffff2b"; tag = pfExtend_Loc["QuestHelper_FLAG_Available"]
    end

    if text == nil and pfDB["quests"]["loc"] then
        text = color .. tag .. "  " .. pfDB["quests"]["loc"][data.id]["T"]
    else
        text = "|cff9d9d9dDesconocido|r"
    end
    button.text:SetText(text)

    if flag.HASPRE and node.level == 0 then node.clickType = "FINDPRE" end
    if flag.HASPRE and PfExtend_Database["QuestHelper"]["ZoneQuestData"][PFEXQuestHelper.zone] and
       PfExtend_Database["QuestHelper"]["ZoneQuestData"][PFEXQuestHelper.zone][data.id] == nil then
        node.clickType = "OTHERZONE"
    end

    toggle:SetScript("OnClick", function()
        if node.clickTimer then node.clickTimer:Cancel(); node.clickTimer = nil; return end
        node.clickTimer = C_Timer.NewTimer(0.2, function()
            node.clickTimer = nil
            self:ToggleNode(node)
        end)
    end)
    toggle:SetScript("OnDoubleClick", function()
        if node.clickTimer then node.clickTimer:Cancel(); node.clickTimer = nil end
        self:ToggleNodeAll(node)
    end)

    button:SetScript("OnClick", function()
        if IsControlKeyDown() and node.clickType == "FINDPRE" then
            local preId, preZone = PFEXQuestHelper.FindPreUndo(node.data.id)
            PFEXQuestHelper.expandToId[data.id] = true
            pfMap:SetMapByID(preZone)
        elseif node.clickType == "OTHERZONE" then
            if PfExtend_Database["QuestHelper"]["QuestZoneData"][data.id] then
                PFEXQuestHelper.expandToId[data.id] = true
                pfMap:SetMapByID(PfExtend_Database["QuestHelper"]["QuestZoneData"][data.id][1])
            end
        else
            node.mapNode = not node.mapNode
            if node.mapNode then
                button.pin:Show()
                node.mapNodeTitle = PFEXQuestHelper.AddMapNode(data.id, true)
                PFEXQuestHelper.Browser.pinTitles[node.mapNodeTitle] = true
            else
                button.pin:Hide()
                pfMap:DeleteNode("PFEX", node.mapNodeTitle)
                PFEXQuestHelper.Browser.pinTitles[node.mapNodeTitle] = false
            end
        end
    end)

    button:SetScript("OnEnter", function()
        if node.clickType then button.texClickable:Show() else button.tex:Show() end
        pfDatabase:ShowExtendedTooltip(data.id, GameTooltip, button, "ANCHOR_RIGHT", 0, 0)
        GameTooltip:AddLine(" ", 0.55, 0.55, 0.55)
        if node.clickType == "FINDPRE" then
            GameTooltip:AddLine(pfExtend_Loc["Click to fix on the map"], 0.55, 0.55, 0.55)
            GameTooltip:AddLine(pfExtend_Loc["Hold <Ctrl> and Click to track Pre-quest on the other map"], 0.55, 0.55, 0.55)
            GameTooltip:SetHeight(GameTooltip:GetHeight() + 42)
        elseif node.clickType == "OTHERZONE" then
            GameTooltip:AddLine(pfExtend_Loc["Click to track the quest on the other map"], 0.55, 0.55, 0.55)
            GameTooltip:SetHeight(GameTooltip:GetHeight() + 28)
        else
            GameTooltip:AddLine(pfExtend_Loc["Click to fix on the map"], 0.55, 0.55, 0.55)
            GameTooltip:SetHeight(GameTooltip:GetHeight() + 28)
        end
        local width = 0
        for line = 1, GameTooltip:NumLines() do
            width = math.max(width, getglobal(GameTooltip:GetName() .. "TextLeft" .. line):GetWidth())
        end
        GameTooltip:SetWidth(20 + width)
        if not node.mapNode then
            for i, pin in pairs(PFEXQuestHelper.pins) do
                if pin.title == node.mapNodeTitle then pin:Show() end
            end
        end
        pfMap.highlight = node.mapNodeTitle
    end)

    button:SetScript("OnLeave", function()
        button.tex:Hide()
        button.texClickable:Hide()
        GameTooltip:Hide()
        pfMap.highlight = nil
        for i, pin in pairs(PFEXQuestHelper.pins) do
            if pin.title == node.mapNodeTitle then pin:Hide() end
        end
    end)

    table.insert(self.nodes, node)
    if parentNode then
        table.insert(parentNode.children, node)
    else
        table.insert(self.rootNodes, node)
    end

    if data.children then
        for _, childData in ipairs(data.children) do
            self:CreateNode(childData, node, level + 1)
        end
    end

    if PFEXQuestHelper.expandToId[data.id] then
        local pnode = node
        for i = level, 0, -1 do
            pnode.expanded = true
            pnode = pnode.parent or pnode
        end
        button.texClickable:Show()
        PFEXQuestHelper.expandToId[data.id] = false
        if not PFEXQuestHelper.expandToRootId then PFEXQuestHelper.expandToRootId = pnode.data.id end
    end

    node.mapNodeTitle = PFEXQuestHelper.AddMapNode(data.id, false)
    if self.pinTitles[node.mapNodeTitle] then
        node.mapNode = true
        button.pin:Show()
    end

    self:UpdateNodeVisual(node)
    return node
end

function PFEXQuestHelper.Browser:UpdateQuestStats(dataList)
    local total, finished = 0, 0
    local function CountNodes(nodes)
        for _, node in ipairs(nodes) do
            total = total + 1
            if node.flag and node.flag.FINISHED then finished = finished + 1 end
            if node.children then CountNodes(node.children) end
        end
    end
    CountNodes(dataList)
    if total > 0 then
        local color = finished == total and "|cff00ff00" or "|cffffff00"
        self.questStats:SetText(color .. finished .. "|r/" .. total .. " " .. pfExtend_Loc["Quests"])
    else
        self.questStats:SetText("")
    end
end

function PFEXQuestHelper.Browser:BuildTree(dataList)
    if not self.framePool then self:InitFramePool() end
    self:ReleaseAllFrames()
    wipe(self.nodes)
    wipe(self.rootNodes)
    PFEXQuestHelper.nodes = {}
    self:UpdateQuestStats(dataList)
    for _, data in ipairs(dataList) do self:CreateNode(data, nil, 0) end
    self:RefreshLayout()
    if PFEXQuestHelper.expandToRootId then
        local i, quit = 0, false
        for _, rootNode in ipairs(self.rootNodes) do
            if rootNode.data.id == PFEXQuestHelper.expandToRootId then quit = true end
            if not quit then i = i + 1 end
        end
        self.scroll:SetVerticalScroll(math.min(i * self.lineHeight,
            math.max(self.content:GetHeight() - self:GetHeight() + 76, 0)))
        PFEXQuestHelper.expandToRootId = nil
    else
        self.scroll:SetVerticalScroll(0)
    end
    PFEXQuestHelper.UpdateNodes()
end

function PFEXQuestHelper.Browser:UpdateNodeVisual(node)
    local toggle = node.pooled.toggle
    if table.countNum(node.children) > 0 then
        toggle.tex:SetTexture(node.expanded
            and "Interface\\Buttons\\UI-MinusButton-Up"
            or  "Interface\\Buttons\\UI-PlusButton-Up")
        toggle:SetHighlightTexture(node.expanded
            and "Interface\\Buttons\\UI-MinusButton-Hilight"
            or  "Interface\\Buttons\\UI-PlusButton-Hilight")
        toggle:Show()
    else
        toggle.tex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
    end
    for _, child in ipairs(node.children) do
        child.visible = node.expanded and node.visible
        if child.visible then child.pooled.button:Show() else child.pooled.button:Hide() end
        self:UpdateNodeVisual(child)
    end
end

function PFEXQuestHelper.Browser:RefreshLayout()
    local visibleNodes = {}
    local function CollectVisible(nodes)
        for _, node in ipairs(nodes) do
            if node.visible then
                table.insert(visibleNodes, node)
                if node.expanded then CollectVisible(node.children) end
            end
        end
    end
    CollectVisible(self.rootNodes)
    for i, node in ipairs(visibleNodes) do
        local button = node.pooled.button
        button:ClearAllPoints()
        button:SetPoint("TOPLEFT",  self.content, "TOPLEFT",  0, -(i - 1) * self.lineHeight)
        button:SetPoint("TOPRIGHT", self.content, "TOPRIGHT", 0, -(i - 1) * self.lineHeight)
    end
    local totalHeight = table.countNum(visibleNodes) * self.lineHeight
    self.content:SetHeight(math.max(totalHeight, self:GetHeight() - 76))
    self.scroll:SetScrollChild(self.content)
end

function PFEXQuestHelper.Browser:ToggleNode(node)
    if table.countNum(node.children) == 0 then return end
    node.expanded = not node.expanded
    self:UpdateNodeVisual(node)
    self:RefreshLayout()
end

function PFEXQuestHelper.Browser:ToggleNodeAll(node)
    if table.countNum(node.children) == 0 then return end
    node.expanded = not node.expanded
    local function setChildren(n)
        for _, child in ipairs(n.children) do
            if table.countNum(child.children) > 0 then
                child.expanded = n.expanded
                setChildren(child)
            end
        end
    end
    setChildren(node)
    self:UpdateNodeVisual(node)
    self:RefreshLayout()
end

-- ============================================================
-- Nodos en el WorldMap
-- ============================================================
local best, neighbors = { index = 1, neighbors = 0 }, 0
local cache, cacheindex = {}, nil
local ymin, ymax, xmin, xmax
local similar_nodes = {}
local unifiedcache  = {}

local layers = {
    [pfQuestConfig.path .. "\\img\\available"]         = 1,
    [pfQuestConfig.path .. "\\img\\available_c"]       = 2,
    [pfQuestConfig.path .. "\\img\\complete"]          = 3,
    [pfQuestConfig.path .. "\\img\\complete_c"]        = 4,
    [pfQuestConfig.path .. "\\img\\startendstart"]     = 5,
    [pfQuestConfig.path .. "\\img\\icon_vendor"]       = 5,
    [pfQuestConfig.path .. "\\img\\fav"]               = 6,
    [pfQuestConfig.path .. "\\img\\cluster_item"]      = 9,
    [pfQuestConfig.path .. "\\img\\cluster_mob"]       = 9,
    [pfQuestConfig.path .. "\\img\\cluster_misc"]      = 9,
    [pfQuestConfig.path .. "\\img\\cluster_mob_mono"]  = 9,
    [pfQuestConfig.path .. "\\img\\cluster_item_mono"] = 9,
    [pfQuestConfig.path .. "\\img\\cluster_misc_mono"] = 9,
}
local function GetLayerByTexture(tex)
    return layers[tex] or 1
end

local function getcluster(tbl, name)
    local count = 0
    best.index, best.neighbors = 1, 0
    cacheindex = string.format("%s:%s", name, table.getn(tbl))
    if not cache[cacheindex] then
        for index, data in pairs(tbl) do
            xmin, xmax = data[1] - 5, data[1] + 5
            ymin, ymax = data[2] - 5, data[2] + 5
            neighbors  = 0
            count      = count + 1
            for _, compare in pairs(tbl) do
                if compare[1] > xmin and compare[1] < xmax and compare[2] > ymin and compare[2] < ymax then
                    neighbors = neighbors + 1
                end
            end
            if neighbors > best.neighbors then
                best.neighbors = neighbors
                best.index     = index
            end
        end
        cache[cacheindex] = { tbl[best.index][1] + .001, tbl[best.index][2] + .001, count }
    end
    return cache[cacheindex][1], cache[cacheindex][2], cache[cacheindex][3]
end

function PFEXQuestHelper.AddMapNode(id, ispfDB)
    local meta   = { ["addon"] = "PFEX" }
    local maps   = {}
    meta["questid"] = id
    meta["quest"]   = pfDB.quests.loc[id] and pfDB.quests.loc[id].T
    meta["quest"]   = meta["quest"] .. " (" .. id .. ")"
    meta["qlvl"]    = quests[id]["lvl"]
    meta["qmin"]    = quests[id]["min"]
    if meta.quest then unifiedcache[meta.quest] = {} end

    if quests[id]["start"] then
        if quests[id]["start"]["U"] then
            for _, unit in pairs(quests[id]["start"]["U"]) do
                meta["QTYPE"]   = "NPC_START"
                meta["layer"]   = meta["layer"] or 4
                meta["texture"] = pfQuestConfig.path .. "\\img\\available_c"
                if ispfDB then maps = pfDatabase:SearchMobID(unit, meta, maps, 0)
                else            maps = PFEXQuestHelper.SearchMobID(unit, meta, maps, 0) end
            end
        end
        if quests[id]["start"]["O"] then
            for _, object in pairs(quests[id]["start"]["O"]) do
                meta["QTYPE"]   = "OBJECT_START"
                meta["texture"] = pfQuestConfig.path .. "\\img\\available_c"
                if ispfDB then maps = pfDatabase:SearchObjectID(object, meta, maps, 0)
                else            maps = PFEXQuestHelper.SearchObjectID(object, meta, maps, 0) end
            end
        end
        if quests[id]["start"]["I"] then
            for _, object in pairs(quests[id]["start"]["I"]) do
                meta["QTYPE"] = "ITEM_OBJECTIVE_LOOT"
                if ispfDB then
                    local tempv = pfQuest_config.mindropchance
                    pfQuest_config.mindropchance = 0
                    maps = pfDatabase:SearchItemID(object, meta, maps, { ["U"] = true, ["I"] = true })
                    pfQuest_config.mindropchance = tempv
                else
                    maps = PFEXQuestHelper.SearchItemID(object, meta, maps, { ["U"] = true, ["I"] = true })
                end
            end
        end
    end

    if not ispfDB then
        if quests[id]["end"] then
            if quests[id]["end"]["U"] then
                for _, unit in pairs(quests[id]["end"]["U"]) do
                    if quests[id]["start"] and quests[id]["start"]["U"] and table.contain(quests[id]["start"]["U"], unit) then
                        meta["texture"] = pfQuestConfig.path .. "\\img\\startendstart"
                    else
                        meta["texture"] = pfQuestConfig.path .. "\\img\\complete"
                    end
                    meta["QTYPE"] = "NPC_END"
                    maps = PFEXQuestHelper.SearchMobID(unit, meta, maps, 0)
                end
            end
            if quests[id]["end"]["O"] then
                for _, object in pairs(quests[id]["end"]["O"]) do
                    if quests[id]["start"] and quests[id]["start"]["O"] and table.contain(quests[id]["start"]["O"], object) then
                        meta["texture"] = pfQuestConfig.path .. "\\img\\startendstart"
                    else
                        meta["texture"] = pfQuestConfig.path .. "\\img\\complete"
                    end
                    meta["QTYPE"] = "OBJECT_END"
                    maps = PFEXQuestHelper.SearchObjectID(object, meta, maps, 0)
                end
            end
        end
    end

    if PFEXQuestHelper.nodes["PFEX"] then
        for map in pairs(PFEXQuestHelper.nodes["PFEX"]) do
            if meta.quest and unifiedcache[meta.quest] and unifiedcache[meta.quest][map] then
                for hash, data in pairs(unifiedcache[meta.quest][map]) do
                    meta            = data.meta
                    meta["title"]   = meta["quest"]
                    meta["cluster"] = true
                    meta["zone"]    = map
                    local icon      = pfQuest_config["clustermono"] == "1" and "_mono" or ""
                    if meta.item then
                        meta["x"], meta["y"], meta["priority"] = getcluster(data.coords, meta["quest"] .. hash .. map)
                        meta["texture"] = pfQuestConfig.path .. "\\img\\cluster_item" .. icon
                    elseif meta.spawntype and meta.spawntype == pfQuest_Loc["Unit"] and meta.spawn and not meta.itemreq then
                        meta["x"], meta["y"], meta["priority"] = getcluster(data.coords, meta["quest"] .. hash .. map)
                        meta["texture"] = pfQuestConfig.path .. "\\img\\cluster_mob" .. icon
                    else
                        meta["x"], meta["y"], meta["priority"] = getcluster(data.coords, meta["quest"] .. hash .. map)
                        meta["texture"] = pfQuestConfig.path .. "\\img\\cluster_misc" .. icon
                    end
                    if ispfDB then pfMap:AddNode(meta) else PFEXQuestHelper.AddNode(meta) end
                end
            end
        end
    end
    return meta["quest"]
end

function PFEXQuestHelper.UpdateNodes()
    local color = pfQuest_config["spawncolors"] == "1" and "spawn" or "title"
    local map   = pfMap:GetMapID(GetCurrentMapContinent(), GetCurrentMapZone())
    local i     = 1
    pfQuest.tracker.Reset()
    pfQuest.route:Reset()
    for addon, _ in pairs(PFEXQuestHelper.nodes) do
        if PFEXQuestHelper.nodes[addon][map] then
            for coords, node in pairs(PFEXQuestHelper.nodes[addon][map]) do
                for title, info in pairs(node) do
                    if not PFEXQuestHelper.pins[i] then
                        PFEXQuestHelper.pins[i] = pfMap:BuildNode("pfEXMapPin" .. i, WorldMapButton)
                    end
                    pfMap:UpdateNode(PFEXQuestHelper.pins[i], { [title] = info }, color)
                    local _, _, x, y = strfind(coords, "(.*)|(.*)")
                    for title2, node2 in pairs(PFEXQuestHelper.pins[i].node) do
                        pfQuest.tracker.ButtonAdd(title2, node2)
                    end
                    x = x / 100 * WorldMapButton:GetWidth()
                    y = y / 100 * WorldMapButton:GetHeight()
                    PFEXQuestHelper.pins[i]:ClearAllPoints()
                    PFEXQuestHelper.pins[i]:SetPoint("CENTER", WorldMapButton, "TOPLEFT", x, -y)
                    PFEXQuestHelper.pins[i]:Hide()
                    i = i + 1
                end
            end
        end
    end
    for j = i, table.getn(PFEXQuestHelper.pins) do
        if PFEXQuestHelper.pins[j] then PFEXQuestHelper.pins[j]:Hide() end
    end
end

function PFEXQuestHelper.AddNode(meta)
    if not meta or not meta["zone"] or not meta["title"] then return end
    meta["description"] = pfDatabase:BuildQuestDescription(meta)
    local addon  = meta["addon"] or "PFEX"
    local map    = meta["zone"]
    local coords = meta["x"] .. "|" .. meta["y"]
    local title  = meta["title"]
    local layer  = GetLayerByTexture(meta["texture"])
    local spawn  = meta["spawn"]
    local item   = meta["item"]
    local sindex = string.format("%s:%s:%s:%s:%s:%s", (addon or ""), (map or ""), (coords or ""), (title or ""), (layer or ""), (spawn or ""), (item or ""))
    if layer >= 9 and meta["priority"] then layer = layer + (10 - min(meta["priority"], 10)) end
    if not PFEXQuestHelper.nodes[addon]           then PFEXQuestHelper.nodes[addon] = {} end
    if not PFEXQuestHelper.nodes[addon][map]      then PFEXQuestHelper.nodes[addon][map] = {} end
    if not PFEXQuestHelper.nodes[addon][map][coords] then PFEXQuestHelper.nodes[addon][map][coords] = {} end
    if PFEXQuestHelper.nodes[addon][map][coords][title] then
        if item and table.getn(PFEXQuestHelper.nodes[addon][map][coords][title].item) > 0 then
            for id, name in pairs(PFEXQuestHelper.nodes[addon][map][coords][title].item) do
                if name == item then return end
            end
            table.insert(PFEXQuestHelper.nodes[addon][map][coords][title].item, item)
            return
        end
        if PFEXQuestHelper.nodes[addon][map][coords][title].layer and layer and
           PFEXQuestHelper.nodes[addon][map][coords][title].layer >= layer then
            return
        end
    end
    if not similar_nodes[sindex] then
        similar_nodes[sindex] = {}
        for key, val in pairs(meta) do similar_nodes[sindex][key] = val end
        similar_nodes[sindex].item = { [1] = item }
    end
    PFEXQuestHelper.nodes[addon][map][coords][title] = similar_nodes[sindex]
    if not meta["cluster"] and not meta["texture"] then
        local node_index = meta.item or meta.spawn or UNKNOWN
        local x, y = tonumber(meta.x), tonumber(meta.y)
        unifiedcache[title] = unifiedcache[title] or {}
        unifiedcache[title][map] = unifiedcache[title][map] or {}
        if not unifiedcache[title][map][node_index] then
            local unified_meta = {}
            for key, val in pairs(meta) do unified_meta[key] = val end
            unifiedcache[title][map][node_index] = { meta = unified_meta, coords = {} }
        end
        table.insert(unifiedcache[title][map][node_index].coords, { x, y })
    end
end

-- Búsquedas (reuses pfQuest's DB but routes through PFEX node system)
function PFEXQuestHelper.SearchMobID(id, meta, maps, prio)
    if not units[id] or not units[id]["coords"] then return maps end
    local maps = maps or {}
    local prio = prio or 1
    for _, data in pairs(units[id]["coords"]) do
        local x, y, zone, respawn = unpack(data)
        if zone > 0 then
            meta = meta or {}
            meta["spawn"]     = pfDB.units.loc[id]
            meta["spawnid"]   = id
            meta["title"]     = meta["quest"] or meta["item"] or meta["spawn"]
            meta["zone"]      = zone
            meta["x"]         = x
            meta["y"]         = y
            meta["level"]     = units[id]["lvl"] or UNKNOWN
            meta["spawntype"] = pfQuest_Loc["Unit"]
            meta["respawn"]   = respawn > 0 and SecondsToTime(respawn)
            maps[zone]        = maps[zone] and maps[zone] + prio or prio
            PFEXQuestHelper.AddNode(meta)
        end
    end
    return maps
end

function PFEXQuestHelper.SearchObjectID(id, meta, maps, prio)
    if not objects[id] or not objects[id]["coords"] then return maps end
    local skill, caption = pfDatabase:SearchObjectSkill(id)
    local maps = maps or {}
    local prio = prio or 1
    for _, data in pairs(objects[id]["coords"]) do
        local x, y, zone, respawn = unpack(data)
        if zone > 0 then
            meta = meta or {}
            meta["spawn"]     = pfDB.objects.loc[id]
            meta["spawnid"]   = id
            meta["title"]     = meta["quest"] or meta["item"] or meta["spawn"]
            meta["zone"]      = zone
            meta["x"]         = x
            meta["y"]         = y
            meta["level"]     = skill and string.format("%s [%s]", skill, caption) or nil
            meta["spawntype"] = pfQuest_Loc["Object"]
            meta["respawn"]   = respawn and SecondsToTime(respawn)
            maps[zone]        = maps[zone] and maps[zone] + prio or prio
            PFEXQuestHelper.AddNode(meta)
        end
    end
    return maps
end

function PFEXQuestHelper.SearchItemID(id, meta, maps, allowedTypes)
    if not items[id] then return maps end
    local maps = maps or {}
    local meta = meta or {}
    meta["itemid"] = id
    meta["item"]   = pfDB.items.loc[id]
    if items[id]["U"] and ((not allowedTypes) or allowedTypes["U"]) then
        for unit, chance in pairs(items[id]["U"]) do
            if chance >= 0 then
                meta["texture"] = nil; meta["droprate"] = chance; meta["sellcount"] = nil
                maps = PFEXQuestHelper.SearchMobID(unit, meta, maps)
            end
        end
    end
    if items[id]["O"] and ((not allowedTypes) or allowedTypes["O"]) then
        for object, chance in pairs(items[id]["O"]) do
            if chance >= 0 and chance > 0 then
                meta["texture"] = nil; meta["droprate"] = chance; meta["sellcount"] = nil
                maps = PFEXQuestHelper.SearchObjectID(object, meta, maps)
            end
        end
    end
    if items[id]["R"] then
        for ref, chance in pairs(items[id]["R"]) do
            if chance >= 0 and refloot[ref] then
                if refloot[ref]["U"] and ((not allowedTypes) or allowedTypes["U"]) then
                    for unit in pairs(refloot[ref]["U"]) do
                        meta["texture"] = nil; meta["droprate"] = chance; meta["sellcount"] = nil
                        maps = PFEXQuestHelper.SearchMobID(unit, meta, maps)
                    end
                end
                if refloot[ref]["O"] and ((not allowedTypes) or allowedTypes["O"]) then
                    for object in pairs(refloot[ref]["O"]) do
                        meta["texture"] = nil; meta["droprate"] = chance; meta["sellcount"] = nil
                        maps = PFEXQuestHelper.SearchObjectID(object, meta, maps)
                    end
                end
            end
        end
    end
    if items[id]["V"] and ((not allowedTypes) or allowedTypes["V"]) then
        for unit, chance in pairs(items[id]["V"]) do
            meta["texture"]   = pfQuestConfig.path .. "\\img\\icon_vendor"
            meta["droprate"]  = nil
            meta["sellcount"] = chance
            maps = PFEXQuestHelper.SearchMobID(unit, meta, maps)
        end
    end
    return maps
end
