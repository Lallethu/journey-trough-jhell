local Events = require("src.core.events")
local Screen = require("src.core.screen")

-- all this might go in a data struct later
local FADE = 0.2
local AREA = { x = 170, top = 67, bottom = 85 }
local DIM = { 0, 0, 0, 0.5 }
local LIVE = { 1.0, 0.85, 0.3 }
local HIT = { 0.4, 1.0, 0.5 }
local MISS = { 1.0, 0.35, 0.35 }

---@class ClickTargets : Task
---@field config table
---@field onFinish fun(success: boolean)
---@field targets table[]
---@field spawned integer
---@field hits integer
---@field timer number
---@field finished boolean
local ClickTargets = {}
ClickTargets.__index = ClickTargets

---@param config table Must be a minigame from data/tasks.lua
---@param onFinish fun(success: boolean)
---@return ClickTargets
function ClickTargets.new(config, onFinish)
  assert(config, "has no minigame config")
  return setmetatable({
    config = config,
    onFinish = onFinish,
    targets = {},
    spawned = 0,
    hits = 0,
    timer = config.interval,
    finished = false,
  }, ClickTargets)
end

local function spawn(self)
  self.spawned = self.spawned + 1
  self.targets[#self.targets + 1] = {
    x = love.math.random(AREA.x, Screen.width - AREA.x),
    y = love.math.random(AREA.top, Screen.height - AREA.bottom),
    age = 0,
    fade = 0,
    state = "live"
  }
end

local function settle(self, target, state)
  target.state, target.fade = state, FADE
  if state == "hit" then self.hits = self.hits + 1 end
end

---@param dt number
function ClickTargets:update(dt)
  local c = self.config

  if self.spawned < c.count then
    self.timer = self.timer + dt

    if self.timer >= c.interval then
      self.timer = self.timer - c.interval
      spawn(self)
    end
  end

  for i = #self.targets, 1, -1 do
    local t = self.targets[i]

    if t.state == "live" then
      t.age = t.age + dt
      if t.age >= c.lifetime then settle(self, t, "missed") end
    else
      t.fade = t.fade - dt
      if t.fade <= 0 then table.remove(self.targets, i) end
    end
  end

  if not self.finished and self.spawned == c.count and #self.targets == 0 then
    self.finished = true
    self.onFinish(self.hits >= c.need)
  end
end

---@param x number Canvas coordinates
---@param y number
function ClickTargets:mousepressed(x, y)
  local r2 = self.config.radius * self.config.radius

  for i = #self.targets, 1, -1 do
    local t = self.targets[i]

    if t.state == "live" then
      local dx, dy = x - t.x, y - t.y

      if dx * dx + dy * dy <= r2 then
        settle(self, t, "hit")
        Events.emit("task_target_hit", t.x, t.y)
        return
      end
    end
  end
end

function ClickTargets:draw()
  local r = self.config.radius
  Screen.fill(DIM)

  for i = 1, #self.targets do
    local t = self.targets[i]

    if t.state == "live" then
      local left = 1 - t.age / self.config.lifetime

      love.graphics.setColor(LIVE)
      love.graphics.circle("fill", t.x, t.y, r)
      love.graphics.setColor(1, 1, 1, 0.8)
      love.graphics.circle("line", t.x, t.y, r + r * left)
    else
      local a = t.fade / FADE
      local color = t.state == "hit" and HIT or MISS

      love.graphics.setColor(color[1], color[2], color[3], a)
      love.graphics.circle("line", t.x, t.y, r + (1 - a) * r)
    end
  end

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf(self.hits .. " / " .. self.config.need, 0, 38, Screen.width, "center")
end

return ClickTargets
