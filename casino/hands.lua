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