local Screen = require("src.core.screen")
local Input = require("src.core.input")
local StateMachine = require("src.core.statemachine")
local Player = require("src.world.player")
local World = require("src.world.world")

---@class Game
local Game = {}

---@type StateMachine
local stateMachine
---@type World
local world

function Game.load()
  Screen.init()
  world = World.new()
  world.player = world:add(Player.new(50, 50))

  local dayState = require("src.states.day")
  local nightState = require("src.states.night")
  dayState.world, nightState.world = world, world

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
