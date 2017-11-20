Class = require'src.class'

-- Base Class/Interface for screens that hold information for drawing an appState
local Screen = Class()

function Screen:init(state)
    -- Initialization code
    self.state = state
end

function Screen:resize(oldWidth, oldHeight, width, height)
    -- Handle resize events?
    -- could just check the percentage difference from the old to the new and use it to multiply
    -- any values in the code in order to get a better number. so if the screen is 100 and it doubles
    -- then all the values could just double. so
    -- love.graphics.draw(image, x * screenRatioX, y * screenRatioY, imageSizeX * screenRatiox, imageSizeY * screenRatioY)
    -- screen ratio could be set in the app somwhere and that is all that would have to be changed with
    -- resize events
end

function Screen:draw()
    -- Draw everything to the screen
end

return Screen