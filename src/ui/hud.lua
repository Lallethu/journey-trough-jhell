local Util                        = require("src.core.util")
local Screen                      = require("src.core.screen")

local bindings                    = require("src.data.bindings")
local tasksdata                   = require("src.data.tasks")
local wavesdata                   = require("src.data.waves")
local playerdata                  = require("src.data.player")
local daytimings                  = require("src.data.day_timings")

local MARGIN                      = 6
local SIZE_NAMES                  = { "small", "medium", "big" }

local WHITE                       = { 1, 1, 1, 1 }
local GREY                        = { 0.6, 0.6, 0.6, 1 }
local RED                         = { 0.9, 0.3, 0.3, 1 }
local YELLOW                      = { 0.95, 0.85, 0.3, 1 }
local GREEN                       = { 0.4, 0.9, 0.4, 1 }

---@type love.Font
local font
local scratch                     = { 1, 1, 1, 1 }
local done, total                 = 0, 0
local forecastNight, forecastText = 0, ""

---@class HUD
local HUD                         = {}

local function text(str, x, y, color)
  love.graphics.setColor(0, 0, 0, 0.8)
  love.graphics.print(str, x + 1, y + 1)
  love.graphics.setColor(color or WHITE)
  love.graphics.print(str, x, y)
end

local function centeredX(str)
  return math.floor((Screen.width - font:getWidth(str)) / 2)
end

local function ratioColor(t)
  local from, to, k = RED, YELLOW, t * 2
  if t >= 0.5 then from, to, k = YELLOW, GREEN, t * 2 - 1 end
  for i = 1, 3 do scratch[i] = Util.lerp(from[i], to[i], k) end
  return scratch
end

---@param e Interactable
local function tally(e)
  total = total + 1
  if e.usedToday then done = done + 1 end
end

---@param night integer
---@return string
local function forecast(night)
  if night ~= forecastNight then
    local config = wavesdata.NIGHTS[math.min(night, #wavesdata.NIGHTS)]
    local parts = {}

    for _, g in ipairs(config.groups) do
      parts[#parts + 1] = g.count .. " " .. SIZE_NAMES[g.size]
    end

    forecastText = table.concat(parts, ", ")
    forecastNight = night
  end
  return forecastText
end

---@param world World
local function status(world)
  local player = world.player

  if player then
    local w, h = 60, 6
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", MARGIN, MARGIN, w, h)
    love.graphics.setColor(0.9, 0.3, 0.4, 1)
    love.graphics.rectangle("fill", MARGIN, MARGIN, w * (player.hp / playerdata.MAX_HP), h)
  end

  text("Sugar " .. world.sugar, MARGIN, MARGIN + 10)
  text("Walls " .. (world.stock.wall or 0) .. "  Heals " .. (world.stock.heal or 0),
    MARGIN, MARGIN + 22)
end

---@param world World
local function hint(world)
  local player = world.player
  if not player or player.dead then return end

  local target = world:nearest(player.x, player.y, playerdata.INTERACT_REACH, "interactable") --[[@as Interactable]]
  if not target then return end

  local task = tasksdata[target.taskId]
  local label = string.format("[%s] %s", bindings.interact[1]:upper(), task.name)
  local color = WHITE

  if target.usedToday then
    label, color = task.name .. " (done today)", GREY
  elseif task.cost then
    label = label .. " - " .. task.cost .. " sugar"
    if world.sugar < task.cost then color = RED end
  end
  text(label, centeredX(label), Screen.height - 34, color)
end

---@param world World
local function counter(world)
  done, total = 0, 0
  world:eachOfKind("interactable", tally)

  local label = "Tasks " .. done .. "/" .. total
  text(label, centeredX(label), Screen.height - 20,
    ratioColor(total > 0 and done / total or 0))
end

local function timer(timeLeft)
  local w, h = 100, 5
  local x, ratio = math.floor((Screen.width - w) / 2),
      Util.clamp(timeLeft / daytimings.DAY_LENGTH, 0, 1)
  love.graphics.setColor(0, 0, 0, 0.6)
  love.graphics.rectangle("fill", x, MARGIN, w, h)
  love.graphics.setColor(ratioColor(ratio))
  love.graphics.rectangle("fill", x, MARGIN, w * ratio, h)
  local label = tostring(math.ceil(timeLeft))
  text(label, centeredX(label), MARGIN + h)
end

function HUD.init()
  font = love.graphics.newFont(10, "mono")
end

---@param world World
---@param timeLeft number
---@param busy boolean
function HUD.drawDay(world, timeLeft, busy)
  love.graphics.push("all")
  love.graphics.setFont(font)
  status(world)

  local title = "Night " .. world.night .. "/" .. #wavesdata.NIGHTS
  local info = forecast(world.night)
  text(title, Screen.width - MARGIN - font:getWidth(title), MARGIN)
  text(info, Screen.width - MARGIN - font:getWidth(info), MARGIN + 12, GREY)

  if not busy then hint(world) end
  counter(world)
  timer(timeLeft)
  love.graphics.pop()
end

---@param world World
function HUD.drawNight(world)
  love.graphics.push("all")
  love.graphics.setFont(font)
  status(world)

  local title = "Night " .. world.night
  local info = world:count("jelly") .. " jellies remaining"
  text(title, Screen.width - MARGIN - font:getWidth(title), MARGIN)
  text(info, Screen.width - MARGIN - font:getWidth(info), MARGIN + 12, GREY)

  love.graphics.pop()
end

return HUD
