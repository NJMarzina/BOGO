state = 'launcher'  -- Initial state of the game

local launcher = {}        -- temporary stub
local effects = require('misc.effects')  -- effects module for flashing
local pongGame = require('pong.pongGame')
local coinflipGame = require('coinflip.coinflipGame')

--local state = 'launcher'

function launcher.load()
    love.window.setTitle('BOGO')
    launcher.font = launcher.font or love.graphics.newFont(18)
    keyboard = love.graphics.newImage("assets/images/keyboard.png")
    background = love.graphics.newImage("assets/images/minecraft_lush1.jpg")
    turtle = love.graphics.newImage("assets/images/turtle1.png")
    rotation = 0
end
function launcher.update(dt)
    rotation = rotation + 1 * dt
end

function launcher.draw()
    love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth() / background:getWidth(), love.graphics.getHeight() / background:getHeight())
    love.graphics.draw(turtle, love.graphics.getWidth()/4, love.graphics.getHeight()/4, rotation)
    love.graphics.draw(keyboard, 0, 0, 0, love.graphics.getWidth() / keyboard:getWidth(), love.graphics.getHeight() / keyboard:getHeight())
    love.graphics.setFont(launcher.font)
    love.graphics.printf('Press P to play Pong\nPress F to flip a Coin', 0, love.graphics.getHeight()/2 + 200,
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
    elseif key == 'q' then
        returnToLauncher()
    elseif state == 'launcher' and key == 'f' then
        state = 'coinflip'
        coinflipGame:load()
    elseif state == 'coinflip' and key == 'f' then
        -- Reset the coin flip game
        coinflipGame:load()
    elseif key == 'escape' then
        love.event.quit()
    end
end

--helper that any module can call
function _G.returnToLauncher()
    state = 'launcher'
    launcher.load()                 -- reset the launcher screen (optional)
    -- reset anything else you want here (scores, paddles etc.)
end
