-- Performance: cache globals
local pairs, ipairs, next = pairs, ipairs, next
local floor, ceil, sqrt, abs = math.floor, math.ceil, math.sqrt, math.abs
local min, max, pi = math.min, math.max, math.pi
local atan2 = math.atan2 or function(y, x) return math.atan(y, x) end
local GetTime = GetTime
local GetPlayerMapPosition = GetPlayerMapPosition
local tostring, tonumber = tostring, tonumber

-- table.getn doesn't return sizes on tables that
-- are using a named index on which setn is not updated
local function tablesize(tbl)
  local count = 0
  for _ in pairs(tbl) do count = count + 1 end
  return count
end

function modulo(val, by)
  return val - math.floor(val/by)*by;
end

local function GetNearest(xstart, ystart, db, blacklist)
  local nearest = nil
  local best = nil

  for id, data in pairs(db) do
    if data[1] and data[2] and not blacklist[id] then
      local x,y = xstart - data[1], ystart - data[2]
      local distance = ceil(math.sqrt(x*x+y*y)*100)/100

      if not nearest or distance < nearest then
        nearest = distance
        best = id
      end
    end
  end

  if not best then return end

  blacklist[best] = true
  return db[best]
end

-- connection between objectives
local objectivepath = {}

-- connection between player and the first objective
local playerpath = {} -- worldmap
local mplayerpath = {} -- minimap

local function ClearPath(path)
  for id, tex in pairs(path) do
    tex.enable = nil
    tex:Hide()
  end
end

local function DrawLine(path,x,y,nx,ny,hl,minimap)
  local display = true
  local zoom = 1

  -- calculate minimap variables
  local xplayer, yplayer, xdraw, ydraw
  if minimap then
    -- player coords
    xplayer, yplayer = GetPlayerMapPosition("player")
    xplayer, yplayer = xplayer * 100, yplayer * 100

    -- query minimap zoom/size data
    local mZoom = pfMap.drawlayer:GetZoom()
    local mapID = pfMap:GetMapIDByName(GetRealZoneText())
    local mapZoom = pfMap.minimap_zoom[pfMap.minimap_indoor()][mZoom]
    local mapWidth = pfMap.minimap_sizes[mapID] and pfMap.minimap_sizes[mapID][1] or 0
    local mapHeight = pfMap.minimap_sizes[mapID] and pfMap.minimap_sizes[mapID][2] or 0

    -- calculate drawlayer size
    xdraw = pfMap.drawlayer:GetWidth() / (mapZoom / mapWidth) / 100
    ydraw = pfMap.drawlayer:GetHeight() / (mapZoom / mapHeight) / 100
    zoom = (((mapZoom / mapWidth))+((mapZoom / mapHeight))) * 3
  end

  -- general
  local dx, dy = x - nx, y - ny
  local dots = ceil(math.sqrt(dx*1.5*dx*1.5+dy*dy)) / zoom

  for i=(minimap and 1 or 2), dots-(minimap and 1 or 2) do
    local xpos = nx + dx/dots*i
    local ypos = ny + dy/dots*i

    if minimap then
      -- adjust values to minimap
      xpos = ( xplayer - xpos ) * xdraw
      ypos = ( yplayer - ypos ) * ydraw

      -- check if dot should be visible
      if pfUI.minimap then
        display = ( abs(xpos) + 1 < pfMap.drawlayer:GetWidth() / 2 and abs(ypos) + 1 < pfMap.drawlayer:GetHeight()/2 ) and true or nil
      else
        local distance = sqrt(xpos * xpos + ypos * ypos)
        display = ( distance + 1 < pfMap.drawlayer:GetWidth() / 2 ) and true or nil
      end
    else
      -- adjust values to worldmap
      xpos = xpos / 100 * WorldMapButton:GetWidth()
      ypos = ypos / 100 * WorldMapButton:GetHeight()
    end

    if display then
      local nline = tablesize(path) + 1
      for id, tex in pairs(path) do
        if not tex.enable then nline = id break end
      end

      path[nline] = path[nline] or (minimap and pfMap.drawlayer or WorldMapButton.routes):CreateTexture(nil, "OVERLAY")
      path[nline]:SetWidth(4)
      path[nline]:SetHeight(4)
      path[nline]:SetTexture(pfQuestConfig.path.."\\img\\route")
      if hl and minimap then
        path[nline]:SetVertexColor(.6,.4,.2,.5)
      elseif hl then
        path[nline]:SetVertexColor(1,.8,.4,1)
      else
        path[nline]:SetVertexColor(.6,.4,.2,1)
      end

      path[nline]:ClearAllPoints()

      if minimap then -- draw minimap
        path[nline]:SetPoint("CENTER", pfMap.drawlayer, "CENTER", -xpos, ypos)
      else -- draw worldmap
        path[nline]:SetPoint("CENTER", WorldMapButton, "TOPLEFT", xpos, -ypos)
      end

      path[nline]:Show()
      path[nline].enable = true
    end
  end
