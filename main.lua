require("pongPlayer")
require("pongBall")
require("pongOpponent")
require("pongBackground")

function love.load()    --triggers when game started , data and assets
    PongPlayer:load() -- Load the PongPlayer module
    PongBall:load()   -- Load the PongBall module
    PongOpponent:load() -- Load the PongOpponent module
    PongBackground:load() -- Load the PongBackground module

    Score = { player = 0, opponent = 0 } -- Initialize the score table
    font = love.graphics.newFont(30) -- Create a new font with size 30
end

function love.update(dt) -- program actual game logic. handled/triggered 1 time per frame...
    PongPlayer:update(dt)
    PongBall:update(dt) -- Update the PongBall module
    PongOpponent:update(dt) -- Update the PongOpponent module
    PongBackground:update(dt) -- Update the PongBackground module
end

function love.draw() -- used to display graphics
    PongBackground:draw() -- Draw the background first
    PongPlayer:draw()
    PongBall:draw()
    PongOpponent:draw()
    drawScore() -- Draw the score on top of everything else
end

function drawScore()
    love.graphics.setFont(font) -- Set the font for score display
    love.graphics.print("Player Score: " .. Score.player, 50, 50)
    love.graphics.print("Opponent Score: " .. Score.opponent, love.graphics.getWidth() - 450, 50)
end