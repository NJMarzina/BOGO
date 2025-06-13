--pong requirements
require("pongPlayer")
require("pongBall")
require("pongOpponent")
require("pongBackground")

function love.load()    --triggers when game started , data and assets

    --pong game
    pongLoad() -- Load the pong game assets and modules

    Score = { player = 0, opponent = 0 } -- Initialize the score table
    font = love.graphics.newFont(30) -- Create a new font with size 30
    --end pong game
end

function love.update(dt) -- program actual game logic. handled/triggered 1 time per frame...

    --pong game
    pongUpdate(dt)
    --end pong game
end

function love.draw() -- used to display graphics

    --pong game
    pongDraw() -- Draw the pong game elements
    --end pong game
end

function pongLoad()
    PongPlayer:load() -- Load the player paddle
    PongBall:load()   -- Load the ball
    PongOpponent:load() -- Load the opponent paddle
    PongBackground:load() -- Load the background
end

function pongUpdate(dt)
    PongPlayer:update(dt)
    PongBall:update(dt) -- Update the PongBall module
    PongOpponent:update(dt) -- Update the PongOpponent module
    PongBackground:update(dt) -- Update the PongBackground module
end

function pongDraw()
    PongBackground:draw() -- Draw the background first
    PongPlayer:draw()
    PongBall:draw()
    PongOpponent:draw()
    drawPongScore() -- Draw the score on top of everything else
end

function drawPongScore()
    love.graphics.setFont(font) -- Set the font for score display
    love.graphics.print("Player Score: " .. Score.player, 50, 50)
    love.graphics.print("Opponent Score: " .. Score.opponent, love.graphics.getWidth() - 450, 50)
end