end

pfQuest.route = pfQuest.route or CreateFrame("Frame", "pfQuestRoute", WorldFrame)
pfQuest.route.firstnode = nil
pfQuest.route.coords = {}
pfQuest.route.activeQuest = nil
pfQuest.route.lockX = nil
pfQuest.route.lockY = nil

-- Cache de proyeccion por frame: evita recalcular UnApply en cada tick de la flecha
pfQuest.route._proj_frame = 0
pfQuest.route._proj_px    = 0
pfQuest.route._proj_py    = 0
pfQuest.route._proj_mapID = 0

pfQuest.route.Reset = function(self)
  self.coords = {}
  self.firstnode = nil
end

pfQuest.route.AddPoint = function(self, tbl)
  if self.lockX and self.lockY and tbl[1] == self.lockX and tbl[2] == self.lockY then
    table.insert(self.coords, 1, tbl)
  else
    table.insert(self.coords, tbl)
  end
  self.firstnode = nil
end

function pfQuest.route:LockToQuest(title)
  if not title then return end
  self.activeQuest = title
  self.lockX, self.lockY = nil, nil
  
  local nearest = nil
  local bestX, bestY = nil, nil
  
  -- recalculate nearest of THIS quest in current coords list
  if self.coords then
    for id, data in pairs(self.coords) do
      if data[3].title == title and data[4] then
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
  if node then
    -- Priority 1: Locked Coordinates (Sticky Target)
    if pfQuest.route.lockX and pfQuest.route.lockY then
      if node.x == pfQuest.route.lockX and node.y == pfQuest.route.lockY then
        return true
      end
      -- if we are locked to a specific point, don't fallback to other points of same quest
      -- unless they are identical (which shouldn't happen)
      return nil
    end

    -- Priority 2: Active Quest (Manual Selection)
    if pfQuest.route.activeQuest and pfQuest.route.activeQuest == node.title then
      return true
    end

    -- Priority 3: Custom Map Target (Classic Map Click)
    if targetTitle and targetTitle == node.title
      and targetCluster == node.cluster
      and targetLayer == node.layer
      and targetTexture == node.texture
    then
      return true
    end
  end
  return nil
end

local lastpos, completed = 0, 0

local function sortfunc(a, b)
  if pfQuest.route and pfQuest.route.IsTarget then
    local ta = pfQuest.route.IsTarget(a[3])
    local tb = pfQuest.route.IsTarget(b[3])
    if ta and not tb then return true end
    if tb and not ta then return false end
  end
  if not a[4] then return false end
  if not b[4] then return true end
  return a[4] < b[4]
end

pfQuest.route:SetScript("OnUpdate", function()
  local xplayer, yplayer = GetPlayerMapPosition("player")
  local wrongmap = xplayer == 0 and yplayer == 0 and true or nil
  local curpos = xplayer + yplayer

  -- Throttle: update distances max once per 0.1s, and only on position change OR every 1s
  local now = GetTime()
  if (this.throttle or 0) > now and lastpos == curpos then return end
  this.throttle = now + 0.1
  lastpos = curpos

  -- update distances to player in Legacy Coordinate Space
  local mapID = pfMap:GetMapID()
  local proj_px, proj_py = pfQuest.Projections:UnApply(mapID, xplayer * 100, yplayer * 100)
  local AR = pfQuest.Projections.ASPECT_RATIO

  -- cache projected player position for arrow OnUpdate (avoids duplicate UnApply call)
  this._proj_px    = proj_px
  this._proj_py    = proj_py
  this._proj_mapID = mapID
  this._proj_frame = now

  for id, data in pairs(this.coords) do
    if data[1] and data[2] then
      local tx, ty = data[1], data[2]
      local dx = (proj_px - tx) * AR
      local dy = proj_py - ty
      this.coords[id][4] = ceil(sqrt(dx * dx + dy * dy) * 100) / 100
    end
  end

  -- sort all coords by distance (and target priority) once per second
  if not this.recalculate or this.recalculate < now then
    table.sort(this.coords, sortfunc)

    -- clear lock if reached (within 5 yards)
    if this.lockX and this.coords[1] and this.coords[1][4] and this.coords[1][4] < 5 then
      this.lockX, this.lockY = nil, nil
    end

    this.recalculate = now + 1
  end

  -- show arrow when there are valid coords and arrow is enabled
  if not wrongmap and this.coords[1] and this.coords[1][4] and
     pfQuest_config["arrow"] == "1" and not this.arrow:IsShown() then
    this.arrow:Show()
  end

  -- abort without any nodes or when routes disabled
  if not this.coords[1] or not this.coords[1][4] or pfQuest_config["routes"] == "0" then
    ClearPath(objectivepath)
    ClearPath(playerpath)
    ClearPath(mplayerpath)
    return
  end

  -- check first node for changes
  if this.firstnode ~= tostring(this.coords[1][1] .. this.coords[1][2]) then
    this.firstnode = tostring(this.coords[1][1] .. this.coords[1][2])

    -- recalculate objective paths
    local route = { [1] = this.coords[1] }
    local blacklist = { [1] = true }
    for i = 2, table.getn(this.coords) do
      if route[i - 1] then
        route[i] = GetNearest(route[i-1][1], route[i-1][2], this.coords, blacklist)
      end

      if route[i] and route[i][3] and route[i][3].itemreq then
        for id, data in pairs(this.coords) do
          if not blacklist[id] and data[1] and data[2] and data[3]
            and data[3].itemreq and data[3].itemreq == route[i][3].itemreq
          then
            blacklist[id] = true
          end
        end
      end
    end

    ClearPath(objectivepath)
    for i, data in pairs(route) do
      if i > 1 then
        DrawLine(objectivepath, route[i-1][1], route[i-1][2], route[i][1], route[i][2])
      end
    end

    completed = now
  end

  if wrongmap then
    ClearPath(playerpath)
    ClearPath(mplayerpath)
  else
    ClearPath(playerpath)
    ClearPath(mplayerpath)
    DrawLine(playerpath, xplayer * 100, yplayer * 100, this.coords[1][1], this.coords[1][2], true)

    if pfQuest_config["routeminimap"] == "1" then
      DrawLine(mplayerpath, xplayer * 100, yplayer * 100, this.coords[1][1], this.coords[1][2], true, true)
    end
  end
end)

pfQuest.route.drawlayer = CreateFrame("Frame", "pfQuestRouteDrawLayer", WorldMapButton)
pfQuest.route.drawlayer:SetFrameLevel(113)
pfQuest.route.drawlayer:SetAllPoints()

WorldMapButton.routes = CreateFrame("Frame", "pfQuestRouteDisplay", pfQuest.route.drawlayer)
WorldMapButton.routes:SetAllPoints()

pfQuest.route.arrow = CreateFrame("Frame", "pfQuestRouteArrow", UIParent)
pfQuest.route.arrow:SetPoint("CENTER", 0, -100)
pfQuest.route.arrow:SetWidth(48)
pfQuest.route.arrow:SetHeight(36)
pfQuest.route.arrow:SetClampedToScreen(true)
pfQuest.route.arrow:SetMovable(true)
pfQuest.route.arrow:EnableMouse(true)
pfQuest.route.arrow:RegisterForDrag('LeftButton')
pfQuest.route.arrow:SetScript("OnDragStart", function()
  if IsShiftKeyDown() then
    this:StartMoving()
  end
end)

pfQuest.route.arrow:SetScript("OnDragStop", function()
  this:StopMovingOrSizing()
end)


local invalid, lasttarget
local defcolor = "|cffffcc00"

pfQuest.route.arrow:SetScript("OnUpdate", function()
  local xplayer, yplayer, wrongmap_arrow
  local xDelta, yDelta, dir, angle
  local player, cell, column, row, xstart, ystart, xend, yend
  local area, alpha, texalpha, color
  local r, g, b
  -- abort if the frame is not initialized yet
  if not this.parent then return end

  -- Use cached projection from route OnUpdate when available (avoids duplicate GetPlayerMapPosition + UnApply)
  local now = GetTime()
  local useCache = (this.parent._proj_frame and (now - this.parent._proj_frame) < 0.15)

  if useCache then
    xplayer = this.parent._proj_px
    yplayer = this.parent._proj_py
    wrongmap_arrow = (xplayer == 0 and yplayer == 0) and true or nil
  else
    local rx, ry = GetPlayerMapPosition("player")
    wrongmap_arrow = rx == 0 and ry == 0 and true or nil
    xplayer, yplayer = pfQuest.Projections:UnApply(this.parent._proj_mapID or pfMap:GetMapID(), rx * 100, ry * 100)
  end

  local target = this.parent.coords and this.parent.coords[1] and this.parent.coords[1][4] and this.parent.coords[1] or nil

  -- disable arrow on invalid map/route
  if not target or wrongmap_arrow or pfQuest_config["arrow"] == "0" then
    if invalid and invalid < now then
      this:Hide()
      invalid = nil
    elseif not invalid then
      -- grace period of 1.5s before hiding (avoids flicker during zone transitions)
      invalid = now + 1.5
    end
    return
  else
    invalid = nil
  end

  -- arrow positioning stolen from TomTomVanilla.
  -- https://github.com/cralor/TomTomVanilla
  local tx, ty = tonumber(target[1]), tonumber(target[2])
  local AR = pfQuest.Projections.ASPECT_RATIO
  xDelta = (tx - xplayer) * AR
  yDelta = ty - yplayer

  -- Angle calculation (clockwise, North = 0)
  dir   = atan2(xDelta, -(yDelta))
  angle = dir > 0 and (pi * 2) - dir or -dir
  if angle < 0 then angle = angle + pi * 2 end

  player = pfQuestCompat.GetPlayerFacing()
  angle  = angle - player

  local perc = abs(((pi - abs(angle)) / pi))
  r, g, b = pfUI.api.GetColorGradient(floor(perc * 100) / 100)

  cell   = modulo(floor(angle / (pi * 2) * 108 + 0.5), 108)
  if cell < 0 then cell = cell + 108 end
  column = modulo(cell, 9)
  row    = floor(cell / 9)
  xstart = (column * 56) / 512
  ystart = (row * 42) / 512
  xend   = ((column + 1) * 56) / 512
  yend   = ((row + 1) * 42) / 512

  -- guess area based on node count
  area = target[3].priority and target[3].priority or 1
  area = max(1, min(20, area))
  area = (area / 10) + 1

  alpha    = target[4] - area
  alpha    = alpha > 1 and 1 or alpha < 0.5 and 0.5 or alpha
  texalpha = (1 - alpha) * 2
  texalpha = texalpha > 1 and 1 or texalpha < 0 and 0 or texalpha

  r = r + texalpha
  g = g + texalpha
  b = b + texalpha

  -- update arrow texture coords
  this.model:SetTexCoord(xstart, xend, ystart, yend)
  this.model:SetVertexColor(r, g, b)

  -- recalculate values on target change
  if target ~= lasttarget then
    color = defcolor
    if tonumber(target[3]["qlvl"]) then
      color = pfMap:HexDifficultyColor(tonumber(target[3]["qlvl"]))
    end

    if target[3].texture then
      this.texture:SetTexture(target[3].texture)
      if target[3].vertex and (target[3].vertex[1] > 0 or target[3].vertex[2] > 0 or target[3].vertex[3] > 0) then
        this.texture:SetVertexColor(unpack(target[3].vertex))
      else
        this.texture:SetVertexColor(1, 1, 1, 1)
      end
    else
      this.texture:SetTexture(pfQuestConfig.path .. "\\img\\node")
      this.texture:SetVertexColor(pfMap.str2rgb(target[3].title))
    end

    local level = target[3].qlvl and "[" .. target[3].qlvl .. "] " or ""
    this.title:SetText(color .. level .. target[3].title .. "|r")
    local desc = target[3].description or ""
    if not pfUI or not pfUI.uf then
      this.description:SetTextColor(1, .9, .7, 1)
      desc = string.gsub(desc, "ff33ffcc", "ffffffff")
    end
    this.description:SetText(desc .. "|r.")
    lasttarget = target
  end

  -- only refresh distance text on change
  local distance = floor(target[4] * 10) / 10
  if distance ~= this.distance.number then
    this.distance:SetText("|cffaaaaaa" .. pfQuest_Loc["Distance"] .. ": " .. string.format("%.1f", distance))
    this.distance.number = distance
  end

  -- update transparencies
  this.texture:SetAlpha(texalpha)
  this.model:SetAlpha(alpha)
end)

pfQuest.route.arrow.texture = pfQuest.route.arrow:CreateTexture("pfQuestRouteNodeTexture", "OVERLAY")
pfQuest.route.arrow.texture:SetWidth(28)
pfQuest.route.arrow.texture:SetHeight(28)
pfQuest.route.arrow.texture:SetPoint("BOTTOM", 0, 0)

pfQuest.route.arrow.model = pfQuest.route.arrow:CreateTexture("pfQuestRouteArrow", "MEDIUM")
pfQuest.route.arrow.model:SetTexture(pfQuestConfig.path.."\\img\\arrow")
pfQuest.route.arrow.model:SetTexCoord(0,0,0.109375,0.08203125)
pfQuest.route.arrow.model:SetAllPoints()

pfQuest.route.arrow.title = pfQuest.route.arrow:CreateFontString("pfQuestRouteText", "HIGH", "GameFontWhite")
pfQuest.route.arrow.title:SetPoint("TOP", pfQuest.route.arrow.model, "BOTTOM", 0, -10)
pfQuest.route.arrow.title:SetFont(pfUI.font_default, pfUI_config.global.font_size+1, "OUTLINE")
pfQuest.route.arrow.title:SetTextColor(1,.8,0)
pfQuest.route.arrow.title:SetJustifyH("CENTER")

pfQuest.route.arrow.description = pfQuest.route.arrow:CreateFontString("pfQuestRouteText", "HIGH", "GameFontWhite")
pfQuest.route.arrow.description:SetPoint("TOP", pfQuest.route.arrow.title, "BOTTOM", 0, -2)
pfQuest.route.arrow.description:SetFont(pfUI.font_default, pfUI_config.global.font_size, "OUTLINE")
pfQuest.route.arrow.description:SetTextColor(1,1,1)
pfQuest.route.arrow.description:SetJustifyH("CENTER")

pfQuest.route.arrow.distance = pfQuest.route.arrow:CreateFontString("pfQuestRouteDistance", "HIGH", "GameFontWhite")
pfQuest.route.arrow.distance:SetPoint("TOP", pfQuest.route.arrow.description, "BOTTOM", 0, -2)
pfQuest.route.arrow.distance:SetFont(pfUI.font_default, pfUI_config.global.font_size-1, "OUTLINE")
pfQuest.route.arrow.distance:SetTextColor(.8,.8,.8)
pfQuest.route.arrow.distance:SetJustifyH("CENTER")

pfQuest.route.arrow.parent = pfQuest.route
