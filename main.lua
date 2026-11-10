local love = require("love")

---@type Game
local Game = require("src.game")

function love.load() Game.load() end

function love.update(dt) Game.update(dt) end

function love.draw() Game.draw() end

function love.keypressed(k, sc) Game.keypressed(k, sc) end

function love.mousepressed(x, y, button) Game.mousepressed(x, y, button) end

function love.resize(w, h) Game.resize(w, h) end
