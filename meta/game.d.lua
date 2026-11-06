---@meta game

---Metafile documenting types and APIs

---@alias Binding
---| "move_left"
---| "move_right"
---| "move_up"
---| "move_down"
---| "interact"
---| "attack"

---@class Input
local Input = {}

---comment
---@param binding Binding
---@return boolean isActive Whether or not the keyboard input is held down
function Input.isDown(binding) end

---comment
---@return integer x, integer y
function Input.axis() end

---comment
function Input.keypressed(key, scancode) end
