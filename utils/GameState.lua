local GameState = { current = nil, states = {}, previousState = nil }

function GameState:register(name, mod)
    self.states[name] = mod
end

function GameState:switch(name)
    if self.states[name] and self.states[name].load then
        -- Store the previous state before switching
        if self.current and self.current ~= name then
            self.previousState = self.current
        end
        
        self.states[name]:load()
        self.current = name
    end
end

function GameState:goBack()
    if self.previousState then
        local prev = self.previousState
        self.previousState = nil
        self:switch(prev)
    else
        -- Fallback to launcher
        _G.returnToLauncher()
    end
end

function GameState:update(dt)
    local state = self.states[self.current]
    if state and state.update then state:update(dt) end
end

function GameState:draw()
    local state = self.states[self.current]
    if state and state.draw then state:draw() end
end

function GameState:mousepressed(x, y, button)
    local state = self.states[self.current]
    if state and state.mousepressed then state:mousepressed(x, y, button) end
end

function GameState:mousereleased(x, y, button)
    local state = self.states[self.current]
    if state and state.mousereleased then state:mousereleased(x, y, button) end
end

function GameState:keypressed(key)
    local state = self.states[self.current]
    if state and state.keypressed then state:keypressed(key) end
end

return GameState