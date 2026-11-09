---@class Hittable : Entity
---@field hp integer
---@field damage number
---@field hitTimer number
---@field hitDuration number
local Hittable = {}

local BLINKS = 3

---@param dt number
function Hittable.tick(self, dt)
  self.hitTimer = math.max(0, self.hitTimer - dt)
end

---@param damage number
---@return boolean accepted
function Hittable.takeHit(self, damage)
  if self.dead or self.hitTimer > 0 then return false end
  self.hp = math.max(0, self.hp - damage)
  self.dead = self.hp == 0
  self.hitTimer = self.hitDuration
  return true
end

---True during the "dim" phase of the blink
---@return boolean
function Hittable.isBlinkedOff(self)
  if self.hitTimer <= 0 then return false end
  local interval = self.hitDuration / (BLINKS * 2)
  return math.floor(self.hitTimer / interval) % 2 == 1
end

return Hittable
