---@meta game

---Metafile documenting types and APIs

---@alias Binding
---| "move_left"
---| "move_right"
---| "move_up"
---| "move_down"
---| "interact"
---| "attack"

---@alias Bindings table<Binding, love.Scancode[]>

---@alias StateList table<string, State>
