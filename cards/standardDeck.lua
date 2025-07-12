StandardDeck = {}

-- create array of card objects
StandardDeck.cards = {
    { name = "Ace of Spades", value = 1, suit = "Spades", image = "assets/images/ace_of_spades.png" },
    { name = "2 of Spades", value = 2, suit = "Spades" image = "assets/images/2_of_spades.png" },
    { name = "3 of Spades", value = 3, suit = "Spades", image = "assets/images/3_of_spades.png" },
    { name = "4 of Spades", value = 4, suit = "Spades", image = "assets/images/4_of_spades.png" },
    { name = "5 of Spades", value = 5, suit = "Spades", image = "assets/images/5_of_spades.png" },
    { name = "6 of Spades", value = 6, suit = "Spades", image = "assets/images/6_of_spades.png" },
    { name = "7 of Spades", value = 7, suit = "Spades", image = "assets/images/7_of_spades.png" },
    { name = "8 of Spades", value = 8, suit = "Spades", image = "assets/images/8_of_spades.png" },
    { name = "9 of Spades", value = 9, suit = "Spades", image = "assets/images/9_of_spades.png" },
    { name = "10 of Spades", value = 10, suit = "Spades", image = "assets/images/10_of_spades.png" },
    { name = "Jack of Spades", value = 10, suit = "Spades", image = "assets/images/jack_of_spades.png" },
    { name = "Queen of Spades", value = 10, suit = "Spades", image = "assets/images/queen_of_spades.png" },
    { name = "King of Spades", value = 10, suit = "Spades", image = "assets/images/king_of_spades.png" },

    { name = "Ace of Hearts", value = 1, suit = "Hearts" , image = "assets/images/ace_of_hearts.png" },
    { name = "2 of Hearts", value = 2, suit = "Hearts" image = "assets/images/2_of_hearts.png" },
    { name = "3 of Hearts", value = 3, suit = "Hearts" image = "assets/images/3_of_hearts.png" },
    { name = "4 of Hearts", value = 4, suit = "Hearts" image = "assets/images/4_of_hearts.png" },
    { name = "5 of Hearts", value = 5, suit = "Hearts" image = "assets/images/5_of_hearts.png" },
    { name = "6 of Hearts", value = 6, suit = "Hearts" image = "assets/images/6_of_hearts.png" },
    { name = "7 of Hearts", value = 7, suit = "Hearts" image = "assets/images/7_of_hearts.png" },
    { name = "8 of Hearts", value = 8, suit = "Hearts" image = "assets/images/8_of_hearts.png" },
    { name = "9 of Hearts", value = 9, suit = "Hearts" image = "assets/images/9_of_hearts.png" },
    { name = "10 of Hearts", value = 10, suit = "Hearts" image = "assets/images/10_of_hearts.png" },
    { name = "Jack of Hearts", value = 10, suit = "Hearts", image = "assets/images/jack_of_hearts.png" },
    { name = "Queen of Hearts", value = 10, suit = "Hearts", image = "assets/images/queen_of_hearts.png" },
    { name = "King of Hearts", value = 10, suit = "Hearts", image = "assets/images/king_of_hearts.png" },

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
    { name = "Jack of Diamonds", value = 10, suit = "Diamonds", image = "assets/images/jack_of_diamonds.png" },
    { name = "Queen of Diamonds", value = 10, suit = "Diamonds", image = "assets/images/queen_of_diamonds.png" },
    { name = "King of Diamonds", value = 10, suit = "Diamonds", image = "assets/images/king_of_diamonds.png" },

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
    { name = "Jack of Clubs", value = 10, suit = "Clubs", image = "assets/images/jack_of_clubs.png" },
    { name = "Queen of Clubs", value = 10, suit = "Clubs", image = "assets/images/queen_of_clubs.png" },
    { name = "King of Clubs", value = 10, suit = "Clubs", image = "assets/images/king_of_clubs.png" }

}

function StandardDeck:load()

end

function StandardDeck:update(dt)

end

function StandardDeck:draw()

end

return StandardDeck