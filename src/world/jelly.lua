local playerdata = require("src.data.player")
local Hittable   = require("src.core.hittable")

local jellydata  = require("src.data.jelly")

---@class Jelly : Hittable
---@field world World
---@field size 1|2|3
---@field radius number
---@field speed number
---@field damage number
local Jelly      = {}
Jelly.__index    = Jelly

---@param world World
---@param x number Centre
---@param y number Centre
---@param size 1|2|3
---@return Jelly
function Jelly.new(world, x, y, size)
  return setmetatable({
    -- entity
    x = x,
    y = y,
    dead = false,
    -- jelly
    world = world,
    size = size,
    radius = size * jellydata.RADIUS_PER_SIZE,
    speed = jellydata.BASE_SPEED - size * jellydata.SPEED_LOSS_PER_SIZE,
    damage = jellydata.BASE_DAMAGE * jellydata.DAMAGE_MULTIPLIER[size],
    -- hittable
    hp = size * 2,
    hitTimer = 0,
    hitDuration = jellydata.HIT_DURATION,
    takeHit = Hittable.takeHit,
  }, Jelly)
end

---@param dt number
function Jelly:update(dt)
  local target = self.world.player
  if not target or target.dead then return end
  Hittable.tick(self, dt)

  local dx, dy = target.x - self.x, target.y - self.y
  local dist = math.sqrt(dx * dx + dy * dy)

  if dx * dx + dy * dy < (self.radius + playerdata.HALF) * (self.radius + playerdata.HALF) then
    self.world.player:takeHit(self.damage)
  end

  if dist < jellydata.MIN_DISTANCE then return end

  self.x = self.x + (dx / dist) * self.speed * dt
  self.y = self.y + (dy / dist) * self.speed * dt
end

function Jelly:draw()
  love.graphics.setColor((Hittable.isBlinkedOff(self) and { 0.55, 0.55, 0.60, 0.82 })
    or jellydata.COLOR)

  love.graphics.circle("fill", self.x, self.y, self.radius)
  love.graphics.setColor(1, 1, 1, 1)
end

return Jelly
