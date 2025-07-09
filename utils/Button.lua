local function Button(text, x, y, width, height, callback)
    local button = {
        text = text,
        x = x,
        y = y,
        width = width,
        height = height,
        callback = callback,
        isHovered = false
    }

    function button:update(mx, my)
        self.isHovered = mx >= self.x and mx <= (self.x + self.width) and
                         my >= self.y and my <= (self.y + self.height)
    end

    function button:draw()
        if self.isHovered then
            love.graphics.setColor(0.8, 0.8, 0.8) -- light grey
        else
            love.graphics.setColor(1, 1, 1) -- white
        end
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        love.graphics.setColor(0, 0, 0) -- black text
        love.graphics.printf(self.text, self.x, self.y + (self.height / 2) - 10, self.width, "center")
        love.graphics.setColor(1, 1, 1)
    end

    function button:checkClick(mx, my)
        if mx >= self.x and mx <= (self.x + self.width) and my >= self.y and my <= (self.y + self.height) then
            if self.callback then
                self.callback()
            end
            return true
        end
        return false
    end

    return button
end

return Button
