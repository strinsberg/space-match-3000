anims = require('src/animations')

local M = {}

-- Global values for difficulty and mode
M.difficulty = {easy = 4, medium = 5, hard = 6}
M.mode = {endless = 1, limit50 = 2, limit100 = 3, timed120 = 4, timed300 = 5}

function M.diffToString (difficulty)
    if difficulty == M.difficulty.easy then
        return "Easy"
    elseif difficulty == M.difficulty.medium then
        return "Hard"
    else
        return "Rough"
    end
end

function M.modeToString (mode)
    if mode == M.mode.endless then
        return "Endless"
    elseif mode == M.mode.limit50 then
        return "50 Moves"
    elseif mode == M.mode.limit100 then
        return "100 Moves"
    elseif mode == M.mode.timed120 then
        return "2 Min"
    else
        return "5 Min"
    end
end

function M.modeSaveString (mode)
    if mode == M.mode.endless then
        return "Endless"
    elseif mode == M.mode.limit50 then
        return "50_Moves"
    elseif mode == M.mode.limit100 then
        return "100_Moves"
    elseif mode == M.mode.timed120 then
        return "2_Min"
    else
        return "5_Min"
    end
end

-- Create an empty 2d array
function empty2dArray (rows, columns)
    items = {}
    for i = 1, rows do
        local row = {}
        items[i] = row
        for j = 1, columns do
            row[j] = {item = 0, visible = true}
        end
    end
    return items
end


-- Create a base object for board class with default values for rows and columns
local board = {rows = 8, columns = 8, difficulty = M.difficulty.easy, selection = nil,
    matches = false, minMatchLength = 3, refill = true, score = 0, modifier = 1,
    matchPositions = {}, mode = nil, movesTaken = 0, moveLimit = nil, timeTaken = 0,
    timeLimit = nil
}

-- Creates a new instance of board
function board:new (o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)
    return o
end


-- Sets the initial values for items on the board
function board:set ()
    -- Set the board with unmatched items in every space
    self.items = empty2dArray(self.rows, self.columns)
    for i = 1, self.rows do
        for j = 1, self.columns do
            repeat
                self.items[i][j].item = math.random(1, self.difficulty)
            until not self:itemIsMatched(i, j) -- Ensures unmatched board
        end
    end
end

-- Set the beginning game limits
function board:setLimits()
    -- Set game costraints if there are any
    if self.mode == M.mode.limit50 then
        self.moveLimit = 50
    elseif self.mode == M.mode.limit100 then
        self.moveLimit = 100
    elseif self.mode == M.mode.timed120 then
        self.timeLimit = 120
    elseif self.mode == M.mode.timed300 then
        self.timeLimit = 300
    end
end


-- Switch an item at position1 with the item at position2
function board:switchItems (row1, column1, row2, column2)
    local item1 = self.items[row1][column1].item
    local item2 = self.items[row2][column2].item
    self.items[row1][column1].item = item2
    self.items[row2][column2].item = item1
    self.items[row1][column1].visible = false
    self.items[row2][column2].visible = false
end


-- Make sure the new position for a move is adjacent
function board:validMove (row, column, newRow, newColumn)
    if math.abs(newRow - row) == 1 and newColumn - column == 0 or
            math.abs(newColumn - column) == 1 and newRow - row == 0 then
        return true
    else
        return false
    end
end
    

-- Check to see if an item at row column has any matches around it
function board:itemIsMatched (row, column)
    local item = self.items[row][column].item
    -- Check row for match
    if row > 2 then
        if self.items[row - 2][column].item == item and
                self.items[row - 1][column].item == item then
            return true
        end
    end
    if row > 1 and row < self.rows then
        if self.items[row - 1][column].item == item and
                self.items[row + 1][column].item == item then
            return true
        end
    end
    if row < self.rows - 1 then
        if self.items[row + 1][column].item == item and
                self.items[row + 2][column].item == item then
            return true
        end
    end
    -- Check column for match
    if column > 2 then
        if self.items[row][column - 2].item == item and
                self.items[row][column - 1].item == item then
            return true
        end
    end
    if column > 1 and column < self.columns then
        if self.items[row][column - 1].item == item and
                self.items[row][column + 1].item == item then
            return true
        end
    end
    if column < self.columns - 1 then
        if self.items[row][column + 1].item == item and
                self.items[row][column + 2].item == item then
            return true
        end
    end
    return false
end


-- Finds all the matched items in a column and adds their position to self.matches
function board:findColumnMatches (column)
    local isMatch = false
    local matchStart = 1
    local matchLength = 1
    local item = self.items[matchStart][column].item
    local matchScores = {} -- the individual scores for each match
    for row = 2, self.rows do
        -- If the item at row, colum is the same as the current item
        if self.items[row][column].item == item then
            isMatch = true
            matchLength = matchLength + 1
        end
        -- If the item at row, column is not the same as the current item
        -- Or it is the last row on the board
        if self.items[row][column].item ~= item or row == self.rows then
            if matchLength >= self.minMatchLength then -- If the match is long enough
                for i = 0, matchLength - 1 do -- Add all the matched items to be removed
                    table.insert(self.matchPositions, {row = matchStart + i, column = column})
                    self.matches = true
                end
                -- Add to score for the match
                local score = (board:scoreMatch(matchLength) * self.modifier)
                self.score = self.score + score
                table.insert(matchScores, score)
            end
            -- Update match variables and set current item to the item at row, column
            matchStart = row
            isMatch = false
            matchLength = 1
            item = self.items[row][column].item
        else
            -- Continue. Is unecessary, but i put it in just for my own readability
        end
    end
    return matchScores
