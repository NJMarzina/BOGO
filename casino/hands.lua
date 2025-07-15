-- this is a template for game rules and starting of hand logic

-- AVAILABLE HANDS
-- [1] High Card
-- [2] One Pair
-- [3] Trips
-- [3] Straight
-- [3] Flush
-- [3] Straight Flush

-- Hands are only played using 3 cards

-- STIPULATIONS
-- High Card: User can pick any of the cards to play; if they lose played game, they lose 1 life.
-- One Pair: User can play selected game either once or twice, if they lose they DISCARD that card and get 0 points. 
---- A win recycles and gives + round# points.
-- Trips: User can play selected game 3 times, all protected. Win or lose they recycle. Only win points if they win.
-- Straight: User can play up to the 3 selected games, must play at least 1. No protection against discards, but cannot lose lives.
-- Flush: Same as straight.
-- Straight Flush: Same as straight & flush, but full protection against discards. If they win they get 2x points PER WIN.

-- BASIC PSEUDO LOGIC
-- if hand[] has 1 card then
--     play high card game
-- elseif hand[] has 2 cards then
--     check if cards are equal play one pair game
-- elseif hand[] has 3 cards then
--     check if cards are equal play trips game
--     check if cards are same suit play flush game
        --make cards in order
--     check if cards are in sequence play straight game
--     check if cards are in sequence and same suit play straight flush game

local Dice = require('casino.Dice')

local Hands = {}

local function isStraight3(a, b, c)
    local vals = {a, b, c}
    table.sort(vals)

    if vals[2] == vals[1] + 1 and vals[3] == vals[2] + 1 then
        return true
    end

    local hasAce, hasTwo, hasKing = false, false, false
    for _, v in ipairs(vals) do
        if v == 1 then hasAce = true end
        if v == 2 then hasTwo = true end
        if v == 13 then hasKing = true end
    end

    return hasAce and hasTwo and hasKing
end

function Hands.evaluate(hand)
    if #hand == 0 then
        return "No cards submitted"
    elseif #hand == 1 then
        return "High Card: " .. hand[1].name
    elseif #hand == 2 then
        return (hand[1].value == hand[2].value) and "One Pair" or "No Hand"
    elseif #hand == 3 then
        table.sort(hand, function(a, b) return a.value < b.value end)
        local v1, v2, v3 = hand[1].value, hand[2].value, hand[3].value
        local s1, s2, s3 = hand[1].suit, hand[2].suit, hand[3].suit

        local isFlush = (s1 == s2) and (s2 == s3)
        local isStraight = isStraight3(v1, v2, v3)
        local isTrips = (v1 == v2 and v2 == v3)
        local isPair = (v1 == v2 or v2 == v3 or v1 == v3)

        local d13 = Dice:new(13)

        local fibValues = {
            [1] = true,  -- Ace
            [2] = true,
            [3] = true,
            [5] = true,
            [8] = true,
            [13] = true  -- King
        }

        local isFib = fibValues[v1] and fibValues[v2] and fibValues[v3]

        if isFib and isFlush and isStraight then
            return "Straight Flush Fib"
        elseif isFib and isFlush then
            return "Flush Fib"
        elseif isFib and isStraight then
            return "Straight Fib"
        elseif isFib and isTrips then
            return "Trips Fib"
        elseif isFib then
            return "Fib"
        elseif isStraight and isFlush then
            return "Straight Flush"
        elseif isTrips then
            return "Trips"
        elseif isFlush then
            return "Flush"
        elseif isStraight then
            return "Straight (" .. d13:roll() .. ")"
        elseif isPair then
            return "One Pair"
        else
            return "High Card"
        end
    end
end

function Hands.getGameFromHand(hand)
    local count = {}
    for _, card in ipairs(hand) do
        count[card.value] = (count[card.value] or 0) + 1
    end

    local games = {}

    local function addGame(name, requiredValues)
        local total = 0
        for _, val in ipairs(requiredValues) do
            total = total + (count[val] or 0)
        end
        if total > 0 then
            table.insert(games, { name = name, count = total })
        end
    end

    addGame("Dice", {1, 4})
    addGame("Blackjack", {7, 11})
    addGame("Coin Flip", {2, 5})
    addGame("BOGO", {3, 6, 9})
    addGame("Plinko", {10, 12, 13})

    if count[8] then
        table.insert(games, { name = "Dealer's Choice", count = count[8] })
    end

    if #games == 0 then
        return { { name = "No special game", count = 1 } }
    end

    return games
end


return Hands
