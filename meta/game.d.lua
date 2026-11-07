---@meta game

---Metafile documenting types and APIs

---@alias Binding
---| "move_left"
---| "move_right"
---| "move_up"
---| "move_down"
---| "interact"
---| "attack"

---@class Input
local Input = {}

---comment
---@param binding Binding
---@return boolean isActive Whether or not the keyboard input is held down
function Input.isDown(binding) end

---comment
---@return number x, number y
function Input.axis() end

---comment
---@param key love.KeyConstant
---@param scancode love.Scancode
function Input.keypressed(key, scancode) end

---@class Screen
---@field width integer
---@field height integer
local Screen = {}

---Sets the filters and the canvas to the screen size
function Screen.init() end

---Callback to hook in love
---@param w integer
---@param h integer
function Screen.resize(w, h) end

---Sets the canvas and clear the background
function Screen.begin() end

---Empty the canvas buffer to allow draw again, set a background color and
---draw the texture from the canvas to the screen
function Screen.finish() end

---Compute physical to virtual position
---@param x number
---@param y number
---@return number x , number y
function Screen.toGameCoordinates(x, y) return x, y end

---@class State
local State = {}

---Trigger when StateManager:switch is called
---@param ... unknown
function State:enter(...) end

---Trigger when StateManager:switch is called
function State:exit() end

---Updates the state
---@param dt number
function State:update(dt) end

---Draws the state
function State:draw() end

---@alias StateList table<string, State>

---@class StateMachine
---@field states StateList
---@field current State
---@field name string The key string as index
local StateMachine = {}

---Creates a new StateMachine instance and feed states to its states list
---@param states StateList
---@return StateMachine
function StateMachine.new(states) return StateMachine end

---Tries to switch to the specified scene if present in the states list
---@param name string
---@param ... unknown
function StateMachine:switch(name, ...) end

---Updates the current state if update is implemented
---@param dt number
function StateMachine:update(dt) end

---Draws the current state if draw is implemented
function StateMachine:draw() end
