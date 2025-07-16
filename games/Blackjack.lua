local Blackjack = {}

local Button = require("utils.Button")
local GameState = require("utils.GameState")

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

local backButton
local blackjackFont

local dealerScore = 0
local playerScore = 0

function Blackjack:load()
    blackjackFont = love.graphics.newFont(24)

    backButton = Button("Back", screenWidth - 120, screenHeight - 60, 100, 40, function()
        local regFont = love.graphics.newFont(18)
        love.graphics.setFont(regFont)
        GameState:switch("casino")
    end)

    self:dealHands()
end

function Blackjack:dealHands()
    dealerScore = math.random(2, 21)
    playerScore = math.random(2, 21)
end

function Blackjack:update(dt)
    local mx, my = love.mouse.getPosition()
    backButton:update(mx, my)
end

function Blackjack:draw()
    love.graphics.setFont(blackjackFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("BLACKJACK", 0, 80, screenWidth, "center")

    love.graphics.printf("Dealer Score: " .. dealerScore, 0, screenHeight / 2 - 40, screenWidth, "center")
    love.graphics.printf("Player Score: " .. playerScore, 0, screenHeight / 2, screenWidth, "center")

    backButton:draw()
end

function Blackjack:mousepressed(x, y, button)
    backButton:checkClick(x, y)
end

function Blackjack:mousereleased(x, y, button)
    -- optional: add interactions later
end

function Blackjack:keypressed(key)
    if key == "escape" then
        GameState:switch("casino")
    end
end

return Blackjack
