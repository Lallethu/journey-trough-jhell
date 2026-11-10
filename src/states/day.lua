---@type Commands
local Commands = require("src.commands.player")
---@type HUD
local HUD      = require("src.ui.hud")
local Profiler = require("src.core.profiler")

local keymap   = { interact = Commands.interact }

---@type State
local DayState = {}

function DayState:enter()
  self.world:eachOfKind("interactable",
    ---@param e Interactable
    function(e)
      e:refresh()
    end)
end

function DayState:exit() end

function DayState:update(dt)
  self.world:update(dt)
end

function DayState:draw()
  self.world:draw()
  HUD.drawDay(self.world)
end

function DayState:onAction(action)
  -- TODO: remove that later
  if action == "debug_switch_state" then self.machine:switch("night") end
  -- TODO: remove that later
  if action == "debug_profiler" then Profiler.toggle() end
  if action == "debug_reset_profiler" then Profiler.reset() end

  local command = keymap[action]
  if command then command(self.world) end
end

return DayState
