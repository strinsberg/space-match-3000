Class = require'src.Class'

local Mode = Class()

-- Mode Constants
Mode.UNLIMITED = 0
Mode.NO_REFILL = 1
Mode.MOVES_50 = 2
Mode.MOVES_100 = 3
Mode.TIME_2MIN = 4
Mode.TIME_5MIN = 6

function Mode:init(limit, isTimed, refill)
    self.limit = limit
    self.isTimed = isTimed
    self.refill = refill
end

return Mode