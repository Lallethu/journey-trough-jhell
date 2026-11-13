local playeranimations = {
  path = "assets/gfx/player.png",
  frameW = 32,
  frameH = 24,
  originX = 16,
  originY = 16,
  clips = {
    idle  = { frames = { 10, 11, 12, 13 }, durations = { 0.14, 0.14, 0.17, 0.13 }, loop = true },
    swing = {
      frames = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
      durations = { 0.02, 0.01, 0.04, 0.03, 0.02, 0.04, 0.07, 0.04, 0.05 },
      loop = false,
      impact = 6
    },
  },
}

return playeranimations
