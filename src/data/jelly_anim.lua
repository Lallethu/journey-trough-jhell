local jellyanimations = {
  path = "assets/gfx/jhellnemy.png",
  frameW = 32,
  frameH = 24,
  originX = 16,
  originY = 16,
  clips = {
    chasing = { frames = { 1, 2, 3, 8 }, durations = { 0.14, 0.14, 0.14, 0.14 }, loop = true },
    hurt    = { frames = { 9, 10, 11, 12 }, durations = { 0.14, 0.14, 0.14, 0.14 }, loop = true },
    swing   = {
      frames = { 4, 5, 6, 7, 8 },
      durations = { 0.1, 0.1, 0.1, 0.1, 0.1 },
      loop = false,
      impact = 5
    },
  },
}

return jellyanimations
