local Util = {}

---@param v number
---@param lo number
---@param hi number
---@return number
function Util.clamp(v, lo, hi)
  return math.max(lo, math.min(hi, v))
end

---@param a number
---@param b number
---@param t number
---@return number
function Util.lerp(a, b, t)
  return a + (b - a) * t
end

return Util
