---@type State
local NightState = {}

function NightState:enter()
  print("entered night state")
end

function NightState:exit()
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
end

return NightState
