---@type Events
local Events     = require("src.core.events")
local Util       = require("src.core.util")
---@type Screen
local Screen     = require("src.core.screen")

local daytimings = require("src.data.day_timings")
local palettes   = require("src.data.palettes")
local background = love.graphics.newImage("assets/gfx/journey-trough-jhell-dusk-map.png")
background:setFilter("nearest", "nearest")

---@type State
local DuskState = {}

function DuskState:enter()
  -- the usage of the term timeLeft
  -- in this context is really misleading I know...
  -- but I can't be bother to create another field just for that
  self.timeLeft = 0
  Events.emit("phase_changed", "dusk")
end

function DuskState:update(dt)
  self.timeLeft = self.timeLeft + dt
  if self.timeLeft >= daytimings.DUSK_LENGTH then self.machine:switch("night") end
end

function DuskState:draw()
  local percentage = Util.clamp(self.timeLeft / daytimings.DUSK_LENGTH, 0, 1)
  local scaleX = math.max(0.02, math.abs(math.cos(math.pi * percentage)))

  love.graphics.push()
  love.graphics.translate(Screen.width / 2, 0)
  love.graphics.scale(scaleX, 1)
  love.graphics.translate(-Screen.width / 2, 0)

  Screen.fill(percentage < 0.5 and palettes.DUSK or palettes.NIGHT)

  self.world:draw(background)
  love.graphics.pop()
end

return DuskState
