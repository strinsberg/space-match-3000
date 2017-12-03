Class = require'src.Class'

local Match = Class()

function Match:init()
    self.size = 0
    self.color = 0
    self.blocks = {}
end

function Match:addBlock(block)
    if self.size == 0 then
        self.color = block.color
    end
    if block.color == self.color then
        self.blocks[#self.blocks + 1] = block
        self.size = self.size + 1
    end
end

return Match