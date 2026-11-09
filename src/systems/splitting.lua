local Events = require("src.core.events")
local Screen = require("src.core.screen")
local Util = require("src.core.util")
local Jelly = require("src.world.jelly")

local jellydata = require("src.data.jelly")

---@class SplittingSystem
local SplittingSystem = {}

---@type World
local world

---@param parent Jelly
local function onJellyDied(parent)
  local rule = jellydata.SPLIT_PER_SIZE[parent.size]
  if rule.dead then return end

  local angle = love.math.random() * math.pi * 2
  for i = 1, rule.split do
    local a = angle + (i - 1) * (math.pi * 2 / rule.split)
    local x = parent.x + math.cos(a) * parent.radius
    local y = parent.y + math.sin(a) * parent.radius

    local child = Jelly.new(
      world,
      Util.clamp(x, 0, Screen.width),
      Util.clamp(y, 0, Screen.height),
      rule.size)
    child.hitTimer = child.hitDuration
    world:add(child)
  end
end

---@param ctx { world: World }
function SplittingSystem.init(ctx)
  world = ctx.world
  -- unhook the event in case caller is called for a restart
  -- like so if "world" is reset too, the reference does not point to nil
  -- TODO: make the restart logic in src/game.lua
  Events.off_owner(SplittingSystem)
  Events.on("jelly_died", onJellyDied, SplittingSystem)
end

return SplittingSystem
