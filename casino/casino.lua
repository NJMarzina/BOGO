-- casino/casino.lua - Main Casino game state (cleaned up)
Casino = {}

local CasinoRenderer = require('casino.CasinoRenderer')
local CasinoInput = require('casino.CasinoInput')
local CasinoLogic = require('casino.CasinoLogic')
local CasinoUI = require('casino.CasinoUI')
local CasinoState = require('casino.CasinoState')

function Casino:load()
    love.window.setTitle('Casino')
    love.window.setMode(1080, 720, {resizable = false, vsync = true})
    
    -- Initialize all subsystems
    CasinoState:init()
    CasinoRenderer:init()
    CasinoUI:init()
    CasinoLogic:init()
    CasinoInput:init()
end

function Casino:update(dt)
    CasinoState:update(dt)
    CasinoLogic:update(dt)
    CasinoRenderer:update(dt)
end

function Casino:draw()
    CasinoRenderer:draw()
    CasinoUI:draw()
end

function Casino:mousepressed(x, y)
    CasinoInput:mousepressed(x, y)
end

function Casino:mousereleased(x, y)
    CasinoInput:mousereleased(x, y)
end

function Casino:keypressed(key)
    if key == "escape" then
        local GameState = require('utils.GameState')
        GameState:switch("settings")
    end
end

function Casino:evaluateHand(hand)
    CasinoLogic:evaluateHand(hand)
end

return Casino