Card = {
    name = "Card",
    suit = "Unknown",
    value = 0,
    image = nil,

    new = function(self, suit, value, image)
        local obj = setmetatable({}, {__index = self})
        obj.suit = suit
        obj.value = value
        obj.image = image
        return obj
    end,

    draw = function(self, x, y)
        if self.image then
            love.graphics.draw(self.image, x, y)
        else
            love.graphics.print(self.suit .. " " .. self.value, x, y)
        end
    end
}

function Card:load()
    -- Load card image if needed
    if self.image then
        self.image = love.graphics.newImage(self.image)
    end
end

function Card:update(dt)
    -- Update card state if needed
end

function Card:mousepressed(x, y, button)
    if button == 1 then
        -- Handle card click
        print("Card clicked: " .. self.name)
    end
end

function Card:__tostring()
    return self.name .. " of " .. self.suit .. " (Value: " .. self.value .. ")"
end

function Card:reset()
    self.suit = "Unknown"
    self.value = 0
    self.image = nil
end

function Card:copy()
    return Card:new(self.suit, self.value, self.image)
end

function Card:equals(other)
    return self.suit == other.suit and self.value == other.value
end

function Card:serialize()
    return {
        name = self.name,
        suit = self.suit,
        value = self.value,
        image = self.image
    }
end