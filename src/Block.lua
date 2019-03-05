Class = require'src.Class'

---------------------------------------------------------------------
-- A block for a match 3 board.
---------------------------------------------------------------------
local Block = Class()


---------------------------------------------------------------------
-- Initialize a new block with a random color
-- numColors -> the total number of colors
-- row -> the row of the block
-- column -> the column of the block
---------------------------------------------------------------------
function Block:init(numColors, row, column)
    if numColors == 0 then
        self.color = 0
    else
        self.color = math.random(1, numColors)
    end
    self.row = row
    self.column = column
    
    -- For moving blocks
    self.isVisible = true -- Wether or not the block can be seen
    self.moveRow = nil -- The row a block is moving from
    self.moveColumn = nil -- The column a block is moving from
end


---------------------------------------------------------------------
-- Move a block to a new row and column.
---------------------------------------------------------------------
function Block:move(newRow, newColumn)
    self.moveRow = self.row
    self.moveColumn = self.column
    self.row = newRow
    self.column = newColumn
end


-- Return the module
return Block