local bindings = require("src.data.bindings")
local unpack = table.unpack or unpack

---@class Input
local Input = {}

---@type table<love.Scancode, Binding>
local actionByScancode = {}

for action, scancodes in pairs(bindings) do
  for _, scancode in ipairs(scancodes) do
    assert(not actionByScancode[scancode],
      "scancode ['" .. scancode .. "'] is bound to two actions")
    actionByScancode[scancode] = action
  end
end

---Checks if a key is held this frame
---@param binding Binding
---@return boolean isActive Whether or not the keyboard input is held down
function Input.isDown(binding)
  return love.keyboard.isScancodeDown(unpack(bindings[binding]) --[[@as love.Scancode]])
end

---Returns the normalized axis from the movement input
---@return number x, number y
function Input.axis()
  local x = (Input.isDown("move_right") and 1 or 0)
      - (Input.isDown("move_left") and 1 or 0)

  local y = (Input.isDown("move_down") and 1 or 0)
      - (Input.isDown("move_up") and 1 or 0)

  local length = math.sqrt(x * x + y * y)

  if length > 0 then
    x = x / length
    y = y / length
  end

  return x, y
end

---Checks if a key has been pressed last frame
---@param _ any
---@param scancode love.Scancode
---@return Binding?
function Input.keypressed(_, scancode)
  return actionByScancode[scancode]
end

return Input
