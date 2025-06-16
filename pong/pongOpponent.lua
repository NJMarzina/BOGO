PongOpponent = {}

function PongOpponent:load()
    self.img = love.graphics.newImage("assets/images/paddle2.png") -- Load the paddle image
    self.width = self.img:getWidth() --20
    self.height = self.img:getHeight() --100
    self.speed = 500 -- Speed in pixels per second
    self.x = love.graphics.getWidth() - self.width - 50
    self.y = love.graphics.getHeight() / 2
    self.yVel = 0

    self.timer = 0
    self.rate = 0.5
end

function PongOpponent:update(dt)
    self.x = love.graphics.getWidth() - self.width - 50 -- Keep the opponent paddle on the right side
    -- this is required to keep paddle on right side, if window size changes

    self:move(dt)
    self:checkBoundaries()
    self.timer = self.timer + dt
    if self.timer > self.rate then
        self.timer = 0
        self:acquireTarget()
    end
end

function PongOpponent:move(dt)
    self.y = self.y + self.yVel * dt
end

function PongOpponent:acquireTarget()
    if PongBall.y + PongBall.height < self.y then
        self.yVel = -self.speed -- Move up
    elseif PongBall.y > self.y + self.height then
        self.yVel = self.speed -- Move down
    else
        self.yVel = 0 -- Stop moving
    end
end

function PongOpponent:checkBoundaries()
    if self.y < 0 then
        self.y = 0
    elseif self.y + self.height > love.graphics.getHeight() then
        self.y = love.graphics.getHeight() - self.height
    end
end

function PongOpponent:draw()
    --love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.draw(self.img, self.x, self.y)
end