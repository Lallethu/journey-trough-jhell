local tasksdata = require("src.data.tasks")

local BODY_RADIUS = 10

---@class Interactable : Entity
---@field taskId TaskId Key into data/tasks.lua (!= to the entity id)
---@field radius number
---@field usedToday boolean
local Interactable = {}
Interactable.__index = Interactable

---@param taskId TaskId
---@param x number Center
---@param y number Center
---@return Interactable
function Interactable.new(taskId, x, y)
  assert(tasksdata[taskId], "unknown task: " .. tostring(taskId))
  return setmetatable({
    -- entity
    x = x,
    y = y,
    kind = "interactable",
    dead = false,
    -- interactable
    taskId = taskId,
    radius = BODY_RADIUS,
    usedToday = false,
  }, Interactable)
end

---@return boolean used True if the interaction was available
function Interactable:tryUse()
  if self.usedToday then return false end
  self.usedToday = true
  return true
end

function Interactable:refresh()
  -- TODO: animation idea
  self.usedToday = false
end

function Interactable:update(dt) end

function Interactable:draw()
  local color = tasksdata[self.taskId].color
  love.graphics.setColor(color[1], color[2], color[3], self.usedToday and 0.35 or 1)
  love.graphics.rectangle("fill", self.x - self.radius, self.y - self.radius,
    self.radius * 2, self.radius * 2)
  love.graphics.setColor(1, 1, 1, 1)
end

return Interactable
