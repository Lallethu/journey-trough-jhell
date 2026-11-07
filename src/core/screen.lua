---@type Screen
local Screen = {
  width = 480,
  height = 270,
}

---@type love.Canvas
local canvas
local scale, offsetX, offsetY = 1, 0, 0

function Screen.init()
  love.graphics.setDefaultFilter("nearest", "nearest")
  canvas = love.graphics.newCanvas(Screen.width, Screen.height)
  Screen.resize(love.graphics.getDimensions())
end

function Screen.resize(w, h)
  scale = math.max(1, math.floor(math.min(w / Screen.width, h / Screen.height)))
  offsetX = math.floor((w - Screen.width * scale) / 2)
  offsetY = math.floor((h - Screen.height * scale) / 2)
end

function Screen.begin()
  love.graphics.setCanvas(canvas)
  love.graphics.clear(0, 0, 0, 1)
end

function Screen.finish()
  love.graphics.setCanvas()
  love.graphics.clear(0.05, 0.05, 0.07, 1)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(canvas, offsetX, offsetY, 0, scale, scale)
end

function Screen.toGameCoordinates(x, y)
  return (x - offsetX) / scale, (y - offsetY) / 2
end

return Screen
