-- For now mode is just a place to determine the refill of the board
-- Modes are just tables holding a couple of data elements and not proper class instances
local mode = {}

local MODES = {
    {name = "Normal", refill = true},
    {name = "No Refill", refill = false}
}

local currentMode = 1

function mode.cycle()
    if currentMode == #MODES then
        currentMode = 1
    else
        currentMode = currentMode + 1
    end
end

function mode.get()
    return MODES[currentMode]
end


return mode