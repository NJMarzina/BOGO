Casino = {}
--1
local Card = require('cards.Card')
local StandardDeck = require('cards.StandardDeck')

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

local sounds = {}
local startTime = love.timer.getTime()

local canvas

-- https://www.shadertoy.com/view/XlfGRj
local backgroundShader = love.graphics.newShader([[
    extern vec2 iResolution;
    extern number iTime;
    extern vec2 iMouse;

    const int iterations = 17;
    const float formuparam = 0.53;

    const int volsteps = 20;
    const float stepsize = 0.1;

    const float zoom = 0.800;
    const float tile = 0.850;
    const float speed = 0.010;

    const float brightness = 0.0015;
    const float darkmatter = 0.300;
    const float distfading = 0.730;
    const float saturation = 0.850;

    vec4 effect(vec4 color, Image tex, vec2 tex_coords, vec2 fragCoord) {
        vec2 uv = fragCoord / iResolution - 0.5;
        uv.y *= iResolution.y / iResolution.x;
        vec3 dir = vec3(uv * zoom, 1.0);
        float time = iTime * speed + 0.25;

        float a1 = 0.5;
        float a2 = 0.8;
        mat2 rot1 = mat2(cos(a1), sin(a1), -sin(a1), cos(a1));
        mat2 rot2 = mat2(cos(a2), sin(a2), -sin(a2), cos(a2));
        dir.xz *= rot1;
        dir.xy *= rot2;

        vec3 from = vec3(1.0, 0.5, 0.5);
        from += vec3(time * 2.0, time, -2.0);
        from.xz *= rot1;
        from.xy *= rot2;

        float s = 0.1, fade = 1.0;
        vec3 v = vec3(0.0);
        for (int r = 0; r < volsteps; r++) {
            vec3 p = from + s * dir * 0.5;
            p = abs(vec3(tile) - mod(p, vec3(tile * 2.0)));
            float pa = 0.0, a = 0.0;
            for (int i = 0; i < iterations; i++) {
                p = abs(p) / dot(p, p) - formuparam;
                a += abs(length(p) - pa);
                pa = length(p);
            }
            float dm = max(0.0, darkmatter - a * a * 0.001);
            a *= a * a;
            if (r > 6) fade *= 1.0 - dm;
            v += fade;
            v += vec3(s, s * s, s * s * s * s) * a * brightness * fade;
            fade *= distfading;
            s += stepsize;
        }
        v = mix(vec3(length(v)), v, saturation);
        return vec4(v * 0.01, 1.0);
    }
]])

local deck = {
    cards = {},
    transform = {
        x = screenWidth / 2 - 100,
        y = screenHeight / 2 - 150,
        width = 140,
        height = 224
    }
}

local dropZoneWidth = 140 * 0.85
local dropZoneHeight = 224 * 0.75  -- shorter
local dropZoneSpacing = 90         -- more spacing

local dropZoneY = screenHeight - dropZoneHeight - 40

local dropZones = {
    {
        x = screenWidth / 2 - dropZoneWidth - dropZoneSpacing,
        y = dropZoneY,
        width = dropZoneWidth,
        height = dropZoneHeight,
    },
    {
        x = screenWidth / 2 - dropZoneWidth / 2,
        y = dropZoneY,
        width = dropZoneWidth,
        height = dropZoneHeight,
    },
    {
        x = screenWidth / 2 + dropZoneSpacing,
        y = dropZoneY,
        width = dropZoneWidth,
        height = dropZoneHeight,
    }
}

local cards = {}

local function align(deck)
    local deck_height = 10 / #deck.cards
    for position, card in ipairs(deck.cards) do
        if not card.dragging then
            card.target_transform.x = deck.transform.x - deck_height * (position - 1)
            card.target_transform.y = deck.transform.y + deck_height * (position - 1)
        end
    end
end

local function move(card, dt)
    local momentum = 0.75
    local max_velocity = 10
    if (card.target_transform.x ~= card.transform.x or card.velocity.x ~= 0) or
       (card.target_transform.y ~= card.transform.y or card.velocity.y ~= 0) then
        card.velocity.x = momentum * card.velocity.x +
            (1 - momentum) * (card.target_transform.x - card.transform.x) * 30 * dt
        card.velocity.y = momentum * card.velocity.y +
            (1 - momentum) * (card.target_transform.y - card.transform.y) * 30 * dt
        card.transform.x = card.transform.x + card.velocity.x
        card.transform.y = card.transform.y + card.velocity.y

        local velocity = math.sqrt(card.velocity.x ^ 2 + card.velocity.y ^ 2)
        if velocity > max_velocity then
            card.velocity.x = max_velocity * card.velocity.x / velocity
            card.velocity.y = max_velocity * card.velocity.y / velocity
        end
    end
end

local function resetDeck()
    for _, card in ipairs(cards) do
        card.is_on_deck = true
    end

    deck.cards = {}
    for _, card in ipairs(cards) do
        table.insert(deck.cards, card)
    end

    align(deck)
end

