state = 'launcher'  -- Initial state of the game

local launcher = {}        -- temporary stub
local effects = require('misc.effects')  -- effects module for flashing
local pongGame = require('pong.pongGame')
local coinflipGame = require('coinflip.coinflipGame')
local settings = require('settings.settings')  -- settings module
local Button = require('utils.Button')  -- Button class for UI elements

local draws = require('utils.draws')  -- utility functions for drawing
local sort = require('utils.sorts')  -- sorting algorithms module
local casino = require('casino.casino')  -- casino module

local x, y, rotation, turtle, background, keyboard
local speed = 120

local main_loop = love.audio.newSource("assets/sounds/main_loop.wav", "static") -- Load the main loop sound
main_loop:setLooping(true) -- Set the sound to loop

local state = 'launcher'

function launcher.load()
    love.window.setTitle('BOGO')
    love.window.setMode(1080, 720, {resizable = false, vsync = true})
    main_loop:play() -- Play the main loop sound
    main_loop:setVolume(0) -- Set the volume to a reasonable level
    launcher.font = love.graphics.newFont(18)
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

    --launcher.font = love.graphics.newFont(18) -- Ensure the font is set
end

function launcher.draw()
    love.graphics.setFont(launcher.font)
    love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth() / background:getWidth(), love.graphics.getHeight() / background:getHeight())
    love.graphics.draw(turtle, x, y, 0) -- 0 is rotation
    draws:drawKeyboard()
    love.graphics.setColor(1,1,1) -- reset color to white
    love.graphics.printf('Press P to play Pong\nPress F to flip a Coin\nPress B to play BOGO\nPress S to sort\n\n\nduck duck duck goose', 0, love.graphics.getHeight()/2 + 200,
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
    elseif state == 'casino' then
        casino:update(dt)
    elseif state == 'settings' then
        settings:update(dt)
    effects.update(dt) -- flash effect
    end

    if Settings.update then
        Settings:update(dt)
    end
    --launcher.font = love.graphics.newFont(18) -- Ensure the font is set
end

function love.draw()
    if state == 'launcher' then
        launcher.draw()
    elseif state == 'pong' then
        pongGame:draw()
    elseif state == 'coinflip' then
        coinflipGame:draw()
    elseif state == 'casino' then
        casino:draw()
    elseif state == 'settings' then
        settings:draw()
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
    elseif state == 'coinflip' and key == 'f' then -- Reset the coin flip game
        coinflipGame:load()
    elseif state == 'launcher' and key == 'b' then
        state = 'casino'
        casino:load()  -- Load the casino game
    elseif state == 'launcher' and key == 'escape' then -- elseif sort here
        state = 'settings'
        settings:load()
    elseif state == 'settings' and key == 'escape' then
        returnToLauncher()
    elseif key == 'escape' then -- if in any other state, load settings; find way to return back to prev state on esc again, rather than launcher
        state = 'settings'
        settings:load()
        --love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    if state == 'settings' and Settings.mousepressed then
        Settings:mousepressed(x, y, button)
    elseif state == 'casino' and casino.mousepressed then
        casino:mousepressed(x, y, button)
    end
end

function love.mousereleased(x, y, button)
    if state == 'settings' and Settings.mousereleased then
        Settings:mousereleased(x, y, button)
    elseif state == 'casino' and casino.mousereleased then
        casino:mousereleased(x, y, button)
    end
end

-- Function to return to the launcher state
-- This function can be called from anywhere in the code to reset the game state

--helper that any module can call
function _G.returnToLauncher()
    state = 'launcher'
    launcher.load()                 -- reset the launcher screen (optional)
    -- reset anything else you want here (scores, paddles etc.)
end