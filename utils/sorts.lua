local sort = {}

function sort.bogoOnce(arr)
    for i = #arr, 2, -1 do
        local j = math.random(i)
        arr[i], arr[j] = arr[j], arr[i]
    end
    return arr
end

function sort.bogo(arr, comparator)
    local function isSorted(arr)
        for i = 1, #arr - 1 do
            if comparator and not comparator(arr[i], arr[i + 1]) then
                return false
            elseif not comparator and arr[i] > arr[i + 1] then
                return false
            end
        end
        return true
    end

    while not isSorted(arr) do
        for i = #arr, 2, -1 do
            local j = math.random(i)
            arr[i], arr[j] = arr[j], arr[i]
        end
    end
    return arr
end

return sort