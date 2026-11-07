local bindings = require("src.data.bindings")
local unpack = table.unpack or unpack

---@type Input
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

function Input.isDown(binding)
  return love.keyboard.isScancodeDown(unpack(bindings[binding]) --[[@as love.Scancode]])
end

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

---comment
---@param _ any
---@param scancode love.Scancode
---@return Binding?
function Input.keypressed(_, scancode)
  return actionByScancode[scancode]
end

return Input
