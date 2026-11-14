local Animator   = require("src.core.animator")
local Hittable   = require("src.core.hittable")
local Events     = require("src.core.events")

local sheet      = Animator.newSheet(require("src.data.jelly_anim"))
local jellydata  = require("src.data.jelly")
local playerdata = require("src.data.player")

---@class Jelly : Hittable
---@field world World
---@field size 1|2|3
---@field radius number
---@field speed number
---@field damage number
---@field anim Animator
---@field flip boolean
local Jelly      = {}
Jelly.__index    = Jelly

---@param world World
---@param x number Centre
---@param y number Centre
---@param size 1|2|3
---@return Jelly
function Jelly.new(world, x, y, size)
  local instance = {
    -- entity
    x = x,
    y = y,
    kind = "jelly",
    dead = false,
    -- jelly
    world = world,
    size = size,
    radius = size * jellydata.RADIUS_PER_SIZE,
    speed = jellydata.BASE_SPEED - size * jellydata.SPEED_LOSS_PER_SIZE,
    damage = jellydata.BASE_DAMAGE * jellydata.DAMAGE_MULTIPLIER[size],
    anim = Animator.new(sheet),
    flip = false,
    -- hittable
    hp = size * 2,
    hitTimer = 0,
    hitDuration = jellydata.HIT_DURATION,
  }
  instance.anim:play("chasing")
  return setmetatable(instance, Jelly)
end

function Jelly:takeHit(damage, sourceX, sourceY)
  local accepted = Hittable.takeHit(self, damage, sourceX, sourceY)
  if accepted and self.dead then
    Events.emit("jelly_died", self)
  end

  self.anim:play("hurt", false)
  return accepted
end

function Jelly:update(dt)
  Hittable.tick(self, dt)
  if self.anim.done then self.anim:play("chasing") end
  self.anim:update(dt) -- always runs, even after the player dies

  local target = self.world.player
  if not target or target.dead then return end

  local dx, dy = target.x - self.x, target.y - self.y
  local d2 = dx * dx + dy * dy
  local dist = math.sqrt(d2)

  if dx > 1 then self.flip = false elseif dx < -1 then self.flip = true end

  local reach = self.radius + playerdata.HURT_RADIUS
  if d2 < reach * reach then
    if target:takeHit(self.damage, self.x, self.y) then
      self.anim:play("swing", false)
    end
  end

  if dist < jellydata.MIN_DISTANCE then return end
  self.x = self.x + (dx / dist) * self.speed * dt
  self.y = self.y + (dy / dist) * self.speed * dt
end

function Jelly:draw()
  love.graphics.setColor((Hittable.isBlinkedOff(self) and { 0.55, 0.55, 0.60, 0.82 })
    or jellydata.COLOR)
  self.anim:draw(self.x, self.y, self.flip, self.size, self.size)
end

return Jelly
