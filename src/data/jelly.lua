local jellydata = {
  RADIUS_PER_SIZE     = 6,
  BASE_SPEED          = 60,
  SPEED_LOSS_PER_SIZE = 10,
  MIN_DISTANCE        = 9,
  COLOR               = { 1, 1, 1, 1 },
  -- COLOR               = { 0.7, 0.34, 0.05, 1 },
  HIT_DURATION        = 0.4,
  BASE_DAMAGE         = 8,
  DAMAGE_MULTIPLIER   = {
    [1] = 1.00,
    [2] = 1.25,
    [3] = 1.65,
  },
  SUGAR_REWARD        = { min = 2, max = 3 },
  CHEW_FACTOR         = 0.4,
  SPLIT_PER_SIZE      = {
    [1] = { dead = true },
    [2] = { size = 1, split = 2 },
    [3] = { size = 2, split = 2 },
  }
}

return jellydata
