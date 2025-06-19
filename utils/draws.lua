local Draws = {}

Draws.keyboard = love.graphics.newImage("assets/images/keyboard.png")

Draws.font = love.graphics.newFont(18)

function Draws:load()
    self.font = self.font or love.graphics.newFont(18)
end

function Draws:update(dt)

end

function Draws:draw()
    self:drawKeyboard()
end

function Draws:drawKeyboard()
    love.graphics.draw(self.keyboard, 0, 0, 0, love.graphics.getWidth() / self.keyboard:getWidth(), love.graphics.getHeight() / self.keyboard:getHeight())
    self.font = self.font or love.graphics.newFont(18)
    love.graphics.setColor(0,0,0) -- set color to black for text below
    love.graphics.printf('esc', -455, 225, love.graphics.getWidth(), 'center')
    love.graphics.printf('P', 280, 322, love.graphics.getWidth(), 'center')
    love.graphics.printf('S', -245, 370, love.graphics.getWidth(), 'center')
    love.graphics.printf('F', -110, 370, love.graphics.getWidth(), 'center')
end

return Draws