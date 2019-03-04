Class = require'src.Class'

---------------------------------------------------------------------
-- A class to hold matched blocks.
---------------------------------------------------------------------
local Match = Class()


---------------------------------------------------------------------
-- Initializes a match object.
---------------------------------------------------------------------
function Match:init()
    self.size = 0  -- don't really need this
    self.color = 0
    self.blocks = {}
end


---------------------------------------------------------------------
-- Add a block to a match.
-- block -> a block to add
---------------------------------------------------------------------
function Match:addBlock(block)
    if self.size == 0 then
        self.color = block.color
    end
    if block.color == self.color then
        self.blocks[#self.blocks + 1] = block
        self.size = self.size + 1
    end
end

---------------------------------------------------------------------
-- Returns the number of blocks in the match
---------------------------------------------------------------------
function Match:size()
  return len(self.blocks)
end

-- Return module
return Match