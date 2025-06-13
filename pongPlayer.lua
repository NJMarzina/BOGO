PongPlayer = {}

function PongPlayer:load()
    self.x = 50
    self.y = love.graphics.getHeight() / 2
    self.img = love.graphics.newImage("assets/images/paddle1.png") -- Load the paddle image
    self.width = self.img:getWidth() --20
    self.height = self.img:getHeight() --100
    self.speed = 500 -- Speed in pixels per second
end

function PongPlayer:update(dt)
    self:move(dt)
    self:checkBoundaries()
end

function PongPlayer:move(dt)
    if love.keyboard.isDown("w") then   -- add or up arrow
        self.y = self.y - self.speed * dt
    elseif love.keyboard.isDown("s") then -- add or down arrow
        self.y = self.y + self.speed * dt
    end
end

function PongPlayer:checkBoundaries()
    if self.y < 0 then
        self.y = 0
    elseif self.y + self.height > love.graphics.getHeight() then
        self.y = love.graphics.getHeight() - self.height
    end
end

function PongPlayer:draw()
    --love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.draw(self.img, self.x, self.y)
end