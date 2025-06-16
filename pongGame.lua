local PongGame = {}

require('pongPlayer')
require('pongBall')
require('pongOpponent')
require('pongBackground')

function PongGame:load()
    love.window.setTitle('Pong')
    love.window.setMode(1080, 720)

    PongPlayer:load()
    PongBall:load()
    PongOpponent:load()
    PongBackground:load()

    self.score = {player = 0, opponent = 0}
    _G.Score   = self.score

    self.font  = love.graphics.newFont(30)
end


function PongGame:update(dt)
    PongPlayer:update(dt)
    PongBall:update(dt)
    PongOpponent:update(dt)
    PongBackground:update(dt)
end

function PongGame:draw()
    PongBackground:draw()
    PongPlayer:draw()
    PongBall:draw()
    PongOpponent:draw()

    love.graphics.setFont(self.font)
    love.graphics.print('Player: '..self.score.player, 50, 50)
    love.graphics.print('Opponent: '..self.score.opponent, love.graphics.getWidth()-250, 50)
end

return PongGame
