local Screen = require("src.core.screen")
local Input = require("src.core.input")
local StateMachine = require("src.core.statemachine")

---@class Game
local Game = {}

---@type StateMachine
local stateMachine

function Game.load()
  Screen.init()

  local dayState = require("src.states.day")
  local nightState = require("src.states.night")

  stateMachine = StateMachine.new { day = dayState, night = nightState }
  stateMachine:switch("day")
end

function Game.update(dt)
  stateMachine:update(dt)
end

function Game.draw()
  Screen.begin()
  stateMachine:draw()
  Screen.finish()
end

---@param k love.KeyConstant
---@param sc love.Scancode
function Game.keypressed(k, sc)
  local action = Input.keypressed(k, sc)
  if action then stateMachine:onAction(action) end
end

function Game.resize(w, h)
  Screen.resize(w, h)
end

return Game
