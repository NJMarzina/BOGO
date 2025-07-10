Casino = {}

local Card = require('cards.Card')
local StandardDeck = require('cards.standardDeck')

function Casino:load()
    love.window.setTitle('Casino')
    --love.window.setMode(1080, 720)

    self.deck = StandardDeck:new()
    self.deck:load()

    self.cards = {}
    for i = 1, 5 do
        local card = Card:new("Unknown", 0, nil)
        table.insert(self.cards, card)
    end

    -- Load any additional resources or settings here
end

function Casino:update(dt)
    -- Update game state, animations, etc.
    for _, card in ipairs(self.cards) do
        card:update(dt)
    end
end

function Casino:draw()
    -- Draw the casino background, cards, etc.
    love.graphics.clear(0.1, 0.1, 0.1) -- Clear the screen with a dark color
    for i, card in ipairs(self.cards) do
        card:draw(100 + (i - 1) * 150, 300) -- Draw cards in a row
    end

    -- Draw the deck
    self.deck:draw()
end