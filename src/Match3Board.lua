Class = require'src.Class'
Block = require'src.Block'
Match = require'src.Match'
functions = require'src.libFunctions'

--[[
    Class to represent a match 3 board
    TODO
    -- Still does not have a hint finding function. Maybe make it so it
    finds all the blocks that have an available move and then choose one
    at random. Might be a little bit too intense for just finding one hint.
    could also go row by row but do it randomly.
--]]


local Match3Board = Class()

-- local helper variables
local minLength = 3

-- Constructor sets initial state of the board
function Match3Board:init(rows, columns, numColors)
    self.rows = rows
    self.columns = columns
    self.numColors = numColors
    self.board = functions.empty2dArray(rows, columns)
    self:setBoard()
end


-- Set the board with new random blocks in the range of numColors
function Match3Board:setBoard()
    for row = 1, self.rows do
        for column = 1, self.columns do
            -- Add an unmatched block to the row, column position
            repeat
                self.board[row][column] = Block(self.numColors, row, column)
            until not self:isBlockMatched(row, column)
        end
    end
end


-- Check to see if a block is matched with blocks around it.
function Match3Board:isBlockMatched(row, column)
    if self:isBlockMatchedRow(row, column)
            or self:isBlockMatchedColumn(row, column) then
        return true
    else
        return false
    end
end

-- Checks the min number of blocks in the column to see
-- if the block has a match
function Match3Board:isBlockMatchedColumn(row, column)
    local matchLength = 0
    local color = self.board[row][column].color
    for i = row - 2, row + 2 do
        -- Make sure you dont try to check positions that dont exist
        if i > 0 and i < self.rows + 1 then
            -- Make sure there is a block in the space
            if self.board[i][column] ~= 0 then
                -- Check to see if the block matches the color
                if self.board[i][column].color == color then
                    matchLength = matchLength + 1
                    if matchLength == minLength then
                        return true
                    end
                else
                    matchLength = 0
                end
            end
        end
    end
    return false
end

-- Checks the min number of blocks in the row to see if the block has a match
function Match3Board:isBlockMatchedRow(row, column)
    local matchLength = 0
    local color = self.board[row][column].color
    for i = column - 2, column + 2 do
        -- Make sure you dont try to check positions that dont exist
        if i > 0 and i < self.columns + 1 then
            -- Make sure there is a block in the space
            if self.board[row][i] ~= 0 then
                -- Check to see if the block matches the color
                if self.board[row][i].color == color then
                    matchLength = matchLength + 1
                    if matchLength == minLength then
                        return true
                    end
                else
                    matchLength = 0
                end
            end
        end
    end
    return false
end


-- Switch one bock with another returns the blocks switched
function Match3Board:switchBlocks(row, column, otherRow, otherColumn)
    local block = self.board[row][column]
    local otherBlock = self.board[otherRow][otherColumn]
    block:move(otherRow, otherColumn)
    otherBlock:move(row, column)
    self.board[row][column] = otherBlock
    self.board[otherRow][otherColumn] = block
    return block, otherBlock
end


-- Check to see if a move is adjacent horizontally or vertically
function Match3Board:isAdjacentMove(row, column, newRow, newColumn)
    if math.abs(row - newRow) == 1 and math.abs(column - newColumn) == 0 or
            math.abs(row - newRow) == 0 and math.abs(column - newColumn) == 1 then
        return true
    else
        return false
    end
end


-- Get all the matches that are on the board
function Match3Board:getMatches()
    local matches = {} -- All the matches on the board
    local rowMatches = {} -- All the matches in rows
    local columnMatches = {} -- All the matches in columns
    -- Get all the matches
    for row = 1, self.rows do
        rowMatches = functions.mergeArrays(rowMatches,
                self:getRowMatches(row))
    end
    for column = 1, self.columns do
        columnMatches = functions.mergeArrays(columnMatches,
                self:getColumnMatches(column))
    end
    -- Add the row and column matches to matches
    matches = functions.mergeArrays(matches, rowMatches)
    matches = functions.mergeArrays(matches, columnMatches)
    -- Return all the matches
    return matches
end


