---@class Events
local Events = {}

---@type table<GameEvent, Listener[]>
local listeners = {}

---Subscribes a handler to an event
---@param name GameEvent
---@param fn EventHandler
---@param owner? table Whatever will later call off_owner (a state, a system)
function Events.on(name, fn, owner)
  local list = listeners[name] or {}
  listeners[name] = list
  list[#list + 1] = { fn = fn, owner = owner }
end

---Removes every handler registered by this owner. Call it on state exit
---so listeners don't pile up
---@param owner table
function Events.off_owner(owner)
  assert(owner ~= nil, "Events.off_owner: owner is required")
  for _, list in pairs(listeners) do
    for i = #list, 1, -1 do
      if list[i].owner == owner then table.remove(list, i) end
    end
  end
end

---Calls every handler subscribed to the event, in subscription order
---@param name GameEvent
---@param ... any Payload forwarded to the handlers
function Events.emit(name, ...)
  local list = listeners[name]
  if not list then return end

  local snapshot = {}
  for i = 1, #list do snapshot[i] = list[i] end

  for i = 1, #snapshot do snapshot[i].fn(...) end
end

return Events
