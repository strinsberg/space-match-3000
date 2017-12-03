Class = require'src.Class'

local Block = Class()

-- Create a new block with a random color
function Block:init(numColors, row, column)
    self.color = math.random(1, numColors)
    self.row = row
    self.column = column
    -- Mostly for moving blocks
    self.isVisible = true -- Wether or not the block can be seen
    self.newRow = nil -- The row a block is moving to
    self.newColumn = nil -- The column a block is moving to
end

function Block:move(newRow, newColumn)
    self.row = newRow
    self.column = newColumn
end

return Block