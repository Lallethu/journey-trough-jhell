local playerdata = {
  SIZE             = 16,
  HALF             = 0,
  MAX_HP           = 100,
  BASE_HEAL_AMOUNT = 10,
  MAX_SPEED        = 130,
  ACCELERATION     = 12,
  FRICTION         = 10,
  COLOR            = { 0.9, 0.8, 0.3, 1 },
  HIT_DURATION     = 0.9,
  HURT_RADIUS      = 0,
  ATTACK_RADIUS    = 12.67,
  ATTACK_COOLDOWN  = 0.27,
  ATTACK_DAMAGE    = 1.78,
  ATTACK_REACH     = 12,
  INTERACT_REACH   = 24,
  PLACE_DISTANCE   = 22,
}

playerdata.HALF = playerdata.SIZE / 2
playerdata.HURT_RADIUS = playerdata.HALF - playerdata.HALF * 0.4

return playerdata
