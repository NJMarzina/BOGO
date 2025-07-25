state = 'launcher'

local launcher = {}
local effects = require('misc.effects')
local pongGame = require('pong.pongGame')
local coinflipGame = require('coinflip.coinflipGame')
local settings = require('settings.settings')
local Button = require('utils.Button')
local draws = require('utils.draws')
local sort = require('utils.sorts')
local casino = require('casino.casino')
local GameState = require('utils.GameState')

local diceGame = require('games.DiceGame')
local bjGame = require('games.Blackjack')

GameState:register("casino", casino)
GameState:register("dice", diceGame)
GameState:register("blackjack", bjGame)
GameState:register("coinflip", coinflipGame)
GameState:register("settings", settings)

local x, y, rotation, turtle, background, keyboard
local speed = 120

local main_loop = love.audio.newSource("assets/sounds/main_loop.wav", "static")
main_loop:setLooping(true)

function launcher.load()
    love.window.setTitle('BOGO')
    love.window.setMode(1080, 720, {resizable = false, vsync = true})
    main_loop:play()
    main_loop:setVolume(0)
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
end

function launcher.draw()
    love.graphics.setFont(launcher.font)
    love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth() / background:getWidth(), love.graphics.getHeight() / background:getHeight())
    love.graphics.draw(turtle, x, y, 0)
    draws:drawKeyboard()
    love.graphics.setColor(1,1,1)
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
    elseif state == 'casino' then
        GameState:update(dt)
    end
    
    effects.update(dt)
end

function love.draw()
    if state == 'launcher' then
        launcher.draw()
    elseif state == 'pong' then
        pongGame:draw()
    elseif state == 'coinflip' then
        coinflipGame:draw()
    elseif state == 'casino' then
        GameState:draw()
    end
    
    effects.draw()
end

function love.keypressed(key)
    -- Handle launcher keys
    if state == 'launcher' then
        if key == 'p' then
            state = 'pong'
            pongGame:load()
        elseif key == 'f' then
            state = 'coinflip'
            coinflipGame:load()
        elseif key == 'b' then
            state = 'casino'
            GameState:switch("casino")
        elseif key == 'escape' then
            GameState:switch("settings")
        end
    -- Handle other game states
    elseif state == 'pong' then
        if key == 'q' or key == 'escape' then
            returnToLauncher()
        end
    elseif state == 'coinflip' then
        if key == 'f' then
            coinflipGame:load()
        elseif key == 'q' or key == 'escape' then
            returnToLauncher()
        end
    elseif state == 'casino' then
        -- Forward to GameState system
        GameState:keypressed(key)
    end
    
    -- Global quit key
    if key == 'q' and state ~= 'casino' then
        returnToLauncher()
    end
end

function love.mousepressed(x, y, button)
    if state == 'casino' then
        GameState:mousepressed(x, y, button)
    end
end

function love.mousereleased(x, y, button)
    if state == 'casino' then
        GameState:mousereleased(x, y, button)
    end
end

function _G.returnToLauncher()
    -- Reset casino state when returning to launcher
    local CasinoState = require('casino.CasinoState')
    CasinoState:reset()
    
    state = 'launcher'
    GameState.current = nil
    GameState.previousState = nil
    launcher.load()
end