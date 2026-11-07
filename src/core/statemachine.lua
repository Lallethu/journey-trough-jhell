---@type StateMachine
local StateMachine = {
  name = "",
  states = {},
  current = {},
}
StateMachine.__index = StateMachine ---@diagnostic disable-line

function StateMachine.new(states)
  return setmetatable({ states = states }, StateMachine)
end

function StateMachine:switch(name, ...)
  if self.current and self.current.exit then self.current:exit() end
  self.name, self.current = name, assert(self.states[name], name)
  if self.current.enter then self.current:enter(...) end
end

function StateMachine:update(dt)
  if self.current.update then self.current:update(dt) end
end

function StateMachine:draw()
  if self.current.draw then self.current:draw() end
end

return StateMachine
