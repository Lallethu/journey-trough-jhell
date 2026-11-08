---@class StateMachine
---@field states StateList
---@field current State
---@field name string The key string as index
local StateMachine = {}
StateMachine.__index = StateMachine

---Creates a new StateMachine instance and feed states to its states list
---@param ctx table<"states"|"world", State[]|World>
---@return StateMachine
function StateMachine.new(ctx)
  local instance = { states = ctx.states }
  for _, state in pairs(instance.states) do
    state.machine = instance
    state.world = ctx.world
  end
  return setmetatable(instance, StateMachine)
end

---Tries to switch to the specified scene if present in the states list
---@param name string
---@param ... unknown
function StateMachine:switch(name, ...)
  if self.current and self.current.exit then self.current:exit() end
  self.name, self.current = name, assert(self.states[name], name)
  if self.current.enter then self.current:enter(...) end
end

---Updates the current state if update is implemented
---@param dt number
function StateMachine:update(dt)
  if self.current.update then self.current:update(dt) end
end

---Draws the current state if draw is implemented
function StateMachine:draw()
  if self.current.draw then self.current:draw() end
end

---Process keypresses action that is matching from input bindings
---@param action Binding
function StateMachine:onAction(action)
  if self.current and self.current.onAction then self.current:onAction(action) end
end

return StateMachine
