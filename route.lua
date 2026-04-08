-- pfQuest.route [Sequito del Terror Edition]
-- Optimized for Turtle WoW 1.17 [Lag-Free Engine]
-- Rebuilt for stability and hierarchical priority.

local function tablesize(tbl)
  local count = 0
  for _ in pairs(tbl) do count = count + 1 end
  return count
end

local function modulo(val, by)
  return val - math.floor(val/by)*by;
end

-- global coordinate projection cache
pfQuest.route = pfQuest.route or CreateFrame("Frame", "pfQuestRoute", WorldFrame)
pfQuest.route.coords = {}
pfQuest.route.firstnode = nil
pfQuest.route._proj_px    = 0
pfQuest.route._proj_py    = 0
pfQuest.route._proj_mapID = 0
pfQuest.route._proj_frame = 0

pfQuest.route.Reset = function(self)
  self.coords = {}
  self.firstnode = nil
end

pfQuest.route.AddPoint = function(self, tbl)
  table.insert(self.coords, tbl)
  self.firstnode = nil
end

pfQuest.route.LockToQuest = function(self, title, id)
  if not title then return end
  self.activeQuest = title
  self.activeQuestID = id or (pfQuest.questlog and pfQuest.questlog[title] and pfQuest.questlog[title].id)
  self.lockX, self.lockY = nil, nil
  
  local nearest = nil
  local bestX, bestY = nil, nil
  
  if self.coords then
    for id, data in pairs(self.coords) do
      local match = nil
      if self.activeQuestID and data[3].questid and self.activeQuestID == data[3].questid then
        match = true
      elseif data[3].title == title then
        match = true
      end

      if match and data[4] then
         if not nearest or data[4] < nearest then
            nearest = data[4]
            bestX, bestY = data[1], data[2]
         end
      end
    end
  end
  
  self.lockX, self.lockY = bestX, bestY
end

local targetTitle, targetCluster, targetLayer, targetTexture = nil, nil, nil, nil
pfQuest.route.SetTarget = function(node, default)
  if node and ( node.title ~= targetTitle
    or node.cluster ~= targetCluster
    or node.layer ~= targetLayer
    or node.texture ~= targetTexture )
  then
    pfMap.queue_update = true
  end

  targetTitle = node and node.title or nil
  targetCluster = node and node.cluster or nil
  targetLayer = node and node.layer or nil
  targetTexture = node and node.texture or nil
end

pfQuest.route.IsTarget = function(node)
  if not node then return nil end

  -- Priority 1: Manual Sticky Quest (ID Match is Sovereign)
  if pfQuest.route.activeQuestID and node.questid and pfQuest.route.activeQuestID == node.questid then
    return true
  end

  -- Priority 2: Title Fallback (Localization compatible)
  if pfQuest.route.activeQuest and pfQuest.route.activeQuest == node.title then
    return true
  end

  -- Priority 3: Coordinate Lock (Map click targeting)
  if pfQuest.route.lockX and pfQuest.route.lockY then
    local nodeX = tonumber(node.x or 0)
    local nodeY = tonumber(node.y or 0)
    local lockX = tonumber(pfQuest.route.lockX)
    local lockY = tonumber(pfQuest.route.lockY)
    
    if nodeX and nodeY and lockX and lockY then
      local epsilon = 0.001
      if math.abs(nodeX - lockX) < epsilon and math.abs(nodeY - lockY) < epsilon then
        return true
      end
    end
    return nil
  end

  -- Priority 4: Legacy Frame Selectors
  if targetTitle and targetTitle == node.title
    and targetCluster == node.cluster
    and targetLayer == node.layer
    and targetTexture == node.texture
  then
    return true
  end

  return nil
end

-- Event-based hierarchy cache
pfQuest.route.hCache = {}
pfQuest.route:RegisterEvent("QUEST_LOG_UPDATE")
pfQuest.route:RegisterEvent("PLAYER_ENTERING_WORLD")
pfQuest.route:SetScript("OnEvent", function()
  if event == "QUEST_LOG_UPDATE" or event == "PLAYER_ENTERING_WORLD" then
    this.hCache = {}
    if pfQuest.questlog then
      for qid, data in pairs(pfQuest.questlog) do
        if data.title and data.qlogid then
          this.hCache[data.title] = tonumber(data.qlogid)
        end
      end
    end
  end
end)

