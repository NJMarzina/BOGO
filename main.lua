state = 'launcher'  -- Initial state of the game

local launcher = {}        -- temporary stub
local pongGame = require('pongGame')

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
    end
end

function love.draw()
    if state == 'launcher' then
        launcher.draw()
    elseif state == 'pong' then
        pongGame:draw()
    end
end

--helper that any module can call
function _G.returnToLauncher()
    state = 'launcher'
    launcher.load()                 -- reset the launcher screen (optional)
    -- reset anything else you want here (scores, paddles etc.)
end

function love.keypressed(key)
    if state == 'launcher' and key == 'p' then
        state = 'pong'
        pongGame:load()
    elseif key == 'escape' then
        love.event.quit()
    elseif state == 'pong' and key == 'q' then
        returnToLauncher()  -- Quit the game and return to launcher
    end
end