-- Get all the matches from a row
function Match3Board:getRowMatches(row)
    local matches = {}
    local currentMatch = Match()
    local isMatch = false
    -- Set the initial values to the first block in the row
    local matchStart = 1
    local matchLength = 1
    local matchColor = self.board[row][matchStart].color
    -- Starting with 2nd column iterate through all blocks and see if there are
    -- any matches
    for column = 2, self.columns do
        if self.board[row][column].color == matchColor then
            isMatch = true
            matchLength = matchLength + 1
        end
        -- If the block does not match the last one or it is the last block
        if self.board[row][column].color ~= matchColor
                or column == self.columns then
            -- If the matched blocks are enough to make a match
            if matchLength >= minLength then
                -- For each block in the match add it to the current match
                for i = 0, matchLength - 1 do
                    currentMatch:addBlock(self.board[row][matchStart + i])
                end
                -- Add current match to matches and reset current match
                matches[#matches + 1] = currentMatch
                currentMatch = Match()
            end
            -- No longer in a match
            isMatch = false
            -- Reset other variables to the current block
            matchStart = column
            matchLength = 1
            matchColor = self.board[row][column].color
        else
            -- Continue
        end
    end
    return matches
end


-- Get all the matches from a column
function Match3Board:getColumnMatches(column)
    local matches = {}
    local currentMatch = Match()
    local isMatch = false
    -- Set the initial values to the first block in the column
    local matchStart = 1
    local matchLength = 1
    local matchColor = self.board[matchStart][column].color
    -- Starting with column 2 iterate through all blocks and see if there are
    -- any matches
    for row = 2, self.rows do
        if self.board[row][column].color == matchColor then
            isMatch = true
            matchLength = matchLength + 1
        end
        -- If the block does not match the last one or it is the last block
        if self.board[row][column].color ~= matchColor
                or row == self.rows then
            -- If the matched blocks are enough to make a match
            if matchLength >= minLength then
                -- For each block in the match add it to the current match
                for i = 0, matchLength - 1 do
                    currentMatch:addBlock(self.board[matchStart + i][column])
                end
                -- Add current match to matches and reset current match
                matches[#matches + 1] = currentMatch
                currentMatch = Match()
            end
            -- No longer in a match
            isMatch = false
            -- Reset other variables to the current block
            matchStart = row
            matchLength = 1
            matchColor = self.board[row][column].color
        else
            -- Continue
        end
    end
    return matches
end


-- Remove Matches from the board
function Match3Board:removeMatches(matches)
    -- For each match
    for i, match_ in ipairs(matches) do
        for i, block in ipairs(match_.blocks) do
            -- Remove each matched block from the board
            self.board[block.row][block.column] = 0
        end
    end
end


-- Get a list of all blocks that will replace empty spaces on the board
function Match3Board:getDroppingBlocks(refill)
    local droppingBlocks = {}
    for column = 0, self.columns do
        droppingBlocks = functions.mergeArrays(droppingBlocks,
                self:getDroppingBlocksColumn(column, refill))
    end
    return droppingBlocks
end


-- Get a list of all blocks dropping in a column
function Match3Board:getDroppingBlocksColumn(column, refill)
    local droppingBlocks = {}
    local emptyStart = nil
    local numEmpty = 0
    
    -- Move through each row in the column from the last to the first
    for row = self.rows, 1, -1 do
        local block = self.board[row][column]
        
        -- If the space has no block add its row to the array
        if block == 0 then
            if numEmpty == 0 then
                emptyStart = row
            end
            numEmpty = numEmpty + 1 -- Increment total empty spaces
        -- If the space has a block and empty spaces have been found
        elseif block ~= 0 and numEmpty > 0 then
            block.moveRow = emptyStart -- Row the block is going to move to
            -- Add block to tho list of blocks that will dropp
            droppingBlocks[#droppingBlocks + 1] = block
            emptyStart = emptyStart - 1
        else
            -- Continue
        end
    end
    -- If the board will refill
    if refill and numEmpty > 0 then
        -- For every empty space
        for i = numEmpty, 1, -1 do
            -- Add a new block to drop above the top of the board
            local block = Block(self.numColors, i - numEmpty, column)
            block.moveRow = i
            droppingBlocks[#droppingBlocks + 1] = block
        end
    else
        -- If refill is false set empty cells to 0
        for i = numEmpty, 1, -1 do
            self.board[i][column] = 0
        end
    end
    -- testing
    return droppingBlocks
end


-- Move all blocks that need to drop into their new spaces
function Match3Board:dropBlocks(droppingBlocks)
    for i, block in ipairs(droppingBlocks) do
        self.board[block.moveRow][block.column] = block
        block:move(block.moveRow, block.column)
        block.isVisible = false
    end
end


-- For debuging ----------------------------------------
function Match3Board:toString()
    for i = 1, self.rows do
        local row = ""
        for j = 1, self.columns do
            local cell = ""
            if self.board[i][j] == 0 then
                cell = "x"
            else
                cell = self.board[i][j].color
            end
            row = string.format("%s %s", row, cell)
        end
        print(row)
    end
end

return Match3Board