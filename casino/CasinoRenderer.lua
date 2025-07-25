-- casino/CasinoRenderer.lua - Handles all rendering logic
local CasinoRenderer = {}

local CasinoState = require('casino.CasinoState')
local BackgroundShader = require('casino.BackgroundShader')
local Hands = require('casino.hands')

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

function CasinoRenderer:init()
    BackgroundShader:init()
end

function CasinoRenderer:update(dt)
    BackgroundShader:update(CasinoState:getTime())
end

function CasinoRenderer:draw()
    local canvas = CasinoState:getCanvas()
    love.graphics.setCanvas(canvas)
    
    -- Draw background shader
    BackgroundShader:draw()
    
    -- Draw drop zones
    self:drawDropZones()
    
    -- Draw control buttons
    self:drawControlButtons()
    
    -- Draw submit button
    self:drawSubmitButton()
    
    -- Draw game icons
    self:drawGameIcons()
    
    -- Draw cards
    self:drawCards()
    
    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(canvas, 0, 0)
end

function CasinoRenderer:drawDropZones()
    local dropZones = CasinoState:getDropZones()
    
    for _, zone in ipairs(dropZones) do
        -- Translucent fill
        love.graphics.setColor(0.2, 0.5, 0.2, 0.15)
        love.graphics.rectangle("fill", zone.x, zone.y, zone.width, zone.height, 10, 10)
        
        -- Black border
        love.graphics.setColor(0, 0, 0, 0.9)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", zone.x, zone.y, zone.width, zone.height, 10, 10)
        
        -- Gold indicator if card present
        if zone.card then
            love.graphics.setColor(1, 0.84, 0, 1)
            local barHeight = 8
            love.graphics.rectangle("fill", zone.x, zone.y + zone.height + 4, zone.width, barHeight, 4, 4)
        end
    end
end

function CasinoRenderer:drawControlButtons()
    local dropZones = CasinoState:getDropZones()
    local centerX = dropZones[2].x + dropZones[2].width / 2
    local buttonY = dropZones[2].y - 90
    
    -- Red deal button (left)
    love.graphics.setColor(0.9, 0.1, 0.1, 1)
    love.graphics.circle("fill", centerX - 40, buttonY, 15)
    
    -- Blue reset button (center)
    love.graphics.setColor(0.015, 0.647, 0.898, 1)
    love.graphics.circle("fill", centerX, buttonY, 15)
    
    -- Green shuffle button (right)
    love.graphics.setColor(0.2, 0.8, 0.3, 1)
    love.graphics.circle("fill", centerX + 40, buttonY, 15)
end

function CasinoRenderer:drawSubmitButton()
    local dropZones = CasinoState:getDropZones()
    local submitX = dropZones[3].x + dropZones[3].width + 30
    local submitY = dropZones[3].y + dropZones[3].height / 2 - 15
    local submitWidth = 80
    local submitHeight = 30
    
    -- Store button bounds for input handling
    Casino.submitButton = { x = submitX, y = submitY, w = submitWidth, h = submitHeight }
    
    love.graphics.setColor(0.3, 0.7, 0.9, 1)
    love.graphics.rectangle("fill", submitX, submitY, submitWidth, submitHeight, 8)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("SUBMIT", submitX, submitY + 7, submitWidth, "center")
end

function CasinoRenderer:drawGameIcons()
    local dropZones = CasinoState:getDropZones()
    local gameIcons = CasinoState:getGameIcons()
    
    -- Build hand from drop zones
    local hand = {}
    for _, zone in ipairs(dropZones) do
        if zone.card then
            table.insert(hand, zone.card)
        end
    end
    
    -- Extract ordered game list based on card order
    local gameList = {}
    local gameCounts = {}
    local inserted = {}
    
    for _, card in ipairs(hand) do
        local gamesForCard = Hands.getGameFromHand({card})
        for _, game in ipairs(gamesForCard) do
            local name = game.name
            gameCounts[name] = (gameCounts[name] or 0) + 1
            if not inserted[name] then
                table.insert(gameList, name)
                inserted[name] = true
            end
        end
    end
    
    -- Draw game icons fixed on top left
    local baseX = 50
    local baseY = 50
    local iconSpacing = 400
    local drawIndex = 0
    
    for _, name in ipairs(gameList) do
        local image = gameIcons[name]
        if image then
            local imgWidth = image:getWidth()
            local imgHeight = image:getHeight()
            local scaleX = 200 / imgWidth
            local scaleY = 200 / imgHeight
            
            for _ = 1, gameCounts[name] do
                local x = baseX + drawIndex * iconSpacing
                local y = baseY
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.draw(image, x, y, 0, scaleX, scaleY)
                drawIndex = drawIndex + 1
            end
        end
    end
end

function CasinoRenderer:drawCards()
    local deck = CasinoState:getDeck()
    local dealt_cards = CasinoState:getDealtCards()
    
    love.graphics.setColor(1, 1, 1, 1)
    
    -- Draw deck cards (back to front)
    for i = #deck.cards, 1, -1 do
        deck.cards[i]:draw()
    end
    
    -- Draw dealt cards
    for _, card in ipairs(dealt_cards) do
        card:draw()
    end
end

return CasinoRenderer