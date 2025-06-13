PongBall = {}

sonic_sound_1 = love.audio.newSource("assets/sounds/sonar_ping1.mp3", "static") -- Load the sound effect
gameboy_pluck1 = love.audio.newSource("assets/sounds/gameboy_pluck1.mp3", "static") -- Load the sound effect

function PongBall:load()
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2
    self.img = love.graphics.newImage("assets/images/ball1.png") -- Load the ball image
    self.width = self.img:getWidth() -- 20
    self.height = self.img:getHeight() -- 20
    self.speed = 200
    self.xVel = -self.speed
    self.yVel = 0
end

function PongBall:update(dt)
    self:move(dt)
    self:collide()
end

function PongBall:collide()
    self:collideWall()
    self:collidePlayer()
    self:collideOpponent()
    self:score()
end

function PongBall:collideWall()
    if self.y < 0 then
        self.y = 0
        self.yVel = -self.yVel -- Reverse the y velocity (bounce off roof)
    elseif self.y + self.height > love.graphics.getHeight() then
        self.y = love.graphics.getHeight() - self.height
        self.yVel = -self.yVel -- Reverse the y velocity (bounce off floor)
    end
end

function PongBall:collidePlayer()
    if self:checkCollision(self, PongPlayer) then
        self.xVel = self.speed -- Reverse the x velocity (bounce effect)
        local middleBall = self.y + self.height / 2
        local middlePlayer = PongPlayer.y + PongPlayer.height / 2
        local collisionPosition = middleBall - middlePlayer
        self.yVel = collisionPosition * 5

        sonic_sound_1:play()
    end
end

function PongBall:collideOpponent()
    if self:checkCollision(self, PongOpponent) then
        self.xVel = -self.speed -- Reverse the x velocity (bounce effect)
        local middleBall = self.y + self.height / 2
        local middleOpponent = PongOpponent.y + PongOpponent.height / 2
        local collisionPosition = middleBall - middleOpponent
        self.yVel = collisionPosition * 5

        sonic_sound_1:play()
    end
end

function PongBall:checkCollision(a, b)
    if a.x + a.width > b.x and a.x < b.x + b.width and a.y + a.height > b.y and a.y < b.y + b.height then
        return true
    else
        return false
    end
end

function PongBall:score()
    if self.x < 0 then  -- if ball gets to left side of screen
        self:resetPosition(1) -- reset position and set direction to right
        Score.opponent = Score.opponent + 1 -- Increment opponent's score

        gameboy_pluck1:play() -- Play sound effect for scoring
    end
    
    if self.x + self.width > love.graphics.getWidth() then  -- if ball gets to right side of screen
        self:resetPosition(-1) -- reset position and set direction to left
        Score.player = Score.player + 1 -- Increment player's score

        gameboy_pluck1:play() -- Play sound effect for scoring
    end
end

function PongBall:resetPosition(modifier)
    self.x = love.graphics.getWidth() / 2 - self.width / 2
    self.y = love.graphics.getHeight() / 2 - self.height / 2
    self.yVel = 0
    self.xVel = self.speed * modifier -- modifier can be -1 or 1 to change direction
end

function PongBall:move(dt)
    self.x = self.x + self.xVel * dt
    self.y = self.y + self.yVel * dt
end

function PongBall:draw()
    --love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.draw(self.img, self.x, self.y)
end