end


-- Finds all the matched items in a row and adds their position to self.matches
function board:findRowMatches (row)
    local isMatch = false
    local matchStart = 1
    local matchLength = 1
    local item = self.items[row][matchStart].item
    local matchScores = {}
    for column = 2, self.columns do
        if self.items[row][column].item == item then
            isMatch = true
            matchLength = matchLength + 1
        end
        if self.items[row][column].item ~= item or column == self.columns then
            if matchLength >= self.minMatchLength then
                for i = 0, matchLength - 1 do
                    table.insert(self.matchPositions, {row = row, column = matchStart + i})
                    self.matches = true
                end
                local score = (board:scoreMatch(matchLength) * self.modifier)
                self.score = self.score + score
                table.insert(matchScores, score)
            end
            matchStart = column
            isMatch = false
            matchLength = 1
            item = self.items[row][column].item
        else
            -- Continue
        end
    end
    return matchScores
end


-- Drop items into empty spaces
function board:dropColumn (column, itemSize)
    local emptyStart = nil
    local isEmpty = false
    local numEmpty = 0
    local itemChanges = {} -- row, column and newRow, and item for each item that has moved
    for row = self.rows, 1, -1 do
        local item = self.items[row][column].item
        -- If it is the first time no item is found
        if item == 0 and not isEmpty then
            emptyStart = row -- Set emptyStart index to current row
            isEmpty = true
        -- If the space is not empty and there are empty spaces
        elseif item ~= 0 and isEmpty then
            -- Move the item into the lowest empty space
            self.items[emptyStart][column].item = item
            self.items[row][column].item = 0 -- Set the moved items previous position to empty
            -- Details for the item that is moved
            table.insert(itemChanges, {row = row, column = column, newRow = emptyStart, item = item})
            emptyStart = emptyStart - 1 -- Move up the index of the lowest empty space
            self.items[row][column].visible = false
        end
        if item == 0 then
            self.items[row][column].visible = false
            numEmpty = numEmpty + 1
        end
    end
    -- If there are empty spaces and new items should be added to fill empty spaces
    if self.refill and isEmpty then
        repeat
            local newItem = math.random(1, self.difficulty)
            self.items[emptyStart][column] = {item = newItem, visible = false}
            table.insert(itemChanges, {row = emptyStart - numEmpty, column = column,
                    newRow = emptyStart, item = newItem})
            emptyStart = emptyStart - 1
        until emptyStart == 0
    end
    return itemChanges
end


-- Update the board once
function board:update(itemSize)
    local movedItems = {}
    self.matches = false
    for i = 1, self.columns do
        local changed = self:dropColumn(i, itemSize)
        for j = 1, #changed do
            movedItems[#movedItems + 1] = changed[j]
        end
    end
    return movedItems
end

-- Check for matches and removes matches items
function board:checkForMatches ()
    local scores = {}
    for i = 1, self.rows do
        local rowScores = self:findRowMatches(i)
        local columnScores = self:findColumnMatches(i)
        for j = 1, #rowScores do
            scores[#scores + 1] = rowScores[j]
        end
        for k = 1, #columnScores do
            scores[#scores + 1] = columnScores[k]
        end
    end
    for i, pos in ipairs(self.matchPositions) do
        self.items[pos.row][pos.column].item = 0
    end
    self.matchPositions = {}
    return scores
end

-- Return the points for a match of a certain length
function board:scoreMatch (length)
    if length == self.minMatchLength then
        return length * 1
    elseif length == self.minMatchLength + 1 then
        return length * 1.5
    elseif length == self.minMatchLength + 2 then
        return length * 2
    elseif length == self.minMatchLength + 3 then
        return length * 2.5
    else
        return length * 3
    end
end


-- Check if moveing an item would create a match
function board:itemHasMove(row, column, row2, column2)
    -- Get the items to switch
    local item1 = self.items[row][column].item
    local item2 = self.items[row2][column2].item
    -- Switch the items
    self.items[row][column].item = item2
    self.items[row2][column2].item = item1
    -- Check to see if either of them was a match
    local match1 = self:itemIsMatched(row2, column2)
    local match2 = self:itemIsMatched(row, column)
    -- Switch them back
    self.items[row][column].item = item1
    self.items[row2][column2].item = item2
    -- If one of the items has a match at its new location return the position of that item
    -- If they both match then only the first items position will be returned
    -- The point is only to check if there are matches not find all possible moves
    if match1 then
        return {row = row, column = column}
    elseif match2 then
        return {row = row2, column = column2}
    else
        return nil
    end
end


-- Check rows and columns for moves until one is found
-- Returns the position of the item that has a move
function board:hasMoves()
    local itemWithMove
    for row = self.rows, 2, -1  do
        for column = self.columns, 2, -1 do
            itemWithMove = self:itemHasMove(row, column, row - 1, column)
            if itemWithMove then return itemWithMove end
            itemWithMove = self:itemHasMove(row, column, row, column - 1)
            if itemWithMove then return itemWithMove end
            end
        end
    end

-- Add board to module
M.board = board

-- Return module
return M
