Casino = {}

--local Card = require('cards.Card')
--local StandardDeck = require('cards.standardDeck')

local state = "casino"

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

local cardSprite
local cardSound
local crtShader

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

local function new_card()
    return {
        dragging = false,
        transform = {
            x = (screenWidth - 100) / 2,
            y = (screenHeight - 150) / 2,
            width = 140,
            height = 224
        },
        target_transform = {
            x = (screenWidth - 100) / 2,
            y = (screenHeight - 150) / 2,
            width = 140,
            height = 224
        },
        velocity = {
            x = 0,
            y = 0,
        },
        is_on_deck = true,
    }
end

--local function queue_sound(sound, delay, pitch)
--    table.insert(sounds, { sound = sound, delay = delay, pitch = pitch })
--end

function Casino:load()
    love.window.setTitle('Casino')
    --love.window.setMode(1080, 720)

    -- Load the standard deck of cards
    cardSprite = love.graphics.newImage("assets/images/blue_deck_back.png")
    --cardSound = love.audio.newSource("card.ogg", "static")
    --crtShader = love.graphics.newShader("crt.glsl")
    canvas = love.graphics.newCanvas(screenWidth, screenHeight, { type = '2d', readable = true })

    for _ = 1, 52 do
        local card = new_card()
        table.insert(cards, card)
        table.insert(deck.cards, card)
    end
end

function Casino:update(dt)
    for _, card in ipairs(cards) do
        if card.dragging then
            card.target_transform.x = love.mouse.getX() - card.transform.width / 2
            card.target_transform.y = love.mouse.getY() - card.transform.height / 2
        end
        move(card, dt)
        align(deck)
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
    love.graphics.setColor(0.015, 0.647, 0.898, 1)
    love.graphics.circle(
        "fill",
        deck.transform.x + deck.transform.width / 2,
        deck.transform.y + deck.transform.height + 50,
        15
    )
    love.graphics.setColor(1, 1, 1, 1)
    for _, card in ipairs(deck.cards) do
        love.graphics.draw(cardSprite, card.transform.x, card.transform.y, 0, 0.2, 0.2)
    end
    for _, card in ipairs(cards) do
        if not card.is_on_deck then
            love.graphics.draw(cardSprite, card.transform.x, card.transform.y, 0, 0.2, 0.2)
        end
    end

    love.graphics.setCanvas()
    love.graphics.setColor({ 1, 1, 1 })
    --crtShader:send('millis', love.timer.getTime() - startTime)
    --love.graphics.setShader(crtShader)
    love.graphics.draw(canvas, 0, 0)
    --love.graphics.setShader()
end

function Casino:mousepressed(x, y)
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

    if x > deck.transform.x + deck.transform.width / 2 - 15
        and x < deck.transform.x + deck.transform.width / 2 + 15
        and y > deck.transform.y + deck.transform.height + 50 - 15
        and y < deck.transform.y + deck.transform.height + 50 + 15 then
        local count = 1
        for _, card in ipairs(cards) do
            if not card.is_on_deck then
                card.is_on_deck = true
                table.insert(deck.cards, card)
                count = count + 1
            end
        end
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