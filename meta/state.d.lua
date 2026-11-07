---@meta state

---@class State
---@field machine StateMachine? reference to the statemachine
local State = {}

---Trigger when StateMachine:switch is called
---@param ... unknown
function State:enter(...) end

---Trigger when StateMachine:switch is called
function State:exit() end

---Updates the state
---@param dt number
function State:update(dt) end

---Draws the state
function State:draw() end

---comment
---@param action Binding
function State:onAction(action) end
