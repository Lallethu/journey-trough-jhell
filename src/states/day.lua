---@type Screen
local Screen     = require("src.core.screen")
local Util       = require("src.core.util")
---@type Commands
local Commands   = require("src.commands.player")
---@type Events
local Events     = require("src.core.events")
---@type HUD
local HUD        = require("src.ui.hud")
local Profiler   = require("src.core.profiler")

local daytimings = require("src.data.day_timings")
local palettes   = require("src.data.palettes")

local keymap     = { interact = Commands.interact }
local sky        = { 1, 1, 1, 1 }

---@type State
local DayState   = {}

function DayState:enter()
  self.timeLeft = daytimings.DAY_LENGTH
  self.world:eachOfKind("interactable",
    ---@param e Interactable
    function(e)
      e:refresh()
    end)
  Events.emit("phase_changed", "day")
end

function DayState:exit() end

function DayState:update(dt)
  self.world:update(dt)
  self.timeLeft = self.timeLeft - dt
  if self.timeLeft <= 0 then self.machine:switch("dusk") end
end

function DayState:draw()
  local k = Util.clamp(1 - self.timeLeft / daytimings.WARNING_TIME, 0, 1)
  Screen.fill(Util.mixColor(palettes.DAY, palettes.DUSK, k, sky))
  self.world:draw()
  HUD.drawDay(self.world, self.timeLeft)
end

function DayState:onAction(action)
  if action == "end_day" then self.machine:switch("dusk") end
  -- TODO: remove that later
  if action == "debug_profiler" then Profiler.toggle() end
  if action == "debug_reset_profiler" then Profiler.reset() end

  local command = keymap[action]
  if command then command(self.world) end
end

return DayState
