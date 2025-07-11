Card = {
    name = "Card",
    suit = "Unknown",
    value = 0,
    image = "assets/images/blue_deck_back.png",  -- Default image for the card back
}

function Card:load()
    self.image = love.graphics.newImage(self.image)
end

function Card:update(dt)
    
end

function Card:draw(x, y)
    love.graphics.draw(self.image, x, y)
end