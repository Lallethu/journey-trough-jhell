---@type Events
local Events = require "src.core.events"

---@class Hittable : Entity
---@field hp integer
---@field damage number
---@field hitTimer number
---@field hitDuration number
---@field knockbackX number
---@field knockbackY number
local Hittable = {}

local BLINKS = 3

local KNOCKBACK_SPEED = 220
local KNOCKBACK_DAMPING = 12
local KNOCKBACK_THRESHOLD = 5

---@param dt number
function Hittable.tick(self, dt)
  self.hitTimer = math.max(0, self.hitTimer - dt)

  if self.knockbackX and self.knockbackY then
    self.x = self.x + self.knockbackX * dt
    self.y = self.y + self.knockbackY * dt

    local damping = math.exp(-KNOCKBACK_DAMPING * dt)

    self.knockbackX = self.knockbackX * damping
    self.knockbackY = self.knockbackY * damping

    if math.abs(self.knockbackX) < KNOCKBACK_THRESHOLD
        and math.abs(self.knockbackY) < KNOCKBACK_THRESHOLD then
      self.knockbackX = 0
      self.knockbackY = 0
    end
  end
end

---@param damage number
---@param sourceX number
---@returns boolean accepted
function Hittable.takeHit(self, damage, sourceX, sourceY)
  if self.dead or self.hitTimer > 0 then return false end

  Events.emit("entity_hurt", self, damage, sourceX, sourceX)

  self.hp = math.max(0, self.hp - damage)
  self.dead = self.hp == 0
  self.hitTimer = self.hitDuration

  local dx = self.x - sourceX
  local dy = self.y - sourceY

  local length = math.sqrt(dx * dx + dy * dy)

  if length > 0 then
    dx = dx / length
    dy = dy / length

    self.knockbackX = dx * KNOCKBACK_SPEED
    self.knockbackY = dy * KNOCKBACK_SPEED
  end

  return true
end

---@return boolean
function Hittable.isBlinkedOff(self)
  if self.hitTimer <= 0 then return false end

  local interval = self.hitDuration / (BLINKS * 2)

  return math.floor(self.hitTimer / interval) % 2 == 1
end

return Hittable
