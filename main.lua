state = 'launcher'  -- Initial state of the game

local launcher = {}        -- temporary stub
local effects = require('misc.effects')  -- effects module for flashing
local pongGame = require('pong.pongGame')
local coinflipGame = require('coinflip.coinflipGame')

--local state = 'launcher'

function launcher.load()
    love.window.setTitle('BOGO')
    launcher.font = launcher.font or love.graphics.newFont(18)
end
function launcher.update(dt) end
function launcher.draw()
    love.graphics.setFont(launcher.font)
    love.graphics.printf('Press P to play Pong\nPress F to flip a Coin', 0, love.graphics.getHeight()/2,
                        love.graphics.getWidth(), 'center')
end

function love.load()
    launcher.load()
end

function love.update(dt)
    if state == 'launcher' then
        launcher.update(dt)
    elseif state == 'pong' then
        pongGame:update(dt)
    elseif state == 'coinflip' then
        coinflipGame:update(dt)
    effects.update(dt) -- flash effect
    end
end

function love.draw()
    if state == 'launcher' then
        launcher.draw()
    elseif state == 'pong' then
        pongGame:draw()
    elseif state == 'coinflip' then
        coinflipGame:draw()
    effects.draw() -- draw flash effect
    end
end

function love.keypressed(key)
    if state == 'launcher' and key == 'p' then
        state = 'pong'
        pongGame:load()
    elseif key == 'escape' then
        love.event.quit()
    elseif key == 'f' then
        state = 'coinflip'
        coinflipGame:load()
    elseif key == 'q' then
        returnToLauncher()
    end
end

--helper that any module can call
function _G.returnToLauncher()
    state = 'launcher'
    launcher.load()                 -- reset the launcher screen (optional)
    -- reset anything else you want here (scores, paddles etc.)
end
