---@type Events
local Events = require("src.core.events")
local Util = require("src.core.util")

local structuresdata = require("src.data.structures")

local scratch = { 1, 1, 1, 1 }

---@class Structure : Entity
---@field structureId StructureId
---@field hw number Half width
---@field hh number Half height
---@field maxHp number
local Structure = {}
Structure.__index = Structure

---@param structureId StructureId
---@param x number
---@param y number
---@param vertical boolean Swaps width and height
function Structure.new(structureId, x, y, vertical)
  local def = assert(structuresdata[structureId], "unknown structure: " .. tostring(structureId))
  local w, h = def.w, def.h
  if vertical then w, h = h, w end

  return setmetatable({
    -- entity
    x = x,
    y = y,
    kind = "structure",
    hp = def.hp,
    dead = false,
    -- structure
    structureId = structureId,
    hw = w / 2,
    hh = h / 2,
    maxHp = def.hp,
  }, Structure)
end

function Structure:chew(amount)
  if self.dead then return end

  self.hp = math.max(self.hp - amount, 0)
  if self.hp == 0 then
    self.dead = true
    Events.emit("structure_destroyed", self)
  end
end

function Structure:update(dt) end

function Structure:draw()
  local def = structuresdata[self.structureId]
  local c = Util.mixColor(def.cracked, def.color, self.hp / self.maxHp, scratch)
  love.graphics.setColor(c)
  love.graphics.rectangle("fill", self.x - self.hw, self.y - self.hh, self.hw * 2, self.hh * 2)
  love.graphics.setColor(1, 1, 1, 1)
end

return Structure
