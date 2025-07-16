local Blackjack = {}

local Button = require("utils.Button")
local GameState = require("utils.GameState")
local StandardDeck = require("cards.StandardDeck")

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

local backButton, restartButton, hitButton, standButton
local blackjackFont

local deck = { cards = {} }
local cards = {}

local playerHand = {}
local dealerHand = {}

local gamePhase = "player"
local message = ""

local cardBackImage = love.graphics.newImage("assets/images/blue_deck_back.png")

local cardImages = {}

local time = 0
local backgroundShader = love.graphics.newShader("assets/shaders/drive_home.frag")

local function createBlackjackDeck()
    local blackjackCards = {}
    for _, c in ipairs(StandardDeck.cards) do
        local value = c.value
        if value > 10 then value = 10 end
        table.insert(blackjackCards, {
            name = c.name,
            suit = c.suit,
            value = value,
            imagePath = c.image,
            image = nil, -- to be loaded later
        })
    end
    return blackjackCards
end

local function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
end

local function calculateScore(hand)
    local score = 0
    local aceCount = 0

    for _, card in ipairs(hand) do
        if card.value == 1 then
            aceCount = aceCount + 1
            score = score + 1
        else
            score = score + card.value
        end
    end

    while aceCount > 0 and score + 10 <= 21 do
        score = score + 10
        aceCount = aceCount - 1
    end

    return score
end

local function loadCardImages(cards)
    for _, card in ipairs(cards) do
        card.image = love.graphics.newImage(card.imagePath)
    end
end

function Blackjack:load()
    blackjackFont = love.graphics.newFont(18)

    backButton = Button("Back", screenWidth - 240, screenHeight - 60, 100, 40, function()
        GameState:switch("casino")
    end)

    restartButton = Button("Restart", screenWidth - 120, screenHeight - 60, 100, 40, function()
        self:load() -- reload Blackjack game
    end)

    hitButton = Button("Hit", 100, screenHeight - 60, 100, 40, function()
        if gamePhase == "player" then
            if #deck.cards == 0 then message = "Deck is empty!" return end
            table.insert(playerHand, table.remove(deck.cards))
            if calculateScore(playerHand) > 21 then
                message = "Bust! Dealer wins."
                gamePhase = "gameover"
            elseif calculateScore(playerHand) == 21 then
                gamePhase = "dealer"
            end
        end
    end)

    standButton = Button("Stand", 220, screenHeight - 60, 100, 40, function()
        if gamePhase == "player" then
            gamePhase = "dealer"
        end
    end)

    cards = createBlackjackDeck()
    loadCardImages(cards)
    shuffle(cards)

    deck.cards = {}
    for _, card in ipairs(cards) do
        table.insert(deck.cards, card)
    end

    playerHand = {table.remove(deck.cards), table.remove(deck.cards)}
    dealerHand = {table.remove(deck.cards), table.remove(deck.cards)}

    message = ""
    gamePhase = "player"
end

function Blackjack:update(dt)
    time = time + dt
    backgroundShader:send("iTime", time)
    backgroundShader:send("iResolution", {screenWidth, screenHeight})

    local mx, my = love.mouse.getPosition()
    backButton:update(mx, my)
    restartButton:update(mx, my)
    hitButton:update(mx, my)
    standButton:update(mx, my)

    if gamePhase == "dealer" then
        local dealerScore = calculateScore(dealerHand)
        local playerScore = calculateScore(playerHand)

        if dealerScore < 17 then
            if #deck.cards == 0 then
                message = "Deck is empty!"
                gamePhase = "gameover"
            else
                table.insert(dealerHand, table.remove(deck.cards))
            end
        else
            if dealerScore > 21 then
                message = "Dealer busts! You win!"
            elseif dealerScore < playerScore then
                message = "You win!"
            elseif dealerScore > playerScore then
                message = "Dealer wins!"
            else
                message = "Push! It's a tie."
            end
            gamePhase = "gameover"
        end
    end
end

function Blackjack:draw()
    love.graphics.setShader(backgroundShader)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
    love.graphics.setShader()

    love.graphics.setFont(blackjackFont)
    love.graphics.setColor(1, 1, 1)

    love.graphics.printf("BLACKJACK", 0, 40, screenWidth, "center")

    local dealerScore = calculateScore(dealerHand)
    local playerScore = calculateScore(playerHand)

    -- Draw dealer score and cards horizontally
    local showFullDealerHand = (gamePhase ~= "player")
    local displayedDealerScore = showFullDealerHand and calculateScore(dealerHand) or "?"

    love.graphics.printf("Dealer's Hand (" .. displayedDealerScore .. "):", 50, 100, screenWidth, "left")

    local startX = 50
    local startY = 140
    local cardSpacing = 60
    for i, card in ipairs(dealerHand) do
        if i == 1 or showFullDealerHand then
            if card.image then
                love.graphics.draw(card.image, startX + (i-1)*cardSpacing, startY, 0, 0.2, 0.2)
            else
                love.graphics.printf(card.name, startX + (i-1)*cardSpacing, startY, 100, "left")
            end
        else
            love.graphics.draw(cardBackImage, startX + (i-1)*cardSpacing, startY, 0, 0.15, 0.15)
        end
    end

    -- Draw player score and cards horizontally
    love.graphics.printf("Player's Hand (" .. playerScore .. "):", 50, 300, screenWidth, "left")
    startY = 340
    for i, card in ipairs(playerHand) do
        if card.image then
            love.graphics.draw(card.image, startX + (i-1)*cardSpacing, startY, 0, 0.2, 0.2)
        else
            love.graphics.printf(card.name, startX + (i-1)*cardSpacing, startY, 100, "left")
        end
    end

    love.graphics.printf(message, 0, screenHeight - 120, screenWidth, "center")

    backButton:draw()
    restartButton:draw()

    if gamePhase == "player" then
        hitButton:draw()
        standButton:draw()
    end
end

function Blackjack:mousepressed(x, y, button)
    backButton:checkClick(x, y)
    restartButton:checkClick(x, y)
    hitButton:checkClick(x, y)
    standButton:checkClick(x, y)
end

function Blackjack:keypressed(key)
    if key == "escape" then
        GameState:switch("casino")
    end
end

return Blackjack