local lastpos, completed = 0, 0
local function sortfunc(a, b)
  -- Priority 1: Hierarchy Rank (Sticky=0, LogIndex=1-N, Others=9999)
  local rankA = a[5] or 9999
  local rankB = b[5] or 9999
  if rankA ~= rankB then
    return rankA < rankB
  end

  -- Priority 2: Local distance (Tie-breaker for same quest)
  local distA = a[4] or 99999
  local distB = b[4] or 99999
  if distA ~= distB then
    return distA < distB
  end

  -- Priority 3: Stability
  local sA = (a[1] or 0) .. ":" .. (a[2] or 0)
  local sB = (b[1] or 0) .. ":" .. (b[2] or 0)
  return sA < sB
end

pfQuest.route:SetScript("OnUpdate", function()
  if not next(this.coords) then return end

  local xplayer, yplayer = GetPlayerMapPosition("player")
  if xplayer == 0 and yplayer == 0 then
    if this.arrow:IsShown() then this.arrow:Hide() end
    return
  end
  
  local curpos = xplayer + yplayer

  -- Throttle: distance and rank update (Stable at 0.2s)
  local now = GetTime()
  if (this.throttle or 0) > now and lastpos == curpos then return end
  this.throttle = now + 0.2
  lastpos = curpos

  -- Hierarchy Logic State
  local isLocked = (pfQuest.route.activeQuestID or pfQuest.route.activeQuest) and true or nil
  local hCache = this.hCache or {}

  -- Unified processing loop: Distances + Ranks (Backup Math Restoration)
  for id, data in pairs(this.coords) do
    if data[1] and data[2] then
      -- Multiplier 1.5 is the native Shagu/Backup standard for xDelta
      local tx, ty = data[1], data[2]
      local dx = (xplayer*100 - tx) * 1.5
      local dy = (yplayer*100 - ty)
      this.coords[id][4] = ceil(sqrt(dx * dx + dy * dy) * 100) / 100
      
      -- Rank assignment
      local rank = 9999
      local node = data[3]
      if pfQuest.route.IsTarget and pfQuest.route.IsTarget(node) then
        rank = 0
      elseif not isLocked and node and node.title and hCache[node.title] then
        rank = hCache[node.title]
      end
      this.coords[id][5] = rank
    end
  end

  -- Perform Hierarchical Sort (Throttled for performance)
  if not this.recalculate or this.recalculate < now then
    table.sort(this.coords, sortfunc)
    this.recalculate = now + 1.2
  end

  -- Visibility Check
  if this.coords[1] and this.coords[1][4] then
     if not this.arrow:IsShown() and pfQuest_config["arrow"] == "1" then
       this.arrow:Show()
     end
  else
     if this.arrow:IsShown() then this.arrow:Hide() end
  end

  -- Cache values for Arrow model (Backup math compatibility)
  this._proj_px = xplayer * 100
  this._proj_py = yplayer * 100
  this._proj_frame = now
  
  -- Abort if no targets or routes disabled
  if not this.coords[1] or not this.coords[1][4] or pfQuest_config["routes"] == "0" then
    return
  end
end)

-- Arrow Frame Logic [Optimized Layer]
pfQuest.route.arrow = pfQuest.route.arrow or CreateFrame("Frame", "pfQuestRouteArrow", UIParent)
pfQuest.route.arrow:SetPoint("CENTER", 0, -100)
pfQuest.route.arrow:SetWidth(48)
pfQuest.route.arrow:SetHeight(36)
pfQuest.route.arrow:SetClampedToScreen(true)
pfQuest.route.arrow:SetMovable(true)
pfQuest.route.arrow:EnableMouse(true)
pfQuest.route.arrow:RegisterForDrag('LeftButton')
if not pfQuest.route.arrow:GetScript("OnDragStart") then
  pfQuest.route.arrow:SetScript("OnDragStart", function() if IsShiftKeyDown() then this:StartMoving() end end)
  pfQuest.route.arrow:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)
