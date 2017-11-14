Class = require('src.Class')

local M = {}

-- Represents a block on the board
local Block = Class()

-- Creates a visible colored block. Color can be any constant that is being
-- Used in the program.
function Block:init(color)
    self.color = color
    self.visible = true
end


-- Local functions for Board class

-- Initialises an empty 2d array with 0 elements
local function emptyBoard(rows, columns)
    items = {}
    for i = 1, rows do
        local row = {}
        items[i] = row -- Store an empty array in items for each row
        for j = 1, columns do
            row[j] = 0 -- Store a 0 at each position in the row array
        end
    end
    return items
end


-- Represents a game board
local Board = Class()


-- Creates a board with a number of rows and columns
function Board:init(rows, columns)
    self.rows = rows
    self.columns = columns
    self.items = emptyBoard(rows, columns)
end

M.Board = Board
M.Block = Block

return M

--[[
thoughts for methods

- for constructor it may be possible with lua to supply a function that creates items you
    want to be in the board when you initialize the object. that way you wouldn't have to
    create the board and then do another loop to set all its items. However, this might
    not really change the amount of code needed, but it might be useful.
    function() return Item(math.random(1,6) end could be called instead of 0 to fill in the
    row[j] position


- moveItem(row, column, newRow, newColumn)
    -- row and column are the space of the item to move and newRow
        newColumn are the space to move it to
    -- it is possible that this is unecessary and items should move
        themselves
        



--]]

