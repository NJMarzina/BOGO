--eg 1

salary = 1000
food = 300
rent = 400
investment = 600
result = salary - (food + rent + investment) -- this calculates our financial situation

print(result)

--eg 2
OurAwesomeTable = {}
OurAwesomeTable.coolVariable = 10
OurAwesomeTable.coolTable = {}

NewTable = { newVariable = 15, niceTable = {} }

money = 150
if money > 100  and money < 200 then
    print(money)
elseif money < 100 then
    print("You are poor")
else
    print("You are rich")
end

--eg 3
function checkWealth()
    if result < 0 then
        print("You are in debt!")
    elseif result == 0 then
        print("You are breaking even.")
    else
        print("You have a surplus!")
    end
end

--eg 4
function love.load()    --triggers when game started , data and assets

end

function love.update(dt) -- program actual game logic. handled/triggered 1 time per frame...

    --dt = delta time, the time since the last frame
    --dt is used to make sure the game runs at the same speed on all computers
    --Speed(100)*dt = y
    --y*100(FPS) = pixels moved
end

function love.draw() -- used to display graphics

end