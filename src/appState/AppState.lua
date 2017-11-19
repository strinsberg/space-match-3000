Class = require'src.Class'

-- Base class/interface for all app state classes
local AppState = Class()

function AppState:init()
    -- Initialize the state
end

function AppState:update(dt)
    -- All game updates for the state
end

function AppState:mousePressed(x, y, button)
    -- Handle mouse events for the state
end

function AppState:keyPressed(key)
    -- Handle key press events for the state
end

function AppState:draw()
    -- Draw everything for the state to the screen
end

return AppState