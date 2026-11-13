---@class Animator
---@field sheet table
local Animator = {}
Animator.__index = Animator

---Builds the image and quads once
---
---Share the result between instances
---@param def table A table like data/player_anim.lua
function Animator.newSheet(def)
  local image = love.graphics.newImage(def.path)
  image:setFilter("nearest", "nearest")

  local iw, ih = image:getDimensions()
  local quads = {}

  for i = 1, math.floor(iw / def.frameW) do
    quads[i] = love.graphics.newQuad((i - 1) * def.frameW, 0, def.frameW, def.frameH, iw, ih)
  end

  return { image = image, quads = quads, clips = def.clips, ox = def.originX, oy = def.originY }
end

function Animator.new(sheet)
  return setmetatable({ sheet = sheet, name = nil, clip = nil, frame = 1, t = 0, done = false },
    Animator)
end

---@param name string
---@param restart? boolean Replay even if it's already the current clip
function Animator:play(name, restart)
  if self.name == name and not restart then return end
  self.name, self.clip = name, assert(self.sheet.clips[name], name)
  self.frame, self.t, self.done = 1, 0, false
end

---@param dt number
---@return boolean impact True on the update where the impact frame begins
function Animator:update(dt)
  if self.done then return false end

  local clip, impact = self.clip, false

  self.t = self.t + dt

  while self.t >= clip.durations[self.frame] do
    self.t = self.t - clip.durations[self.frame]
    if self.frame < #clip.frames then
      self.frame = self.frame + 1
      if self.frame == clip.impact then impact = true end
    elseif clip.loop then
      self.frame = 1
    else
      self.done = true
      break
    end
  end
  return impact
end

---@param x number
---@param y number
---@param flip boolean
---@param sx? number Optional squash/stretch for walking
---@param sy? number
function Animator:draw(x, y, flip, sx, sy)
  local s = self.sheet
  love.graphics.draw(s.image, s.quads[self.clip.frames[self.frame]],
    math.floor(x), math.floor(y), 0,
    (flip and -1 or 1) * (sx or 1), sy or 1, s.ox, s.oy)
end

return Animator
