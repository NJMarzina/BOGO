local sort = {}

function sort.bubble(arr)
    local n = #arr
    for i = 1, n do
        for j = 1, n - i do
            if arr[j] > arr[j + 1] then
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
            end
        end
    end
    return arr
end

function sort.selection(arr)
    local n = #arr
    for i = 1, n - 1 do
        local minIndex = i
        for j = i + 1, n do
            if arr[j] < arr[minIndex] then
                minIndex = j
            end
        end
        arr[i], arr[minIndex] = arr[minIndex], arr[i]
    end
    return arr
end

function sort.insertion(arr)
    local n = #arr
    for i = 2, n do
        local key = arr[i]
        local j = i - 1
        while j >= 1 and arr[j] > key do
            arr[j + 1] = arr[j]
            j = j - 1
        end
        arr[j + 1] = key
    end
    return arr
end

function sort.merge(arr)
    if #arr < 2 then
        return arr
    end
    local mid = math.floor(#arr / 2)
    local left = sort.merge({table.unpack(arr, 1, mid)})
    local right = sort.merge({table.unpack(arr, mid + 1)})
    
    return sort.mergeSorted(left, right)
end

function sort.bogo(arr)
    local function isSorted(arr)
        for i = 1, #arr - 1 do
            if arr[i] > arr[i + 1] then
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