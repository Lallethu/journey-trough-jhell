local Input = require("src.core.input")
local Screen = require("src.core.screen")
local Util = require("src.core.util")
local Hittable = require("src.core.hittable")

local playerdata = require("src.data.player")

---@class Player : Hittable
---@field vx number
---@field vy number
local Player = {}
Player.__index = Player

---@param x number Centre
---@param y number Centre
---@return Player
function Player.new(x, y)
  return setmetatable({
    -- entity
    x = x,
    y = y,
    dead = false,
    -- player
    vx = 0,
    vy = 0,
    -- hittable
    hp = 100,
    hitTimer = 0,
    hitDuration = playerdata.HIT_DURATION,
    takeHit = Hittable.takeHit,
  }, Player)
end

---@param dt number
function Player:update(dt)
  local ax, ay = Input.axis()
  Hittable.tick(self, dt)

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

  love.graphics.rectangle(
    "fill",
    self.x - playerdata.HALF,
    self.y - playerdata.HALF,
    playerdata.SIZE,
    playerdata.SIZE
  )

  love.graphics.setColor(1, 1, 1, 1)
end

return Player
