local CardUtils = require('utils.CardUtils')

StandardDeck = {}

StandardDeck.cards = {
    { name = "Ace of Spades", value = 1, suit = "Spades", image = "assets/images/ace_of_spades.png" },
    { name = "2 of Spades", value = 2, suit = "Spades", image = "assets/images/2_of_spades.png" },
    { name = "3 of Spades", value = 3, suit = "Spades", image = "assets/images/3_of_spades.png" },
    { name = "4 of Spades", value = 4, suit = "Spades", image = "assets/images/4_of_spades.png" },
    { name = "5 of Spades", value = 5, suit = "Spades", image = "assets/images/5_of_spades.png" },
    { name = "6 of Spades", value = 6, suit = "Spades", image = "assets/images/6_of_spades.png" },
    { name = "7 of Spades", value = 7, suit = "Spades", image = "assets/images/7_of_spades.png" },
    { name = "8 of Spades", value = 8, suit = "Spades", image = "assets/images/8_of_spades.png" },
    { name = "9 of Spades", value = 9, suit = "Spades", image = "assets/images/9_of_spades.png" },
    { name = "10 of Spades", value = 10, suit = "Spades", image = "assets/images/10_of_spades.png" },
    { name = "Jack of Spades", value = 11, suit = "Spades", image = "assets/images/jack_of_spades.png" },
    { name = "Queen of Spades", value = 12, suit = "Spades", image = "assets/images/queen_of_spades.png" },
    { name = "King of Spades", value = 13, suit = "Spades", image = "assets/images/king_of_spades.png" },

    { name = "Ace of Hearts", value = 1, suit = "Hearts" , image = "assets/images/ace_of_hearts.png" },
    { name = "2 of Hearts", value = 2, suit = "Hearts", image = "assets/images/2_of_hearts.png" },
    { name = "3 of Hearts", value = 3, suit = "Hearts", image = "assets/images/3_of_hearts.png" },
    { name = "4 of Hearts", value = 4, suit = "Hearts", image = "assets/images/4_of_hearts.png" },
    { name = "5 of Hearts", value = 5, suit = "Hearts", image = "assets/images/5_of_hearts.png" },
    { name = "6 of Hearts", value = 6, suit = "Hearts", image = "assets/images/6_of_hearts.png" },
    { name = "7 of Hearts", value = 7, suit = "Hearts", image = "assets/images/7_of_hearts.png" },
    { name = "8 of Hearts", value = 8, suit = "Hearts", image = "assets/images/8_of_hearts.png" },
    { name = "9 of Hearts", value = 9, suit = "Hearts", image = "assets/images/9_of_hearts.png" },
    { name = "10 of Hearts", value = 10, suit = "Hearts", image = "assets/images/10_of_hearts.png" },
    { name = "Jack of Hearts", value = 11, suit = "Hearts", image = "assets/images/jack_of_hearts.png" },
    { name = "Queen of Hearts", value = 12, suit = "Hearts", image = "assets/images/queen_of_hearts.png" },
    { name = "King of Hearts", value = 13, suit = "Hearts", image = "assets/images/king_of_hearts.png" },

    { name = "Ace of Diamonds", value = 1, suit = "Diamonds", image = "assets/images/ace_of_diamonds.png" },
    { name = "2 of Diamonds", value = 2, suit = "Diamonds", image = "assets/images/2_of_diamonds.png" },
    { name = "3 of Diamonds", value = 3, suit = "Diamonds", image = "assets/images/3_of_diamonds.png" },
    { name = "4 of Diamonds", value = 4, suit = "Diamonds", image = "assets/images/4_of_diamonds.png" },
    { name = "5 of Diamonds", value = 5, suit = "Diamonds", image = "assets/images/5_of_diamonds.png" },
    { name = "6 of Diamonds", value = 6, suit = "Diamonds", image = "assets/images/6_of_diamonds.png" },
    { name = "7 of Diamonds", value = 7, suit = "Diamonds", image = "assets/images/7_of_diamonds.png" },
    { name = "8 of Diamonds", value = 8, suit = "Diamonds", image = "assets/images/8_of_diamonds.png" },
    { name = "9 of Diamonds", value = 9, suit = "Diamonds", image = "assets/images/9_of_diamonds.png" },
    { name = "10 of Diamonds", value = 10, suit = "Diamonds", image = "assets/images/10_of_diamonds.png" },
    { name = "Jack of Diamonds", value = 11, suit = "Diamonds", image = "assets/images/jack_of_diamonds.png" },
    { name = "Queen of Diamonds", value = 12, suit = "Diamonds", image = "assets/images/queen_of_diamonds.png" },
    { name = "King of Diamonds", value = 13, suit = "Diamonds", image = "assets/images/king_of_diamonds.png" },

    { name = "Ace of Clubs", value = 1, suit = "Clubs", image = "assets/images/ace_of_clubs.png" },
    { name = "2 of Clubs", value = 2, suit = "Clubs", image = "assets/images/2_of_clubs.png" },
    { name = "3 of Clubs", value = 3, suit = "Clubs", image = "assets/images/3_of_clubs.png" },
    { name = "4 of Clubs", value = 4, suit = "Clubs", image = "assets/images/4_of_clubs.png" },
    { name = "5 of Clubs", value = 5, suit = "Clubs", image = "assets/images/5_of_clubs.png" },
    { name = "6 of Clubs", value = 6, suit = "Clubs", image = "assets/images/6_of_clubs.png" },
    { name = "7 of Clubs", value = 7, suit = "Clubs", image = "assets/images/7_of_clubs.png" },
    { name = "8 of Clubs", value = 8, suit = "Clubs", image = "assets/images/8_of_clubs.png" },
    { name = "9 of Clubs", value = 9, suit = "Clubs", image = "assets/images/9_of_clubs.png" },
    { name = "10 of Clubs", value = 10, suit = "Clubs", image = "assets/images/10_of_clubs.png" },
    { name = "Jack of Clubs", value = 11, suit = "Clubs", image = "assets/images/jack_of_clubs.png" },
    { name = "Queen of Clubs", value = 12, suit = "Clubs", image = "assets/images/queen_of_clubs.png" },
    { name = "King of Clubs", value = 13, suit = "Clubs", image = "assets/images/king_of_clubs.png" }

}

