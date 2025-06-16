local effects = {}

local flashTimer    = 0
local flashDuration = 0

function effects.flash(duration)
    flashDuration = duration or 0.1
    flashTimer    = flashDuration
end

function effects.update(dt)
    if flashTimer > 0 then
        flashTimer = flashTimer - dt
    end
end

function effects.draw()
    if flashTimer > 0 then
        local alpha = flashTimer / flashDuration
        love.graphics.setColor(1, 1, 1, alpha)
        love.graphics.rectangle("fill", 0, 0,
                                love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)      -- reset
    end
end

return effects
