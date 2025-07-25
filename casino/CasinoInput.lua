-- casino/CasinoInput.lua - Handles all mouse and keyboard input
local CasinoInput = {}

local CasinoState = require('casino.CasinoState')
local CasinoUI = require('casino.CasinoUI')
local StandardDeck = require('cards.StandardDeck')

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

function CasinoInput:init()
    -- Input system is ready
end

function CasinoInput:mousepressed(x, y)
    -- Handle card dragging
    self:handleCardDragging(x, y)
    
    -- Handle control buttons
    self:handleControlButtons(x, y)
    
    -- Handle submit button
    self:handleSubmitButton(x, y)
    
    -- Handle dynamic game buttons
    self:handleGameButtons(x, y)
end

function CasinoInput:mousereleased(x, y)
    self:handleCardRelease(x, y)
end

function CasinoInput:handleCardDragging(x, y)
    local dealt_cards = CasinoState:getDealtCards()
    
    -- Check dealt cards for dragging (top to bottom for proper z-order)
    for i = #dealt_cards, 1, -1 do
        local card = dealt_cards[i]
        if x > card.transform.x
            and x < card.transform.x + card.transform.width
            and y > card.transform.y
            and y < card.transform.y + card.transform.height
        then
            card.dragging = true
            card.drag_offset_x = x - card.transform.x
            card.drag_offset_y = y - card.transform.y
            break
        end
    end
end

function CasinoInput:handleControlButtons(x, y)
    local dropZones = CasinoState:getDropZones()
    local cards = CasinoState:getCards()
    local deck = CasinoState:getDeck()
    local dealt_cards = CasinoState:getDealtCards()
    
    local centerX = dropZones[2].x + dropZones[2].width / 2
    local buttonY = dropZones[2].y - 90
    
    -- Red deal button (left)
    if x > centerX - 55 and x < centerX - 25 and y > buttonY - 15 and y < buttonY + 15 then
        StandardDeck.reset(deck, cards, dropZones)
        StandardDeck.shuffle(deck, cards, dropZones)
        
        local newDealtCards = StandardDeck.dealSix(deck, cards, screenWidth, screenHeight)
        -- Update dealt_cards in state
        for i = #dealt_cards, 1, -1 do
            dealt_cards[i] = nil
        end
        for _, card in ipairs(newDealtCards) do
            table.insert(dealt_cards, card)
        end
    end
    
    -- Blue reset button (center)
    if x > centerX - 15 and x < centerX + 15 and y > buttonY - 15 and y < buttonY + 15 then
        StandardDeck.reset(deck, cards, dropZones)
        -- Clear dealt cards
        for i = #dealt_cards, 1, -1 do
            dealt_cards[i] = nil
        end
    end
    
    -- Green shuffle button (right)
    if x > centerX + 25 and x < centerX + 55 and y > buttonY - 15 and y < buttonY + 15 then
        -- Return dealt cards to deck
        for _, card in ipairs(dealt_cards) do
            card.is_on_deck = true
            table.insert(deck.cards, card)
        end
        
        -- Clear dealt cards
        for i = #dealt_cards, 1, -1 do
            dealt_cards[i] = nil
        end
        
        StandardDeck.reclaimLooseCards(deck, cards, dropZones)
        StandardDeck.shuffle(deck, cards, dropZones)
    end
end

function CasinoInput:handleSubmitButton(x, y)
    local dropZones = CasinoState:getDropZones()
    
    if Casino.submitButton then
        local b = Casino.submitButton
        if x > b.x and x < b.x + b.w and y > b.y and y < b.y + b.h then
            local hand = {}
            for _, zone in ipairs(dropZones) do
                if zone.card then table.insert(hand, zone.card) end
            end
            Casino:evaluateHand(hand)
            CasinoState:setShowGameButtons(true)
        end
    end
end

function CasinoInput:handleGameButtons(x, y)
    local dropZoneGameButtons = CasinoUI:getDropZoneGameButtons()
    
    -- Check dynamic buttons for games in drop zones
    for _, btn in ipairs(dropZoneGameButtons) do
        if btn and btn:checkClick(x, y) then 
            return 
        end
    end
end

function CasinoInput:handleCardRelease(x, y)
    local cards = CasinoState:getCards()
    local dropZones = CasinoState:getDropZones()
    
    for i = #cards, 1, -1 do
        local card = cards[i]
        if card.dragging then
            card.dragging = false
            
            -- Remove card from any drop zone before placing it in a new one
            for _, zone in ipairs(dropZones) do
                if zone.card == card then
                    zone.card = nil
                end
            end
            
            -- Check if card is dropped inside a drop zone
            local placedInZone = false
            for _, zone in ipairs(dropZones) do
                if not zone.card and
                   card.transform.x + card.transform.width / 2 > zone.x and
                   card.transform.x + card.transform.width / 2 < zone.x + zone.width and
                   card.transform.y + card.transform.height / 2 > zone.y and
                   card.transform.y + card.transform.height / 2 < zone.y + zone.height then
                    zone.card = card
                    -- Center card inside zone (scale if needed)
                    card.target_transform.width = zone.width
                    card.target_transform.height = zone.height
                    card.target_transform.x = zone.x * 1.02
                    card.target_transform.y = zone.y * 1.02
                    placedInZone = true
                    break
                end
            end
            
            if not placedInZone then
                -- If card not placed in zone, hide game buttons
                CasinoState:setShowGameButtons(false)
            end
            
            -- Remove card from deck if it was on deck
            if card.is_on_deck then
                card.is_on_deck = false
                local deck = CasinoState:getDeck()
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

return CasinoInput