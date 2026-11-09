local jellydata = {
  RADIUS_PER_SIZE     = 6,
  BASE_SPEED          = 60,
  SPEED_LOSS_PER_SIZE = 10,
  MIN_DISTANCE        = 1,
  COLOR               = { 0.7, 0.34, 0.05, 1 },
  HIT_DURATION        = 0.4,
  BASE_DAMAGE         = 8,
  DAMAGE_MULTIPLIER   = {
    [1] = 1.00,
    [2] = 1.25,
    [3] = 1.65,
  }
}

return jellydata
