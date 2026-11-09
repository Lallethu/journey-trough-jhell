local Profiler = require("src.core.profiler")

---@type State
local DayState = {}

function DayState:enter()
  print("entered day state")
end

function DayState:exit()
  print("exited day state")
end

function DayState:update(dt)
  self.world:update(dt)
end

function DayState:draw()
  self.world:draw()
end

function DayState:onAction(action)
  -- TODO: remove that later
  if action == "debug_switch_state" then self.machine:switch("night") end
  -- TODO: remove that later
  if action == "debug_profiler" then Profiler.toggle() end
  if action == "debug_reset_profiler" then Profiler.reset() end
end

return DayState
