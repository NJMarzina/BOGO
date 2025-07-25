-- casino/CasinoUI.lua - Manages UI elements like buttons
local CasinoUI = {}

local CasinoState = require('casino.CasinoState')
local Button = require('utils.Button')
local Hands = require('casino.hands')
local GameState = require('utils.GameState')

function CasinoUI:init()
    self.dropZoneGameButtons = {nil, nil, nil}
end

function CasinoUI:draw()
    -- Update and draw dynamic game buttons
    self:updateGameButtons()
    self:drawGameButtons()
end

function CasinoUI:updateGameButtons()
    local dropZones = CasinoState:getDropZones()
    local showGameButtons = CasinoState:isShowingGameButtons()
    
    for i, zone in ipairs(dropZones) do
        self.dropZoneGameButtons[i] = nil
        
        if zone.card and showGameButtons then
            local game = Hands.getGameFromHand({zone.card})[1]
            if game then
                local buttonWidth = zone.width * 0.9
                local buttonHeight = 24
                local buttonX = zone.x + (zone.width - buttonWidth) / 2
                local buttonY = zone.y - buttonHeight - 8
                
                self.dropZoneGameButtons[i] = Button(game.name, buttonX, buttonY, buttonWidth, buttonHeight, function()
                    self:launchGame(game.name)
                end)
            end
        end
    end
end

function CasinoUI:drawGameButtons()
    local mx, my = love.mouse.getPosition()
    
    for i, btn in ipairs(self.dropZoneGameButtons) do
        if btn then
            btn:update(mx, my)
            btn:draw()
        end
    end
end

function CasinoUI:launchGame(gameName)
    print("Launching game:", gameName)
    
    if gameName == "Dice" then
        GameState:switch("dice")
    elseif gameName == "Blackjack" then
        GameState:switch("blackjack")
    elseif gameName == "Coin Flip" then
        GameState:switch("coinflip")
    elseif gameName == "BOGO" then
        GameState:switch("bogo")
    elseif gameName == "Plinko" then
        GameState:switch("plinko")
    elseif gameName == "Dealer's Choice" then
        GameState:switch("dealerschoice")
    end
end

function CasinoUI:getDropZoneGameButtons()
    return self.dropZoneGameButtons
end

return CasinoUI