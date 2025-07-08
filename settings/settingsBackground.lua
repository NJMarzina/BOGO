SettingsBackground = {
    background = nil,
    x = 0,
    y = 0
}

function SettingsBackground:load()
    self.background = love.graphics.newImage("assets/images/settings_background.png")
    self.x = 0
    self.y = 0
end

function SettingsBackground:update(dt)
    -- No specific update logic for the settings background
end

function SettingsBackground:draw()
    love.graphics.draw(self.background, self.x, self.y, 0, love.graphics.getWidth() / self.background:getWidth(), love.graphics.getHeight() / self.background:getHeight())
end