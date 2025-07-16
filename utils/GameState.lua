local GameState = { current = nil, states = {} }

function GameState:register(name, mod)
    self.states[name] = mod
end

function GameState:switch(name)
    if self.states[name] and self.states[name].load then
        self.states[name]:load()
        self.current = name
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

return GameState
