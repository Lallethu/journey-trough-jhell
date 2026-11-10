local Events = require("src.core.events")

local playerdata = require("src.data.player")
local tasksdata = require("src.data.tasks")

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
---@return Interactable? target
function Commands.interact(world)
  local player = world.player --[[@as Player]]
  if not player or player.dead then return nil end

  local target = world:nearest(player.x, player.y, playerdata.INTERACT_REACH, "interactable") --[[@as Interactable]]
  if not target or target.usedToday then return nil end

  local task = tasksdata[target.taskId]
  if task.cost and world.sugar < task.cost then
    Events.emit("task_refused", target.taskId)
    return nil
  end

  return target
end

---@param world World
function Commands.heal(world)
  local player = world.player --[[@as Player]]
  if not player or player.dead then return false end
  if world.stock and world.stock.heal < 1 then return false end

  local healed = math.min(playerdata.BASE_HEAL_AMOUNT, playerdata.MAX_HP - player.hp)
  if healed <= 0 then return false end -- TODO: add fx full life toast text

  player.hp = player.hp + healed
  world.stock.heal = world.stock.heal - 1
  Events.emit("player_healed", healed, player.x, player.y)
  return true
end

function Commands.placeWall(world) end -- stub

return Commands
