---@type Screen
local Screen      = require("src.core.screen")
---@type Jelly
local Jelly       = require("src.world.jelly")
---@type Events
local Events      = require("src.core.events")
---@type Commands
local Commands    = require("src.commands.player")
---@type WaveSpawner
local WaveSpawner = require("src.systems.wave_spawner")
---@type HUD
local HUD         = require("src.ui.hud")
local Profiler    = require("src.core.profiler")

local keymap      = { attack = Commands.attack }

---@type State
local NightState  = {}

function NightState:enter()
  WaveSpawner.start(self.world, self.world.night)
  Events.on("wave_cleared", function()
    self.world.night = self.world.night + 1
    self.machine:switch("day")
  end, self)
end

function NightState:exit()
  WaveSpawner.stop()
  Events.off_owner(self)
end

function NightState:update(dt)
  self.world:update(dt)
  WaveSpawner.update(dt)
end

function NightState:draw()
  self.world:draw()
  HUD.drawNight(self.world)
end

function NightState:onAction(action)
  -- TODO: remove that later
  if action == "debug_switch_state" then self.machine:switch("day") end
  -- TODO: remove that later
  if action == "debug_profiler" then Profiler.toggle() end
  if action == "debug_reset_profiler" then Profiler.reset() end
  local command = keymap[action]
  if command then command(self.world) end
end

return NightState
