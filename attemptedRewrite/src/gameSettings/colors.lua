local colors = {}

local MIN_COLORS = 4
local MAX_COLORS = 6

local numColors = MIN_COLORS

function colors.cycle()
    if numColors == MAX_COLORS then
        numColors = MIN_COLORS
    else
        numColors = numColors + 1
    end
end

function colors.get()
    return numColors
end

return colors