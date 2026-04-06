pfQuest = pfQuest or CreateFrame("Frame")

-- Global Coordinate Projection Layer (GCPL)
-- Optimized for Turtle WoW 1.17
pfQuest.Projections = {
  ASPECT_RATIO = 1.58, -- Calibrated GPS Aspect Ratio
  
  MAP_CONFIG = {
    [1519] = { -- Stormwind City (Turtle WoW Expanded)
      scaleX = 0.54,
      scaleY = 0.81,
      offsetX = 38.3,
      offsetY = 23.5
    },
  }
}

function pfQuest.Projections:Apply(mapID, x, y)
  if not x or not y then return x, y end
  x, y = tonumber(x), tonumber(y)
  if not x or not y then return x, y end
  
  -- Apply specific map corrections (Legacy -> Visual)
  local config = self.MAP_CONFIG[tonumber(mapID)]
  if config then
    x = (x * config.scaleX) + config.offsetX
    y = (y * config.scaleY) + config.offsetY
  end
  
  -- Global coordinate clamping
  if x < 0 then x = 0 elseif x > 100 then x = 100 end
  if y < 0 then y = 0 elseif y > 100 then y = 100 end
  
  return x, y
end

function pfQuest.Projections:UnApply(mapID, x, y)
  if not x or not y then return x, y end
  x, y = tonumber(x), tonumber(y)
  if not x or not y then return x, y end
  
  -- Reverse specific map corrections (Visual -> Legacy)
  local config = self.MAP_CONFIG[tonumber(mapID)]
  if config then
    x = (x - config.offsetX) / config.scaleX
    y = (y - config.offsetY) / config.scaleY
  end
  
  return x, y
end

function pfQuest.Projections:GetGPSVector(tx, ty, px, py, mapID)
  -- Transform Reality: Move player coordinates from Turtle WoW's visual space
  -- back to the original Vanilla coordinate space (Legacy Space).
  px, py = self:UnApply(mapID, px, py)
  
  -- Calculate delta in Legacy Space (0-100 legacy square)
  -- tx and ty are already in legacy space (from DB).
  tx, ty, px, py = tonumber(tx), tonumber(ty), tonumber(px), tonumber(py)
  
  local dx = (tx - px) * self.ASPECT_RATIO
  local dy = (ty - py)
  
  return dx, dy
end
