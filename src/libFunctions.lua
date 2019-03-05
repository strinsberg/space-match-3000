---------------------------------------------------------------------
-- A library of helpful functions.
---------------------------------------------------------------------
local M = {}

-- Create an 2d Array with 0 in all cells
---------------------------------------------------------------------
-- Create a 2d array of 0s.
-- rows -> number of rows
-- cols -> number of columns
-- return -> the new array
---------------------------------------------------------------------
function M.empty2dArray(rows, cols)
    local array = {}
    for i = 1, rows do
        local row = {}
        array[i] = row
        for j = 1, cols do
            row[j] = 0
        end
    end
    return array
end


---------------------------------------------------------------------
-- Appends one array onto another.
-- array -> the array to append onto
-- other -> the array to add
-- returns array
---------------------------------------------------------------------
function M.mergeArrays(array, other)
    for _, v in pairs(other) do
        array[#array + 1] = v
    end
    return array
end

---------------------------------------------------------------------
-- Display the elements of an array
-- array -> an array
---------------------------------------------------------------------
function M.printArray(array)
    local items = ""
    for _, v in pairs(array) do
        items = string.format("%s %s", items, v)
    end
    print(items)
end


---------------------------------------------------------------------
-- Converts seconds into a string of "min:sec".
-- seconds -> a positive integer of second
---------------------------------------------------------------------
function M.secToMin (seconds)
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

-- Return the module
return M