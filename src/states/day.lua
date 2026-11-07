---@type State
local DayState = {}

function DayState:enter(...)
  print("entered day state")
end

function DayState:exit()
  print("exited day state")
end

function DayState:update(dt) end

function DayState:draw() end

return DayState
