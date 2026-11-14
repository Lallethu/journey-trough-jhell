---@type Collision
local Collision    = require("src.systems.collision")
---@type ClickTargets
local ClickTargets = require("src.tasks.click_targets")
---@type Commands
local Commands     = require("src.commands.player")
---@type Events
local Events       = require("src.core.events")
---@type FX
local FX           = require("src.systems.fx")
---@type HUD
local HUD          = require("src.ui.hud")
---@type Screen
local Screen       = require("src.core.screen")
local Util         = require("src.core.util")
local Profiler     = require("src.core.profiler")

local daytimings   = require("src.data.day_timings")
local palettes     = require("src.data.palettes")
local tasks        = require("src.data.tasks")

local sky          = { 1, 1, 1, 1 }
local background   = love.graphics.newImage("assets/gfx/journey-trough-jhell-day-map.png")
background:setFilter("nearest", "nearest")

---@type State
local DayState = {}

function DayState:enter()
  self.activeTask = nil
  self.timeLeft = daytimings.DAY_LENGTH
  self.world:eachOfKind("interactable",
    ---@param e Interactable
    function(e)
      e:refresh()
    end)
  Events.emit("phase_changed", "day")
end

function DayState:exit() self.activeTask = nil end

---@param target Interactable
function DayState:startTask(target)
  local config = tasks[target.taskId].minigame
  self.activeTask = ClickTargets.new(config, function(success)
    self.activeTask = nil
    if success and target:tryUse() then
      Events.emit("task_done", target.taskId)
    else
      Events.emit("task_failed", target.taskId)
    end
  end)
end

function DayState:update(dt)
  if self.activeTask then
    self.activeTask:update(dt)
  else
    self.world:update(dt)
    Collision.resolve(dt, self.world)
    FX.update(dt)
  end
  self.timeLeft = self.timeLeft - dt
  if self.timeLeft <= 0 then self.machine:switch("dusk") end
end

function DayState:draw()
  local k = Util.clamp(1 - self.timeLeft / daytimings.WARNING_TIME, 0, 1)
  Screen.fill(Util.mixColor(palettes.DAY, palettes.DUSK, k, sky))
  self.world:draw(background)
  if self.activeTask then self.activeTask:draw() end
  FX.draw()
  HUD.drawDay(self.world, self.timeLeft, self.activeTask ~= nil)
end

function DayState:onAction(action)
  if self.activeTask then
    if action == "cancel" then self.activeTask = nil end
    return
  end
  if action == "interact" then
    local target = Commands.interact(self.world) --[[@as Interactable]]
    if target then self:startTask(target) end
  elseif action == "end_day" then
    self.machine:switch("dusk")
  end

  -- TODO: remove that later
  if action == "debug_profiler" then Profiler.toggle() end
  if action == "debug_reset_profiler" then Profiler.reset() end

  -- the if block shadow this implementation
  -- local command = keymap[action]
  -- if command then command(self.world) end
end

---@param x number
---@param y number
---@param button integer
function DayState:mousepressed(x, y, button)
  if self.activeTask and button == 1 then self.activeTask:mousepressed(x, y) end
end

return DayState
