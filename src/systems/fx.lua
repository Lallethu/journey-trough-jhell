local Events = require("src.core.events")
local Util = require("src.core.util")

local LIFE = 0.9 -- seconds
local RISE = 18  -- px travelled over the lifetime
local GREEN = { 0.4, 1, 0.5, 1 }
local WHITE = { 1, 1, 1, 1 }

local font
local floats = {}
local scratch = { 1, 1, 1, 1 }

---@class FX
local FX = {}

---Create a floating effect
---@param text string
---@param x number
---@param y number
---@param color number[]
function FX.float(text, x, y, color)
  floats[#floats + 1] = { text = text, x = x, y = y, color = color, age = 0 }
end

function FX.init()
  font = love.graphics.newFont(10, "mono")
  floats = {}
  Events.off_owner(FX)
  Events.on("player_healed", function(amount, x, y)
    FX.float("+" .. amount, x, y, GREEN)
  end, FX)
end

---@param dt number
function FX.update(dt)
  for i = #floats, 1, -1 do
    floats[i].age = floats[i].age + dt
    if floats[i].age >= LIFE then table.remove(floats, i) end
  end
end

function FX.draw()
  love.graphics.push("all")
  love.graphics.setFont(font)
  for i = 1, #floats do
    local f = floats[i]
    local t = f.age / LIFE
    local c = Util.mixColor(f.color, WHITE, t, scratch)
    local x = math.floor(f.x - font:getWidth(f.text) / 2)
    local y = math.floor(f.y - 12 - RISE * t)

    love.graphics.setColor(0, 0, 0, (1 - t) * 0.8)
    love.graphics.print(f.text, x + 1, y + 1)
    love.graphics.setColor(c[1], c[2], c[3], 1 - t)
    love.graphics.print(f.text, x, y)
  end

  love.graphics.pop()
end

return FX
