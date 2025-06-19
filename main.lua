state = 'launcher'  -- Initial state of the game

local launcher = {}        -- temporary stub
local effects = require('misc.effects')  -- effects module for flashing
local pongGame = require('pong.pongGame')
local coinflipGame = require('coinflip.coinflipGame')

local draws = require('utils.draws')  -- utility functions for drawing
local sort = require('utils.sorts')  -- sorting algorithms module

local x, y, rotation, turtle, background, keyboard
local speed = 120

local main_loop = love.audio.newSource("assets/sounds/main_loop.wav", "static") -- Load the main loop sound
main_loop:setLooping(true) -- Set the sound to loop

--local state = 'launcher'

function launcher.load()
    love.window.setTitle('BOGO')
    love.window.setMode(1080, 720, {resizable = false, vsync = true})
    main_loop:play() -- Play the main loop sound
    launcher.font = launcher.font or love.graphics.newFont(18)
    background = love.graphics.newImage("assets/images/minecraft_lush1.jpg")
    turtle = love.graphics.newImage("assets/images/turtle1.png")
    rotation = 0
    x = -turtle:getWidth()
    y = 50
end

function launcher.update(dt)
    rotation = rotation + 1 * dt
    x = x + speed * dt
    if x > love.graphics.getWidth() then
        x = -turtle:getWidth()
    end

    launcher.font = love.graphics.newFont(18) -- Ensure the font is set
end

function launcher.draw()
    love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth() / background:getWidth(), love.graphics.getHeight() / background:getHeight())
    love.graphics.draw(turtle, x, y, 0) -- 0 is rotation
    draws:drawKeyboard()
    love.graphics.setColor(1,1,1) -- reset color to white
    love.graphics.printf('Press P to play Pong\nPress F to flip a Coin\nPress S to sort', 0, love.graphics.getHeight()/2 + 200,
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
    -- elseif sort
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
    -- elseif sort
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
    -- elseif sort
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