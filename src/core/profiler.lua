local Profiler = {}

local visible = false

local HISTORY_SIZE = 120
local frameHistory = {}
local historyIndex = 1
local historyCount = 0

local frameTime = 0
local fps = 0
local averageFps = 0
local minFps = 0

local MEMORY_SAMPLE_INTERVAL = 30
local memoryFrameCounter = 0
local memoryKB = 0
local previousMemoryKB = 0
local memoryDelta = 0

local graphicsStats = {}

local sections = {}
local sectionStack = {}

local function updateMemory()
  previousMemoryKB = memoryKB
  memoryKB = collectgarbage("count")

  memoryDelta = memoryKB - previousMemoryKB
end

local function pushHistory(value)
  frameHistory[historyIndex] = value

  historyIndex = historyIndex % HISTORY_SIZE + 1
  historyCount = math.min(historyCount + 1, HISTORY_SIZE)
end

function Profiler.toggle()
  visible = not visible
end

function Profiler.isVisible()
  return visible
end

function Profiler.beginFrame(dt)
  if not visible then return end
  frameTime = dt * 1000
  fps = dt > 0 and 1 / dt or 0

  pushHistory(frameTime)

  local total = 0
  local worstFrame = 0

  for i = 1, historyCount do
    local value = frameHistory[i]
    total = total + value
    worstFrame = math.max(worstFrame, value)
  end

  averageFps = total > 0 and (historyCount * 1000 / total) or 0
  minFps = worstFrame > 0 and 1000 / worstFrame or 0

  memoryFrameCounter = memoryFrameCounter + 1

  if memoryFrameCounter >= MEMORY_SAMPLE_INTERVAL then
    memoryFrameCounter = 0
    updateMemory()
  end

  sections = {}
  sectionStack = {}
end

function Profiler.beginSection(name)
  local entry = {
    name = name,
    start = love.timer.getTime()
  }

  table.insert(sectionStack, entry)
end

function Profiler.endSection(name)
  local entry = table.remove(sectionStack)

  if not entry then
    return
  end

  local elapsed = (love.timer.getTime() - entry.start) * 1000

  local section = sections[entry.name] or {
    time = 0,
    calls = 0
  }

  section.time = section.time + elapsed
  section.calls = section.calls + 1

  sections[entry.name] = section
end

function Profiler.gcStep(size)
  local start = love.timer.getTime()
  local result = collectgarbage("step", size or 1)
  local elapsed = (love.timer.getTime() - start) * 1000

  return elapsed, result
end

local function drawText(label, value, x, y)
  love.graphics.setColor(0.7, 0.7, 0.7, 1)
  love.graphics.print(label, x, y)

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf(tostring(value), x + 115, y, 125, "right")
end

local function drawGraph(x, y, width, height)
  love.graphics.setColor(0.15, 0.15, 0.15, 1)
  love.graphics.rectangle("fill", x, y, width, height)

  if historyCount < 2 then
    return
  end

  local maxTime = 33.33

  love.graphics.setColor(0.3, 0.8, 0.5, 1)

  local previousX, previousY

  for i = 1, historyCount do
    local index = (historyIndex - historyCount + i - 1)
        % HISTORY_SIZE + 1
    if frameHistory[index] then
      local value = frameHistory[index]
      local px = x + ((i - 1) / (HISTORY_SIZE - 1)) * width
      local py = y + height - math.min(value / maxTime, 1) * height

      if previousX then
        love.graphics.line(previousX, previousY, px, py)
      end

      previousX, previousY = px, py
    end
  end

  local referenceY = y + height - (16.67 / maxTime) * height

  love.graphics.setColor(1, 0.7, 0.2, 0.8)
  love.graphics.line(x, referenceY, x + width, referenceY)
end

function Profiler.draw()
  if not visible then
    return
  end

  graphicsStats = love.graphics.getStats()

  local x, y = 12, 12
  local width, height = 270, 350

  love.graphics.push("all")

  love.graphics.setColor(0.05, 0.05, 0.05, 0.92)
  love.graphics.rectangle("fill", x, y, width, height, 5, 5)

  love.graphics.setColor(0.3, 0.8, 0.5, 1)
  love.graphics.print("PROFILER", x + 12, y + 10)

  local lineY = y + 38

  drawText("FPS", string.format("%.1f", fps), x + 12, lineY)
  lineY = lineY + 19

  drawText("Average FPS", string.format("%.1f", averageFps), x + 12, lineY)
  lineY = lineY + 19

  drawText("Minimum FPS", string.format("%.1f", minFps), x + 12, lineY)
  lineY = lineY + 19

  drawText("Frame time", string.format("%.2f ms", frameTime), x + 12, lineY)
  lineY = lineY + 25

  drawGraph(x + 12, lineY, width - 24, 55)
  lineY = lineY + 68

  love.graphics.setColor(0.3, 0.8, 0.5, 1)
  love.graphics.print("MEMORY", x + 12, lineY)
  lineY = lineY + 20

  drawText("Lua memory", string.format("%.2f MB", memoryKB / 1024), x + 12, lineY)
  lineY = lineY + 19

  drawText("Memory delta", string.format("%+.2f KB", memoryDelta), x + 12, lineY)
  lineY = lineY + 25

  love.graphics.setColor(0.3, 0.8, 0.5, 1)
  love.graphics.print("GRAPHICS", x + 12, lineY)
  lineY = lineY + 20

  drawText("Draw calls", graphicsStats.drawcalls or 0, x + 12, lineY)
  lineY = lineY + 19

  drawText("Images", graphicsStats.images or 0, x + 12, lineY)
  lineY = lineY + 19

  drawText("Canvases", graphicsStats.canvases or 0, x + 12, lineY)
  lineY = lineY + 19

  drawText(
    "Texture memory",
    string.format("%.2f MB", (graphicsStats.texturememory or 0) / 1048576),
    x + 12,
    lineY
  )

  love.graphics.pop()
end

function Profiler.reset()
  frameHistory = {}
  historyIndex = 1
  historyCount = 0
  sections = {}
end

return Profiler
