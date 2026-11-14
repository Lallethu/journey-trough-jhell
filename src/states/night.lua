---@type Collision
local Collision   = require("src.systems.collision")
---@type Commands
local Commands    = require("src.commands.player")
---@type Events
local Events      = require("src.core.events")
---@type FX
local FX          = require("src.systems.fx")
---@type HUD
local HUD         = require("src.ui.hud")
---@type Screen
local Screen      = require("src.core.screen")
---@type WaveSpawner
local WaveSpawner = require("src.systems.wave_spawner")
local Profiler    = require("src.core.profiler")

local palettes    = require("src.data.palettes")
local wavesdata   = require("src.data.waves")
local background  = love.graphics.newImage("assets/gfx/journey-trough-jhell-night-map.png")
background:setFilter("nearest", "nearest")

local keymap     = {
  attack = Commands.attack,
  heal = Commands.heal,
  place_wall = Commands.placeWall
}

---@type State
local NightState = {}

function NightState:enter()
  WaveSpawner.start(self.world, self.world.night)
  Events.on("wave_cleared", function()
    if self.world.night >= #wavesdata.NIGHTS then
      self.machine:switch("ending", true)
    else
      self.world.night = self.world.night + 1
      self.machine:switch("day")
    end
  end, self)
end

function NightState:exit()
  WaveSpawner.stop()
  Events.off_owner(self)
end

function NightState:update(dt)
  self.world:update(dt)
  Commands.replayBuffered(self.world)
  Collision.resolve(dt, self.world)
  FX.update(dt)

  if self.world.player.dead then
    self.machine:switch("ending", false)
    return
  end

  WaveSpawner.update(dt)
end

function NightState:draw()
  Screen.fill(palettes.NIGHT)
  self.world:draw(background)
  FX.draw()
  HUD.drawNight(self.world)
end

function NightState:onAction(action)
  -- TODO: remove that later
  if action == "debug_profiler" then Profiler.toggle() end
  if action == "debug_reset_profiler" then Profiler.reset() end
  local command = keymap[action]
  if command then command(self.world) end
end

return NightState
