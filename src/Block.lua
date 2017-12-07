Class = require'src.Class'

local Block = Class()

-- Create a new block with a random color
function Block:init(numColors, row, column)
    if numColors == 0 then
        self.color = 0
    else
        self.color = math.random(1, numColors)
    end
    self.row = row
    self.column = column
    -- Mostly for moving blocks
    self.isVisible = true -- Wether or not the block can be seen
    self.moveRow = nil -- The row a block is moving to
    self.moveColumn = nil -- The column a block is moving to
end

function Block:move(newRow, newColumn)
    self.moveRow = self.row
    self.moveColumn = self.column
    self.row = newRow
    self.column = newColumn
end

return Block