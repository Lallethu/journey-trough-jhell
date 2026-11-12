---@type Events
local Events      = require("src.core.events")
---@type Screen
local Screen      = require("src.core.screen")

local wavesdata   = require("src.data.waves")

local INPUT_DELAY = 0.8
local DIM         = { 0, 0, 0, 0.8 }

local titleFont, bodyFont

---@type State
local EndingState = {}

---@param won boolean?
function EndingState:enter(won)
  titleFont     = titleFont or love.graphics.newFont(20, "mono")
  bodyFont      = bodyFont or love.graphics.newFont(10, "mono")

  self.won      = won
  self.timeLeft = 0
end

function EndingState:update(dt)
  self.timeLeft = self.timeLeft + dt
end

function EndingState:draw()
  self.world:draw()
  Screen.fill(DIM)

  love.graphics.push("all")
  local centerY = Screen.height / 2

  love.graphics.setFont(titleFont)
  love.graphics.printf(self.won and "Dawn breaks" or "Consumed to the last drop...", 0, centerY - 40,
    Screen.width, "center")
  love.graphics.setFont(bodyFont)
  love.graphics.printf(string.format("Night %d of %d", self.world.night, #wavesdata.NIGHTS), 0,
    centerY - 6, Screen.width, "center")

  if self.timeLeft > INPUT_DELAY then
    love.graphics.printf("Press Enter to play again", 0, centerY + 24, Screen.width, "center")
  end

  love.graphics.pop()
end

function EndingState:onAction(action)
  if action == "end_day" and self.timeLeft > INPUT_DELAY then
    Events.emit("restart_requested")
  end
end

return EndingState
