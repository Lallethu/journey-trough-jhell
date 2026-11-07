---@class Screen
---@field width integer
---@field height integer
local Screen = {
  width = 480,
  height = 270,
}

---@type love.Canvas
local canvas
local scale, offsetX, offsetY = 1, 0, 0

---Sets the filters and the canvas to the screen size
function Screen.init()
  love.graphics.setDefaultFilter("nearest", "nearest")
  canvas = love.graphics.newCanvas(Screen.width, Screen.height)
  Screen.resize(love.graphics.getDimensions())
end

---Callback to hook in love
---@param w integer
---@param h integer
function Screen.resize(w, h)
  scale = math.max(1, math.floor(math.min(w / Screen.width, h / Screen.height)))
  offsetX = math.floor((w - Screen.width * scale) / 2)
  offsetY = math.floor((h - Screen.height * scale) / 2)
end

---Sets the canvas and clear the background
function Screen.begin()
  love.graphics.setCanvas(canvas)
  love.graphics.clear(0, 0, 0, 1)
end

---Empty the canvas buffer to allow draw again, set a background color and
---draw the texture from the canvas to the screen
function Screen.finish()
  love.graphics.setCanvas()
  love.graphics.clear(0.05, 0.05, 0.07, 1)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(canvas, offsetX, offsetY, 0, scale, scale)
end

---Compute physical to virtual position
---@param x number
---@param y number
---@return number x , number y
function Screen.toGameCoordinates(x, y)
  return (x - offsetX) / scale, (y - offsetY) / 2
end

return Screen
