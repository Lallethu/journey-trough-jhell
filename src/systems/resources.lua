local Events = require("src.core.events")

local tasksdata = require("src.data.tasks")
local jellydata = require("src.data.jelly")

---@type World
local world

---@class Resources
local Resources = {}

---@param taskId TaskId
local function onTaskDone(taskId)
  local task = tasksdata[taskId]
  if task.earns then
    world.sugar = world.sugar + task.earns
    Events.emit("sugar_changed", task.earns, true)
  end
  if task.cost then
    world.sugar = world.sugar - task.cost
    Events.emit("sugar_changed", task.cost, false)
  end
  if task.gives then
    world.stock[task.gives] = (world.stock[task.gives] or 0) + 1
  end
end

---@param jelly Jelly
local function onJellyDied(jelly)
  local amount = math.random(jellydata.SUGAR_REWARD.min, jellydata.SUGAR_REWARD.max) +
      jelly.size
  world.sugar = world.sugar + amount

  Events.emit("sugar_changed", amount, true)
end

---@param p_world World
function Resources.init(p_world)
  world = p_world
  Events.off_owner(Resources)
  Events.on("task_done", onTaskDone, Resources)
  Events.on("jelly_died", onJellyDied, Resources)
end

return Resources
