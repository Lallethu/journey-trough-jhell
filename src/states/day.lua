---@type State
local DayState = {}

function DayState:enter()
  print("entered day state")
end

function DayState:exit()
  print("exited day state")
end

function DayState:update(dt) end

function DayState:draw()
  -- TODO: remove that later
  love.graphics.setColor(0.5, 0, 0, 1)
  love.graphics.rectangle("fill", 0, 0, 32, 32)

  love.graphics.setColor(0, 0.5, 0, 1)
  love.graphics.rectangle("fill", 448, 0, 32, 32)

  love.graphics.setColor(0, 0, 0.5, 1)
  love.graphics.rectangle("fill", 0, 238, 32, 32)

  love.graphics.setColor(0.5, 0.5, 0.5, 1)
  love.graphics.rectangle("fill", 448, 238, 32, 32)
end

function DayState:onAction(action)
  -- TODO: remove that later
  if action == "debug_switch_state" then self.machine:switch("night") end
end

return DayState
