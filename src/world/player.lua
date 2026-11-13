local Animator = require("src.core.animator")
local Input = require("src.core.input")
local Screen = require("src.core.screen")
local Util = require("src.core.util")
local Hittable = require("src.core.hittable")

local playerdata = require("src.data.player")
local sheet = Animator.newSheet(require("src.data.player_anim"))

---@class Player : Hittable
---@field vx number
---@field vy number
---@field facingX number
---@field facingY number
---@field attackTimer number
---@field anim Animator
---@field flip boolean
local Player = {}
Player.__index = Player

---@param x number Centre
---@param y number Centre
---@return Player
function Player.new(x, y)
  local instance = {
    -- entity
    x = x,
    y = y,
    kind = "player",
    dead = false,
    -- player
    vx = 0,
    vy = 0,
    facingX = 0,
    facingY = 1,
    attackTimer = 0,
    anim = Animator.new(sheet),
    flip = false,
    -- hittable
    hp = playerdata.MAX_HP,
    hitTimer = 0,
    hitDuration = playerdata.HIT_DURATION,
    takeHit = Hittable.takeHit,
  }

  instance.anim:play("idle")
  return setmetatable(instance, Player)
end

---@param dt number
function Player:update(dt)
  local ax, ay = Input.axis()
  if ax ~= 0 then self.flip = ax < 0 end
  if ax ~= 0 or ay ~= 0 then
    self.facingX, self.facingY = ax, ay
  end

  if self.anim.done then self.anim:play("idle") end
  self.anim:update(dt)

  Hittable.tick(self, dt)
  self.attackTimer = math.max(0, self.attackTimer - dt)

  local rate = (ax ~= 0 or ay ~= 0) and playerdata.ACCELERATION or playerdata.FRICTION
  local weight = math.min(1, rate * dt)
  self.vx = Util.lerp(self.vx, ax * playerdata.MAX_SPEED, weight)
  self.vy = Util.lerp(self.vy, ay * playerdata.MAX_SPEED, weight)

  self.x = Util.clamp(self.x + self.vx * dt, playerdata.HALF, Screen.width - playerdata.HALF)
  self.y = Util.clamp(self.y + self.vy * dt, playerdata.HALF, Screen.height - playerdata.HALF)
end

function Player:draw()
  love.graphics.setColor((Hittable.isBlinkedOff(self) and { 0.55, 0.55, 0.60, 0.82 })
    or playerdata.COLOR)

  self.anim:draw(self.x, self.y, self.flip)

  if self.attackTimer > 0 then
    love.graphics.setColor(1, 1, 1, 0.6)
    love.graphics.circle("line", self.x + self.facingX * playerdata.ATTACK_REACH,
      self.y + self.facingY * playerdata.ATTACK_REACH, playerdata.ATTACK_RADIUS)
  end

  love.graphics.setColor(1, 1, 1, 1)
end

return Player
