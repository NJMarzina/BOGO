local effects = require('misc.effects')
local CoinflipGame = {}

local state = "coinflip"

CoinflipGame.coinHeads = love.graphics.newImage("assets/images/coin_heads.png")
CoinflipGame.coinTails = love.graphics.newImage("assets/images/coin_tails.png")
CoinflipGame.currentCoin = nil

local resultText = ""

function CoinflipGame:load()
    love.window.setTitle("Coin Flip")
    self.font = love.graphics.newFont(18)
    resultText = "Press SPACE to flip!"
end

function CoinflipGame:update(dt) end

function CoinflipGame:draw()
    love.graphics.setFont(self.font)
    love.graphics.printf(resultText, 0, love.graphics.getHeight()/2 + 80, love.graphics.getWidth(), "center")
    if self.currentCoin then
        love.graphics.draw(
            self.currentCoin,
            love.graphics.getWidth()/2 - 100,
            love.graphics.getHeight()/2 - 100 - 40,
            0, 200 / self.currentCoin:getWidth(), 200 / self.currentCoin:getHeight())
    end
end

function love.keyreleased(key)
    if state == "coinflip" and key == "space" then
        effects.flash(0.1)
        local heads = love.math.random() < 0.5
        CoinflipGame.currentCoin = heads and CoinflipGame.coinHeads or CoinflipGame.coinTails
        resultText = "It's " .. (heads and "Heads" or "Tails") .. "!\nPress F to reset, space to insta flip, or Q to return to launcher."
    end
end

return CoinflipGame