local function shuffleDeck()
    resetDeck()

    local bogo = require('utils.sorts').bogoOnce
    bogo(deck.cards)

    cards = {}
    for _, card in ipairs(deck.cards) do
        table.insert(cards, card)
    end

    align(deck)
end

local function dealSixCards()
    local num_to_deal = math.min(6, #deck.cards)

    for i = 1, num_to_deal do
        local card = deck.cards[#deck.cards - i + 1]  -- top card
        card.is_on_deck = false
        for j = #deck.cards, 1, -1 do
            if deck.cards[j] == card then
                table.remove(deck.cards, j)
                break
            end
        end
    end

    local left_x = 50
    local right_x = screenWidth - 190 -- card width + margin
    local start_y = screenHeight / 2 - 100
    local spacing = 80

    local dealt_cards = {}
    for _, card in ipairs(cards) do
        if not card.is_on_deck then
            table.insert(dealt_cards, card)
        end
    end

    for i, card in ipairs(dealt_cards) do
        card.target_transform.y = start_y + spacing * ((i - 1) % 3)
        if i <= 3 then
            card.target_transform.x = left_x
        else
            card.target_transform.x = right_x
        end
    end
end

function Casino:load()
    love.window.setTitle('Casino')

    Casino.time = 0

    canvas = love.graphics.newCanvas(screenWidth, screenHeight, { type = '2d', readable = true })
    cards = {}
    deck.cards = {}

    for _, cardData in ipairs(StandardDeck.cards) do
        local card = Card:new(cardData)
        table.insert(cards, card)
        table.insert(deck.cards, card)
    end

    math.randomseed(os.time())
    math.random()

    local bogo = require('utils.sorts').bogoOnce
    bogo(deck.cards)

    cards = {}
    for _, card in ipairs(deck.cards) do
        table.insert(cards, card)
    end

    align(deck)
end

function Casino:update(dt)
    self.time = self.time + dt

    backgroundShader:send("iTime", self.time)
    backgroundShader:send("iResolution", {screenWidth, screenHeight})
    --backgroundShader:send("iMouse", {love.mouse.getX(), love.mouse.getY()})


    for _, card in ipairs(cards) do
        if card.dragging then
            local mx, my = love.mouse.getPosition()
            card.target_transform.x = mx - (card.drag_offset_x or 0)
            card.target_transform.y = my - (card.drag_offset_y or 0)
        end

        move(card, dt)
    end

    for position, sound in ipairs(sounds) do
        if sound.delay <= 0 then
            sound.sound:setPitch(sound.pitch)
            love.audio.play(sound.sound)
            table.remove(sounds, position)
            sound.sound:setPitch(sound.pitch)
        else
            sound.delay = sound.delay - dt
        end
    end
end

function Casino:draw()
    love.graphics.setCanvas(canvas)

    love.graphics.setShader(backgroundShader)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
    love.graphics.setShader()


    -- Draw drop zones
    for _, zone in ipairs(dropZones) do
        love.graphics.setColor(0.2, 0.5, 0.2, 0.15) -- translucent fill
        love.graphics.rectangle("fill", zone.x, zone.y, zone.width, zone.height, 10, 10)

        love.graphics.setColor(0, 0, 0, 0.9) -- black border
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", zone.x, zone.y, zone.width, zone.height, 10, 10)
    end

    -- Draw control buttons centered above middle drop zone
    local centerX = dropZones[2].x + dropZones[2].width / 2
    local buttonY = dropZones[2].y - 40

    -- Red deal button (left)
    love.graphics.setColor(0.9, 0.1, 0.1, 1)
    love.graphics.circle("fill", centerX - 40, buttonY, 15)

    -- Blue reset button (center)
    love.graphics.setColor(0.015, 0.647, 0.898, 1)
    love.graphics.circle("fill", centerX, buttonY, 15)

    -- Green shuffle button (right)
    love.graphics.setColor(0.2, 0.8, 0.3, 1)
    love.graphics.circle("fill", centerX + 40, buttonY, 15)

    -- Draw all cards
    love.graphics.setColor(1, 1, 1, 1)
    for _, card in ipairs(cards) do
        card:draw()
    end

    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(canvas, 0, 0)
end


function Casino:mousepressed(x, y)
    for i = #cards, 1, -1 do
        local card = cards[i]
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

    -- Red deal button (left)
    local centerX = dropZones[2].x + dropZones[2].width / 2
    local buttonY = dropZones[2].y - 40

    if x > centerX - 55 and x < centerX - 25 and y > buttonY - 15 and y < buttonY + 15 then
        shuffleDeck()
        dealSixCards()
    end

    -- Blue reset button (center)
    if x > centerX - 15 and x < centerX + 15 and y > buttonY - 15 and y < buttonY + 15 then
        resetDeck()
    end

    -- Green shuffle button (right)
    if x > centerX + 25 and x < centerX + 55 and y > buttonY - 15 and y < buttonY + 15 then
        shuffleDeck()
    end
end


function Casino:mousereleased()
    for i = #cards, 1, -1 do
        local card = cards[i]
        if card.dragging then
            card.dragging = false
            if card.is_on_deck then
                card.is_on_deck = false
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

return Casino
