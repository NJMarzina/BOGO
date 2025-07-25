-- casino/CasinoState.lua - Manages all game state data
local CasinoState = {}

local Card = require('cards.Card')
local StandardDeck = require('cards.StandardDeck')
local CardUtils = require('utils.CardUtils')

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

-- Initialize all state variables
function CasinoState:init()
    self.time = 0
    self.showGameButtons = false
    
    -- Canvas for rendering
    self.canvas = love.graphics.newCanvas(screenWidth, screenHeight, { type = '2d', readable = true })
    
    -- Card and deck management
    self.cards = {}
    self.dealt_cards = {}
    self.deck = {
        cards = {},
        transform = {
            x = screenWidth / 2 - 100,
            y = screenHeight / 2 - 150,
            width = 140,
            height = 224
        }
    }
    
    -- Audio system
    self.sounds = {}
    
    -- Game icons
    self.gameIcons = {
        ["Dice"] = love.graphics.newImage("assets/images/dice1.png"),
        ["Blackjack"] = love.graphics.newImage("assets/images/bj1.png"),
        ["Coin Flip"] = love.graphics.newImage("assets/images/coin_heads.png"),
        ["BOGO"] = love.graphics.newImage("assets/images/bogo1.png"),
        ["Plinko"] = love.graphics.newImage("assets/images/plinko1.png"),
        ["Dealer's Choice"] = love.graphics.newImage("assets/images/frog8.png")
    }
    
    -- Drop zones configuration
    local dropZoneWidth = 140 * 0.85
    local dropZoneHeight = 224 * 0.75
    local dropZoneSpacing = 90
    local dropZoneY = screenHeight - dropZoneHeight - 40
    
    self.dropZones = {
        {
            x = screenWidth / 2 - dropZoneWidth - dropZoneSpacing,
            y = dropZoneY,
            width = dropZoneWidth,
            height = dropZoneHeight,
            card = nil,
        },
        {
            x = screenWidth / 2 - dropZoneWidth / 2,
            y = dropZoneY,
            width = dropZoneWidth,
            height = dropZoneHeight,
            card = nil,
        },
        {
            x = screenWidth / 2 + dropZoneSpacing,
            y = dropZoneY,
            width = dropZoneWidth,
            height = dropZoneHeight,
            card = nil,
        }
    }
    
    -- Initialize deck
    self:initializeDeck()
end

function CasinoState:initializeDeck()
    -- Clear existing cards
    self.cards = {}
    self.deck.cards = {}
    
    -- Create all cards from standard deck
    for _, cardData in ipairs(StandardDeck.cards) do
        local card = Card:new(cardData)
        table.insert(self.cards, card)
        table.insert(self.deck.cards, card)
    end
    
    -- Shuffle deck
    math.randomseed(os.time())
    math.random()
    
    local bogo = require('utils.sorts').bogoOnce
    bogo(self.deck.cards)
    
    -- Rebuild cards array
    self.cards = {}
    for _, card in ipairs(self.deck.cards) do
        table.insert(self.cards, card)
    end
    
    CardUtils.align(self.deck)
end

function CasinoState:update(dt)
    self.time = self.time + dt
    
    -- Update cards
    for _, card in ipairs(self.cards) do
        if card.dragging then
            local mx, my = love.mouse.getPosition()
            card.target_transform.x = mx - (card.drag_offset_x or 0)
            card.target_transform.y = my - (card.drag_offset_y or 0)
        end
        CardUtils.move(card, dt)
    end
    
    -- Process sound queue
    for position, sound in ipairs(self.sounds) do
        if sound.delay <= 0 then
            sound.sound:setPitch(sound.pitch)
            love.audio.play(sound.sound)
            table.remove(self.sounds, position)
            sound.sound:setPitch(sound.pitch)
        else
            sound.delay = sound.delay - dt
        end
    end
end

-- Getters for accessing state
function CasinoState:getCanvas()
    return self.canvas
end

function CasinoState:getTime()
    return self.time
end

function CasinoState:getCards()
    return self.cards
end

function CasinoState:getDealtCards()
    return self.dealt_cards
end

function CasinoState:getDeck()
    return self.deck
end

function CasinoState:getDropZones()
    return self.dropZones
end

function CasinoState:getGameIcons()
    return self.gameIcons
end

function CasinoState:isShowingGameButtons()
    return self.showGameButtons
end

function CasinoState:setShowGameButtons(show)
    self.showGameButtons = show
end

function CasinoState:addSound(sound)
    table.insert(self.sounds, sound)
end

function CasinoState:reset()
    -- Reset the casino state when returning to launcher
    self.initialized = false
    self.time = 0
    self.showGameButtons = false
    self.cards = {}
    self.dealt_cards = {}
    self.sounds = {}
    
    -- Clear drop zones
    for _, zone in ipairs(self.dropZones or {}) do
        zone.card = nil
    end
end

return CasinoState