-- casino/CasinoLogic.lua - Handles game logic and evaluation
local CasinoLogic = {}

local CasinoState = require('casino.CasinoState')
local Hands = require('casino.hands')

function CasinoLogic:init()
    -- Game logic system is ready
end

function CasinoLogic:update(dt)
    -- Handle any game logic updates that need to happen each frame
    -- Currently most logic is event-driven, so this can be empty for now
end

function CasinoLogic:evaluateHand(hand)
    local result = Hands.evaluate(hand)
    local games = Hands.getGameFromHand(hand)
    
    print("Hand Type: " .. result)
    print("Playable Games:")
    for _, game in ipairs(games) do
        print("Game:", game.name, "x" .. game.count)
    end
    
    return {
        handType = result,
        games = games
    }
end

function CasinoLogic:getAvailableGames(hand)
    return Hands.getGameFromHand(hand)
end

function CasinoLogic:validateHand(hand)
    -- Add any hand validation logic here
    if #hand == 0 then
        return false, "No cards in hand"
    end
    
    if #hand > 3 then
        return false, "Too many cards in hand"
    end
    
    return true, "Valid hand"
end

return CasinoLogic