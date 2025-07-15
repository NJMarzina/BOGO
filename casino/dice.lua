Dice = {}

function Dice:new(sides)
    local newObj = { sides = sides or 13 }
    self.__index = self
    return setmetatable(newObj, self)
end

function Dice:roll()
    return math.random(1, self.sides)
end

function Dice:getSides()
    local results = {}
    for i = 1, self.sides do
        table.insert(results, { name = tostring(i), value = i })
    end
    return results
end

return Dice
