---@meta game

---Metafile documenting types and APIs

---@alias Binding
---| "move_left"
---| "move_right"
---| "move_up"
---| "move_down"
---| "interact"
---| "attack"
---| "debug_switch_state"
---| "debug_profiler"
---| "debug_reset_profiler"

---@alias GameEvent
---| "jelly_died"
---| "player_attacked"
---| "jelly_spawned"
---| "task_done"
---| "phase_changed"
---| "wave_cleared"
---| "structure_built"

---@alias EntityKind
---| "player"
---| "jelly"
---| "wall"
---| "npc"

---@alias Bindings table<Binding, love.Scancode[]>

---@alias EventHandler fun(...: any)

---@class Listener
---@field fn EventHandler
---@field owner table?
local listeners = {}

---@class State
---@field machine StateMachine? reference to the statemachine
---@field world World? reference to the world
---@field enter fun(self: State, ...: any)? Trigger when StateMachine:switch is called
---@field exit fun(self: State)? Trigger when StateMachine:switch is called
---@field update fun(self: State, dt: number)?
---@field draw fun(self: State)?
---@field onAction fun(self: State, action: Binding)?

---@alias StateList table<string, State>

---@class StateContext
---@field states StateList
---@field world World

---@class Entity
---@field id integer
---@field x number Centre of the entity
---@field y number Centre of the entity
---@field kind EntityKind
---@field dead boolean
---@field update fun(self: Entity, dt: number)
---@field draw fun(self: Entity)
