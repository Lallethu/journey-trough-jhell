---@type Bindings
local bindings = {
  move_left            = { "a", "left" },
  move_right           = { "d", "right" },
  move_up              = { "w", "up" },
  move_down            = { "s", "down" },

  attack               = { "space" },
  interact             = { "e" },
  -- place_wall           = { "q" }, -- preshot
  -- heal                 = { "f" }, -- preshot
  cancel               = { "x" },
  end_day              = { "return" },

  -- debug_switch_state   = { "return" },
  debug_profiler       = { "f3" },
  debug_reset_profiler = { "f5" },
}

return bindings
