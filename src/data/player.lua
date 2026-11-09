local playerdata = {
  SIZE         = 16,
  HALF         = 0,
  MAX_SPEED    = 130,
  ACCELERATION = 12,
  FRICTION     = 10,
  COLOR        = { 0.9, 0.8, 0.3, 1 },
  HIT_DURATION = 0.9,
  HURT_RADIUS  = 0,
}

playerdata.HALF = playerdata.SIZE / 2
playerdata.HURT_RADIUS = playerdata.HALF - playerdata.HALF * 0.4

return playerdata
