PongBackground = {}

function PongBackground:load()
    self.background = love.graphics.newImage("assets/images/space_background2.jpg")
    self.planets = love.graphics.newImage("assets/images/planets_background1.png")

    self.width = self.planets:getWidth()
    self.height = self.planets:getHeight()

    --self.width = 540
    --self.height = 360

    self.rotation = 0
end

function PongBackground:update(dt)
    self.rotation = self.rotation + 0.05 * dt
end

function PongBackground:draw()
    love.graphics.draw(self.background, 0, 0, 0, love.graphics.getWidth() / self.background:getWidth(), love.graphics.getHeight() / self.background:getHeight())
    --love.graphics.draw(self.planets, 0, 0, self.rotation, love.graphics.getWidth() / self.planets:getWidth(), love.graphics.getHeight() / self.planets:getHeight())
    love.graphics.draw(self.planets, self.width / 2, self.height, self.rotation, 1, 1, self.width / 2, self.height / 2)
    -- 2nd, 3rd argument is for position (x, y)
    -- 4th argument is for rotation
    -- 5th, 6th arguments are for scaling the image to fit the screen
end