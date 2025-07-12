Casino = {}

local Card = require('cards.Card')
local StandardDeck = require('cards.StandardDeck')

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

local sounds = {}
local startTime = love.timer.getTime()

local canvas

local deck = {
    cards = {},
    transform = {
        x = screenWidth / 2 - 100,
        y = screenHeight / 2 - 150,
        width = 140,
        height = 224
    }
}

local cards = {}

local function align(deck)
    local deck_height = 10 / #deck.cards
    for position, card in ipairs(deck.cards) do
        if not card.dragging then
            card.target_transform.x = deck.transform.x - deck_height * (position - 1)
            card.target_transform.y = deck.transform.y + deck_height * (position - 1)
        end
    end
end

local function move(card, dt)
    local momentum = 0.75
    local max_velocity = 10
    if (card.target_transform.x ~= card.transform.x or card.velocity.x ~= 0) or
       (card.target_transform.y ~= card.transform.y or card.velocity.y ~= 0) then
        card.velocity.x = momentum * card.velocity.x +
            (1 - momentum) * (card.target_transform.x - card.transform.x) * 30 * dt
        card.velocity.y = momentum * card.velocity.y +
            (1 - momentum) * (card.target_transform.y - card.transform.y) * 30 * dt
        card.transform.x = card.transform.x + card.velocity.x
        card.transform.y = card.transform.y + card.velocity.y

        local velocity = math.sqrt(card.velocity.x ^ 2 + card.velocity.y ^ 2)
        if velocity > max_velocity then
            card.velocity.x = max_velocity * card.velocity.x / velocity
            card.velocity.y = max_velocity * card.velocity.y / velocity
        end
    end
end

local function resetDeck()
    for _, card in ipairs(cards) do
        card.is_on_deck = true
    end

    deck.cards = {}
    for _, card in ipairs(cards) do
        table.insert(deck.cards, card)
    end

    align(deck)
end

local function shuffleDeck()
    resetDeck()

    local bogo = require('utils.sorts').bogoOnce
    bogo(deck.cards)

    cards = {}
    for _, card in ipairs(deck.cards) do
        table.insert(cards, card)
    end

    align(deck)
end

local function dealSixCards()
    local num_to_deal = math.min(6, #deck.cards)

    for i = 1, num_to_deal do
        local card = deck.cards[#deck.cards - i + 1]  -- top card
        card.is_on_deck = false
        for j = #deck.cards, 1, -1 do
            if deck.cards[j] == card then
                table.remove(deck.cards, j)
                break
            end
        end
    end

    local left_x = 50
    local right_x = screenWidth - 190 -- card width + margin
    local start_y = screenHeight / 2 - 100
    local spacing = 80

    local dealt_cards = {}
    for _, card in ipairs(cards) do
        if not card.is_on_deck then
            table.insert(dealt_cards, card)
        end
    end

    for i, card in ipairs(dealt_cards) do
        card.target_transform.y = start_y + spacing * ((i - 1) % 3)
        if i <= 3 then
            card.target_transform.x = left_x
        else
            card.target_transform.x = right_x
        end
    end
end

function Casino:load()
    love.window.setTitle('Casino')
    canvas = love.graphics.newCanvas(screenWidth, screenHeight, { type = '2d', readable = true })
    cards = {}
    deck.cards = {}

    for _, cardData in ipairs(StandardDeck.cards) do
        local card = Card:new(cardData)
        table.insert(cards, card)
        table.insert(deck.cards, card)
    end

    math.randomseed(os.time())
    math.random()

    local bogo = require('utils.sorts').bogoOnce
    bogo(deck.cards)

    cards = {}
    for _, card in ipairs(deck.cards) do
        table.insert(cards, card)
    end

    align(deck)
end

function Casino:update(dt)
    for _, card in ipairs(cards) do
        if card.dragging then
            card.target_transform.x = love.mouse.getX() - card.transform.width / 2
            card.target_transform.y = love.mouse.getY() - card.transform.height / 2
        end
        move(card, dt)
    end

    for position, sound in ipairs(sounds) do
        if sound.delay <= 0 then
            sound.sound:setPitch(sound.pitch)
            love.audio.play(sound.sound)
            table.remove(sounds, position)
            sound.sound:setPitch(sound.pitch)
        else
            sound.delay = sound.delay - dt
        end
    end
end

function Casino:draw()
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0.937, 0.945, 0.96, 1)

    -- Red deal button (left)
    love.graphics.setColor(0.9, 0.1, 0.1, 1)
    love.graphics.circle("fill",
        deck.transform.x + deck.transform.width / 2 - 40,
        deck.transform.y + deck.transform.height + 50,
        15
    )

    -- Blue reset button (center)
    love.graphics.setColor(0.015, 0.647, 0.898, 1)
    love.graphics.circle("fill",
        deck.transform.x + deck.transform.width / 2,
        deck.transform.y + deck.transform.height + 50,
        15
    )

    -- Green shuffle + realign button (right)
    love.graphics.setColor(0.2, 0.8, 0.3, 1)
    love.graphics.circle("fill",
        deck.transform.x + deck.transform.width / 2 + 40,
        deck.transform.y + deck.transform.height + 50,
        15
    )

    love.graphics.setColor(1, 1, 1, 1)

    for _, card in ipairs(cards) do
        card:draw()
    end

    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(canvas, 0, 0)
end

function Casino:mousepressed(x, y)
    -- Card dragging
    for i = #cards, 1, -1 do
        local card = cards[i]
        if x > card.transform.x
            and x < card.transform.x + card.transform.width
            and y > card.transform.y
            and y < card.transform.y + card.transform.height
        then
            card.dragging = true
            break
        end
    end

    -- Red deal button (left)
    if x > deck.transform.x + deck.transform.width / 2 - 55
        and x < deck.transform.x + deck.transform.width / 2 - 25
        and y > deck.transform.y + deck.transform.height + 35
        and y < deck.transform.y + deck.transform.height + 65
    then
        shuffleDeck()
        dealSixCards()
    end

    -- Blue reset button (center)
    if x > deck.transform.x + deck.transform.width / 2 - 15
        and x < deck.transform.x + deck.transform.width / 2 + 15
        and y > deck.transform.y + deck.transform.height + 50 - 15
        and y < deck.transform.y + deck.transform.height + 50 + 15
    then
        resetDeck()
    end

    -- Green shuffle button (right)
    if x > deck.transform.x + deck.transform.width / 2 + 25
        and x < deck.transform.x + deck.transform.width / 2 + 55
        and y > deck.transform.y + deck.transform.height + 35
        and y < deck.transform.y + deck.transform.height + 65
    then
        shuffleDeck()
    end
end

function Casino:mousereleased()
    for i = #cards, 1, -1 do
        local card = cards[i]
        if card.dragging then
            card.dragging = false
            if card.is_on_deck then
                card.is_on_deck = false
                for j = #deck.cards, 1, -1 do
                    if deck.cards[j] == card then
                        table.remove(deck.cards, j)
                        break
                    end
                end
            end
        end
    end
end

return Casino
