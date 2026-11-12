---@type Tasks
local tasksdata = {
  gatherer = { name = "Pep Hermint, the sugar daddy", color = { 0.95, 0.8, 0.9, 1 }, earns = 10, minigame = { count = 5, need = 4, lifetime = 1.6, interval = 0.55, radius = 11 } },
  wall     = { name = "Wallther, the ginger bread wall baker", color = { 0.6, 0.8, 1.0, 1 }, cost = 15, gives = "wall", minigame = { count = 8, need = 6, lifetime = 1.0, interval = 0.40, radius = 9 } },
  healer   = { name = "Hill Mi, thr candheal man", color = { 0.6, 1.0, 0.7, 1 }, cost = 10, gives = "heal", minigame = { count = 3, need = 3, lifetime = 1.4, interval = 0.70, radius = 7 } },
}

return tasksdata
