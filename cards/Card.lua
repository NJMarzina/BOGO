Card = {}
Card.__index = Card

function Card:new(data)
    local card = setmetatable({}, Card)
    card.name = data.name
    card.value = data.value
    card.suit = data.suit
    card.imagePath = data.image
    card.image = love.graphics.newImage(data.image)
    card.dragging = false
    card.is_on_deck = true
    card.velocity = { x = 0, y = 0 }
    card.transform = {
        x = love.graphics.getWidth() / 2 - 70,
        y = love.graphics.getHeight() / 2 - 112,
        width = 140,
        height = 224
    }
    card.target_transform = {
        x = card.transform.x,
        y = card.transform.y,
        width = 140,
        height = 224
    }
    return card
end

function Card:draw()
    love.graphics.draw(self.image, self.transform.x, self.transform.y, 0, 0.2, 0.2)
end

return Card
