local GameState = require("utils.GameState")

local DiceGame = {}

local screenWidth = love.graphics.getWidth()

function DiceGame:load()
    self.result = math.random(6)
    self.aiResult = math.random(6)
end

function DiceGame:update(dt) end

function DiceGame:draw()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("You rolled a " .. self.result, 0, love.graphics.getHeight()/2 - 30, love.graphics.getWidth(), "center")
    love.graphics.printf("The AI rolled a " .. self.aiResult, 0, love.graphics.getHeight()/2 + 10, love.graphics.getWidth(), "center")

    if( self.result > self.aiResult) then
        love.graphics.setColor(0, 1, 0)
        love.graphics.printf("You win!", 0, love.graphics.getHeight()/2 + 50, love.graphics.getWidth(), "center")
    elseif (self.result < self.aiResult) then
        love.graphics.setColor(1, 0, 0)
        love.graphics.printf("You lose!", 0, love.graphics.getHeight()/2 + 50, love.graphics.getWidth(), "center")
    else
        love.graphics.setColor(1, 1, 0)
        love.graphics.printf("It's a tie!", 0, love.graphics.getHeight()/2 + 50, love.graphics.getWidth(), "center")
    end

    love.graphics.setColor(0.2, 0.8, 0.2)
    love.graphics.rectangle("fill", 450, 600, 200, 50)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Back to Casino", 450, 615, 200, "center")
end

function DiceGame:mousepressed(x, y)
    if x > 450 and x < 650 and y > 600 and y < 650 then
        GameState:switch("casino")
    end
end

return DiceGame
