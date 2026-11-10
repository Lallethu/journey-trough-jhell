local Events = require("src.core.events")

local playerdata = require("src.data.player")
local tasksdata = require("src.data.tasks")

local function nearest(list, x, y)
  local best, bestD2
  for i = 1, #list do
    local dx, dy = list[i].x - x, list[i].y - y
    local d2 = dx * dx + dy * dy
    if not bestD2 or d2 < bestD2 then best, bestD2 = list[i], d2 end
  end
  return best
end

---@class Commands
local Commands = {}

---@param world World
---@return boolean executed
function Commands.attack(world)
  local player = world.player --[[@as Player]]
  if not player or player.dead or player.attackTimer > 0 then return false end

  player.attackTimer = playerdata.ATTACK_COOLDOWN

  local cx = player.x + player.facingX * playerdata.ATTACK_REACH
  local cy = player.y + player.facingY * playerdata.ATTACK_REACH

  local targets = world:queryCircle(cx, cy, playerdata.ATTACK_RADIUS, "jelly") --[[@as Jelly]]
  for i = 1, #targets do
    targets[i]:takeHit(playerdata.ATTACK_DAMAGE)
  end

  Events.emit("player_attacked", cx, cy, playerdata.ATTACK_RADIUS)
  return true
end

---@param world World
---@return boolean executed
function Commands.interact(world)
  local player = world.player --[[@as Player]]
  if not player or player.dead then return false end

  local near = world:queryCircle(player.x, player.y, playerdata.INTERACT_REACH, "interactable")
  local target = nearest(near, player.x, player.y) --[[@as Interactable]]
  if not target then return false end

  local task = tasksdata[target.taskId]
  if task.cost and world.sugar < task.cost then
    Events.emit("task_refused", target.taskId)
    return false
  end

  if not target:tryUse() then return false end
  Events.emit("task_done", target.taskId)
  return true
end

return Commands
