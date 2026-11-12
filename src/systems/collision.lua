local Util = require("src.core.util")

local jellydata = require("src.data.jelly")
local playerdata = require("src.data.player")

local jellies, walls = {}, {}

---@class Collision
local Collision = {}

---Pushes a circle (circle are centered by default) out of a grid alligned rect and return depth
---@param circle { x: number, y: number}
---@param radius number
---@param structure Structure
local function pushOut(circle, radius, structure)
  local newX = Util.clamp(circle.x, structure.x - structure.hw, structure.x + structure.hw)
  local newY = Util.clamp(circle.y, structure.y - structure.hh, structure.y + structure.hh)
  local dx, dy = circle.x - newX, circle.y - newY
  local d2 = dx * dx + dy * dy

  if d2 >= radius * radius then return 0 end

  if d2 > 0 then
    local d = math.sqrt(d2)
    local depth = radius - d

    circle.x = circle.x + dx / d * depth
    circle.y = circle.y + dy / d * depth
    return depth
  end

  local left, right = circle.x - (structure.x - structure.hw),
      (structure.x + structure.hw) - circle.x
  local top, bottom = circle.y - (structure.y - structure.hh),
      (structure.y + structure.hh) - circle.y
  local min = math.min(left, right, top, bottom)

  if min == left then
    circle.x = structure.x - structure.hw - radius
  elseif min == right then
    circle.x = structure.x + structure.hw + radius
  elseif min == top then
    circle.y = structure.y - structure.hh - radius
  else
    circle.y = structure.y + structure.hh + radius
  end
  return min + radius
end

---@param world World
---@return integer jellyCount
---@return integer wallCount
local function partition(world)
  for i = #jellies, 1, -1 do jellies[i] = nil end
  for i = #walls, 1, -1 do walls[i] = nil end

  local numberJellies, numberWalls = 0, 0
  for i = 1, #world.entities do
    local entity = world.entities[i]
    if not entity.dead then
      if entity.kind == "jelly" then
        numberJellies = numberJellies + 1; jellies[numberJellies] = entity
      elseif entity.kind == "structure" then
        numberWalls = numberWalls + 1; walls[numberWalls] = entity
      end
    end
  end
  return numberJellies, numberWalls
end
---To keep sync it has to be called after world:update(dt) in night state
---@param dt number
---@param world World
function Collision.resolve(dt, world)
  local numberJellies, numberStructures = partition(world)
  if numberStructures == 0 then return end

  local player = world.player --[[@as Player]]
  for i_wall = 1, numberStructures do
    local wall = walls[i_wall] --[[@as Structure]]
    if not wall.dead then
      for i_jelly = 1, numberJellies do
        local jelly = jellies[i_jelly] --[[@as Jelly]]
        if pushOut(jelly, jelly.radius, wall) > 0 then
          wall:chew(jelly.damage * jellydata.CHEW_FACTOR * dt)
        end
      end

      if player and not player.dead then
        pushOut(player, playerdata.HALF, wall)
      end
    end
  end
end

return Collision
