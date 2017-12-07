local functions = {}

-- Create an 2d Array with 0 in all cells
function functions.empty2dArray(rows, columns)
    local array = {}
    for i = 1, rows do
        local row = {}
        array[i] = row
        for j = 1, columns do
            row[j] = 0
        end
    end
    return array
end

-- Concatenate 2 arrays together
function functions.mergeArrays(arr1, arr2)
    for _, v in pairs(arr2) do
        arr1[#arr1 + 1] = v
    end
    return arr1
end

-- Display elements of an array
function functions.printArray(array)
    local items = ""
    for _, v in pairs(array) do
        items = string.format("%s %s", items, v)
    end
    print(items)
end


-- Convert seconds as minute:seconds
function functions.secToMin (seconds)
    local t = ""
    local sec = math.floor(seconds % 60)
    local minutes = math.floor(seconds / 60)
    if seconds <= 0 then return "0:00" end
    if sec < 10 then
        t = string.format("%s:0%s", minutes, sec)
    else
        t = string.format("%s:%s", minutes, sec)
    end
    return t
end

return functions