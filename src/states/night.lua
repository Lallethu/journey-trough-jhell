---@type Screen
local Screen = require("src.core.screen")
---@type Jelly
local Jelly = require("src.world.jelly")
---@type Events
local Events = require("src.core.events")
---@type PlayerCommands
local PlayerCommands = require("src.commands.player")
local Profiler = require("src.core.profiler")

local keymap = { attack = PlayerCommands.attack }

---@type State
local NightState = {}

function NightState:enter()
  print("entered night state")
  -- TODO: remove that when a proper spawner system is made
  for i = 1, 5 do
    self.world:add(
      Jelly.new(
        self.world,
        math.random(0, Screen.width),
        math.random(0, Screen.height),
        math.random(1, 3)))
  end
  Events.on("jelly_died",
    function(jelly)

    end,
    self
  )
end

function NightState:exit()
  Events.off_owner(self)
  print("exited night state")
end

function NightState:update(dt)
  self.world:update(dt)
end

function NightState:draw()
  self.world:draw()
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
