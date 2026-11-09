local wavesdata = {
  EDGE_MARGIN = 20, -- care if jelly.size changes, this one should as well
  NIGHTS = {
    { interval = 0.8, groups = { { size = 1, count = 6 } } },
    { interval = 0.7, groups = { { size = 1, count = 8 }, { size = 2, count = 2 } } },
    { interval = 0.6, groups = { { size = 1, count = 8 }, { size = 2, count = 4 } } },
    { interval = 0.6, groups = { { size = 2, count = 6 }, { size = 3, count = 1 } } },
    { interval = 0.5, groups = { { size = 2, count = 6 }, { size = 3, count = 3 } } },
    { interval = 0.5, groups = { { size = 1, count = 12 }, { size = 3, count = 5 } } },
    { interval = 0.4, groups = { { size = 2, count = 10 }, { size = 3, count = 6 } } },
  },
}

return wavesdata
