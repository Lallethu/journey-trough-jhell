---@class World
---@field entities Entity[]
---@field pending Entity[]
---@field player Hittable
---@field nextId integer
---@field night integer
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
    night = 1,
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

---@param x number
---@param y number
---@param r number
---@param kind EntityKind
---@return Entity[]
function World:queryCircle(x, y, r, kind)
  local found = {}
  for i = 1, #self.entities do
    local e = self.entities[i] --[[@as Jelly]]
    if e.kind == kind and not e.dead then
      local dx, dy = e.x - x, e.y - y
      local reach = r + e.radius
      if dx * dx + dy * dy <= reach * reach then
        found[#found + 1] = e
      end
    end
  end
  return found
end

---@param kind EntityKind
---@return integer
function World:count(kind)
  local n = 0
  for i = 1, #self.entities do
    local e = self.entities[i]
    if e.kind == kind and not e.dead then n = n + 1 end
  end
  for i = 1, #self.pending do
    local e = self.pending[i]
    if e.kind == kind and not e.dead then n = n + 1 end
  end
  return n
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