function StandardDeck:load()

end

function StandardDeck:update(dt)

end

function StandardDeck:draw()

end

function StandardDeck.reset(deck, cards, dropZones)
    for _, card in ipairs(cards) do
        card.is_on_deck = true
    end

    deck.cards = {}
    for _, card in ipairs(cards) do
        table.insert(deck.cards, card)
    end

    for _, zone in ipairs(dropZones) do
        zone.card = nil
    end

    CardUtils.align(deck)
end

function StandardDeck.shuffle(deck, cards, dropZones)
    StandardDeck.reset(deck, cards, dropZones)

    local bogo = require('utils.sorts').bogoOnce
    bogo(deck.cards)

    for i = #cards, 1, -1 do
        table.remove(cards, i)
    end

    for _, card in ipairs(deck.cards) do
        table.insert(cards, card)
    end

    CardUtils.align(deck)

    return cards
end

function StandardDeck.dealSix(deck, cards, screenWidth, screenHeight)
    local num_to_deal = math.min(6, #deck.cards)
    local dealt_cards = {}

    for i = 1, num_to_deal do
        local card = table.remove(deck.cards)
        card.is_on_deck = false
        table.insert(dealt_cards, card)
    end

    local left_x = 50
    local right_x = screenWidth - 190
    local start_y = screenHeight / 2 - 100
    local spacing = 80

    for i, card in ipairs(dealt_cards) do
        card.target_transform.y = start_y + spacing * ((i - 1) % 3)
        if i <= 3 then
            card.target_transform.x = left_x
        else
            card.target_transform.x = right_x
        end
    end

    return dealt_cards
end

function StandardDeck.reclaimLooseCards(deck, cards, dropZones)
    -- Build a set of cards that are already placed in drop zones
    local placed = {}
    for _, zone in ipairs(dropZones) do
        if zone.card then
            placed[zone.card] = true
        end
    end

    -- Clear the deck and rebuild it with all unplaced cards
    deck.cards = {}
    for _, card in ipairs(cards) do
        if not placed[card] then
            card.is_on_deck = true
            table.insert(deck.cards, card)
        end
    end
end


return StandardDeck