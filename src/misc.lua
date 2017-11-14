local M = {}

function toPix (pos, itemSize)
    return (pos - 1) * itemSize
end

function toPos (pixels, itemSize)
    return (pixels / itemSize) + 1
end

M.toPix = toPix
M.toPos = toPos

return M