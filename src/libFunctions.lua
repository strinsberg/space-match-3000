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

-- Convert row column value to an x or y value
function functions.ToPix(rowcolumn, size)
    return (rowcolumn - 1) * size
end

return functions