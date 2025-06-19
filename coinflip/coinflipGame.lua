local effects = require('misc.effects')  -- effects module for flashing
local CoinflipGame = {}

local state = "coinflip"  -- Set the initial state to coinflip

local resultText = ""

function CoinflipGame:load()
    love.window.setTitle("Coin Flip")
    self.font = love.graphics.newFont(18)
    resultText = "Press SPACE to flip!"
end

function CoinflipGame:update(dt) end

function CoinflipGame:draw()
    love.graphics.setFont(self.font)
    love.graphics.printf(resultText, 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
end

function love.keyreleased(key)
    if state == "coinflip" and key == "space" then
        effects.flash(0.1)  -- flash effect on flip
        local outcome = love.math.random() < 0.5 and "Heads" or "Tails"
        resultText = "It's " .. outcome .. "!\nPress F to reset, space to insta-flip, or Q to return to launcher."
    end
end

return CoinflipGame
