local Events = require("src.core.events")

local playerdata = require("src.data.player")

---@class PlayerCommands
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
  -- will be present in the day phase: for now a stub until the first interactable exists
  return false
end

return Commands