end
pfQuest.route.arrow.parent = pfQuest.route

pfQuest.route.arrow:SetScript("OnUpdate", function()
  if not this.parent then return end
  local target = this.parent.coords[1]
  local now = GetTime()
  
  -- Use cached projection for lag-free performance
  local px = this.parent._proj_px
  local py = this.parent._proj_py
  
  if not target or (GetPlayerMapPosition("player") == 0) or pfQuest_config["arrow"] == "0" then
    this:Hide()
    return
  end

  -- Vector calculation (Legacy Space)
  local dx, dy = target[1] - px, target[2] - py
  local AR = (pfQuest.Projections and pfQuest.Projections.ASPECT_RATIO) or 1.58
  dx = dx * AR
  
  local dir = atan2(dx, -dy)
  dir = dir > 0 and (math.pi*2) - dir or -dir
  if dir < 0 then dir = dir + 360 end
  local angle = math.rad(dir) - pfQuestCompat.GetPlayerFacing()

  -- Visual texture updates
  local perc = math.abs(((math.pi - math.abs(angle)) / math.pi))
  local cell = modulo(floor(angle / (math.pi*2) * 108 + 0.5), 108)
  local column = modulo(cell, 9)
  local row = floor(cell / 9)

  this.model:SetTexCoord((column * 56) / 512, ((column + 1) * 56) / 512, (row * 42) / 512, ((row + 1) * 42) / 512)
  
  -- Update texts and distances
  if target and target[3] and target ~= this.lasttarget then
    local color = "|cffffcc00"
    if target[3]["qlvl"] and tonumber(target[3]["qlvl"]) then color = pfMap:HexDifficultyColor(tonumber(target[3]["qlvl"])) end
    local level = target[3].qlvl and "[" .. target[3].qlvl .. "] " or ""
    local title = target[3].title or "???"
    this.title:SetText(color..level..title.."|r")
    this.description:SetText((target[3].description or "").. "|r.")
    this.lasttarget = target
  end

  local dist = target and target[4] and floor(target[4]*10)/10 or 0
  if dist ~= this.distance.number then
    this.distance:SetText("|cffaaaaaa" .. pfQuest_Loc["Distance"] .. ": "..string.format("%.1f", dist))
    this.distance.number = dist
  end
end)

-- Visual elements creation (If Not Exists)
if not pfQuest.route.arrow.model then
  pfQuest.route.arrow.texture = pfQuest.route.arrow:CreateTexture(nil, "OVERLAY")
  pfQuest.route.arrow.texture:SetWidth(28); pfQuest.route.arrow.texture:SetHeight(28); pfQuest.route.arrow.texture:SetPoint("BOTTOM", 0, 0)
  
  pfQuest.route.arrow.model = pfQuest.route.arrow:CreateTexture(nil, "MEDIUM")
  pfQuest.route.arrow.model:SetTexture(pfQuestConfig.path.."\\img\\arrow"); pfQuest.route.arrow.model:SetAllPoints()
  
  pfQuest.route.arrow.title = pfQuest.route.arrow:CreateFontString(nil, "HIGH", "GameFontWhite")
  pfQuest.route.arrow.title:SetPoint("TOP", pfQuest.route.arrow.model, "BOTTOM", 0, -10)
  pfQuest.route.arrow.title:SetFont(pfUI.font_default, 13, "OUTLINE")
  
  pfQuest.route.arrow.description = pfQuest.route.arrow:CreateFontString(nil, "HIGH", "GameFontWhite")
  pfQuest.route.arrow.description:SetPoint("TOP", pfQuest.route.arrow.title, "BOTTOM", 0, -2)
  pfQuest.route.arrow.description:SetFont(pfUI.font_default, 12, "OUTLINE")
  
  pfQuest.route.arrow.distance = pfQuest.route.arrow:CreateFontString(nil, "HIGH", "GameFontWhite")
  pfQuest.route.arrow.distance:SetPoint("TOP", pfQuest.route.arrow.description, "BOTTOM", 0, -2)
  pfQuest.route.arrow.distance:SetFont(pfUI.font_default, 11, "OUTLINE")
end
