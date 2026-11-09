local Screen    = require("src.core.screen")
local Events    = require("src.core.events")
local Jelly     = require("src.world.jelly")

local wavesdata = require("src.data.waves")

---@type World
local world
local night     = 1
local queue     = {}
local timer     = 0
local interval  = 1
local active    = false

---Flatten the groups into a shuffled list of sizes
---
--- see [Fisher-Yates shuffle](https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle)
local function buildQueue(config)
  local list = {}

  for _, group in ipairs(config.groups) do
    for _ = 1, group.count do list[#list + 1] = group.size end
  end

  for i = #list, 2, -1 do
    local j = love.math.random(i)
    list[i], list[j] = list[j], list[i]
  end
  return list
end

---A random point just outside one of the four canvas edges
---@return number x, number y
local function edgePosition()
  local margin = wavesdata.EDGE_MARGIN
  local side = love.math.random(4)

  if side == 1 then return love.math.random(0, Screen.width), -margin end
  if side == 2 then return Screen.width + margin, love.math.random(0, Screen.height) end
  if side == 3 then return love.math.random(0, Screen.width), Screen.height + margin end

  return -margin, love.math.random(0, Screen.height)
end

local function spawnOne()
  local x, y = edgePosition()
  world:add(Jelly.new(world, x, y, table.remove(queue)))
end

---@class WaveSpawner
local WaveSpawner = {}

function WaveSpawner.start(p_world, currentNightCounter)
  world, night = p_world, currentNightCounter
  local config = wavesdata.NIGHTS[math.min(night, #wavesdata.NIGHTS)]
  queue = buildQueue(config)
  interval = config.interval
  timer = 0
  active = true
end

function WaveSpawner.stop()
  active = false
  queue = {}
end

---Call after the world:update to ensure entities list is sync
---@param dt number
function WaveSpawner.update(dt)
  if not active then return end

  timer = timer + dt
  while timer >= interval and #queue > 0 do
    timer = timer - interval
    spawnOne()
  end

  if #queue == 0 and world:count("jelly") == 0 then
    active = false
    Events.emit("wave_cleared")
  end
end

return WaveSpawner
