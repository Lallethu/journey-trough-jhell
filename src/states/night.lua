---@type State
local NightState = {}

function NightState:enter(...)
  print("entered night state")
end

function NightState:exit()
  print("exited night state")
end

function NightState:update(dt) end

function NightState:draw() end

return NightState
