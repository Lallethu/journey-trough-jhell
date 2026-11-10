local Events = require("src.core.events")

local tasksdata = require("src.data.tasks")

---@type World
local world

---@class Resources
local Resources = {}

---@param taskId TaskId
local function onTaskDone(taskId)
  local task = tasksdata[taskId]
  if task.earns then world.sugar = world.sugar + task.earns end
  if task.cost then world.sugar = world.sugar - task.cost end
  if task.gives then
    world.stock[task.gives] = (world.stock[task.gives] or 0) + 1
  end
end

---@param p_world World
function Resources.init(p_world)
  world = p_world
  Events.off_owner(Resources)
  Events.on("task_done", onTaskDone, Resources)
end

return Resources
