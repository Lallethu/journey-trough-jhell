---@class World
---@field entities Entity[]
---@field pending Entity[]
---@field player Hittable
---@field nextId integer
local World = {}
World.__index = World

---Draw order: top of the screen first, so lower entities overlap them.
---The id tie-break keeps the order stable, since table.sort is not.
---@param a Entity
---@param b Entity
---@return boolean
local function byDepth(a, b)
  if a.y ~= b.y then return a.y < b.y end
  return a.id < b.id
end

---@return World
function World.new()
  return setmetatable({
    entities = {},
    pending = {},
    player = nil,
    nextId = 1,
  }, World)
end

---Queues an entity. It joins the world at the end of the current update.
---@param entity Entity
---@return Entity|Hittable
function World:add(entity)
  entity.id = self.nextId
  self.nextId = self.nextId + 1
  self.pending[#self.pending + 1] = entity
  return entity
end

function World:flushPending()
  for i = 1, #self.pending do
    self.entities[#self.entities + 1] = self.pending[i]
    self.pending[i] = nil
  end
end

function World:sweepDead()
  for i = #self.entities, 1, -1 do
    if self.entities[i].dead then table.remove(self.entities, i) end
  end
end

---@param dt number
function World:update(dt)
  for i = 1, #self.entities do
    self.entities[i]:update(dt)
  end
  self:flushPending()
  self:sweepDead()
  table.sort(self.entities, byDepth)
end

function World:draw()
  for i = 1, #self.entities do
    self.entities[i]:draw()
  end
end

return World
