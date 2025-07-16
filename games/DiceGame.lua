local GameState = require("utils.GameState")

local DiceGame = {}

function DiceGame:load()
    self.result = math.random(6)
end

function DiceGame:update(dt) end

function DiceGame:draw()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("You rolled a " .. self.result, 0, love.graphics.getHeight()/2 - 30, love.graphics.getWidth(), "center")

    love.graphics.setColor(0.2, 0.8, 0.2)
    love.graphics.rectangle("fill", 300, 400, 200, 50)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Back to Casino", 300, 415, 200, "center")
end

function DiceGame:mousepressed(x, y)
    if x > 300 and x < 500 and y > 400 and y < 450 then
        GameState:switch("casino")
    end
end

return DiceGame
