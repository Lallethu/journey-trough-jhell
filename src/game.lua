local Screen = require("src.core.screen")
local Input = require("src.core.input")
local StateMachine = require("src.core.statemachine")
local Player = require("src.world.player")
local World = require("src.world.world")
local SplittingSystem = require("src.systems.splitting")
local Profiler = require("src.core.profiler")

---@class Game
local Game = {}

---@type StateMachine
local stateMachine
---@type World
local world

function Game.load()
  Screen.init()

  world = World.new()
  world.player = world:add(Player.new(50, 50)) --[[@as Hittable]]
  SplittingSystem.init { world = world }

  stateMachine = StateMachine.new {
    states = {
      day   = require("src.states.day"),
      night = require("src.states.night")
    },
    world = world
  }

  stateMachine:switch("day")
end

function Game.update(dt)
  Profiler.beginFrame(dt)

  dt = math.min(dt, 1 / 20) -- cheeky way of capping dt compounding to insane values and break movement/timer/ect...
  Profiler.beginSection("Game Update")
  stateMachine:update(dt)
  Profiler.endSection("Game Update")
end

function Game.draw()
  Profiler.beginSection("Game Draw")
  Screen.begin()
  stateMachine:draw()
  Screen.finish()
  Profiler.endSection("Game Draw")

  Profiler.draw()
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
