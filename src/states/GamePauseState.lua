Class = require'src.Class'
ScreenArea = require'src.view.ScreenArea'
Mode = require'src.Mode'
assets = require 'assets.assets'

local GamePauseState = Class(GameState)


---------------------------------------------------------------------
-- Initialize the state
-- app -> the app the state is part of
---------------------------------------------------------------------
function GamePauseState:init(app, state)
    GameState.init(self, app)
    self.lastState = state
end


---------------------------------------------------------------------
-- Update the state
-- dt -> delta time
---------------------------------------------------------------------
function GamePauseState:update(dt)
    -- Do Nothing
end


---------------------------------------------------------------------
-- Handler for mouse events
-- x -> the x coord of the event
-- y -> the y coord of the event
-- button -> the mouse button pressed
---------------------------------------------------------------------
function GamePauseState:mousePressed(x, y, button)
    -- Do nothing
end


---------------------------------------------------------------------
-- Handler for key press events
-- key -> the key pressed
---------------------------------------------------------------------
function GamePauseState:keyPressed(key)
    -- Handle key press events for the state
    if key == 'q' then
        self.app.game.isOver = true
        self.app:changeState(self.lastState)
    elseif key == 'r' then
        -- Go back to update state. If board is not updating it will go to run
        self.app:changeState(self.lastState)
    end
end


---------------------------------------------------------------------
-- Draw the state information
---------------------------------------------------------------------
function GamePauseState:draw()
    -- Draw whatever the previous state is
    self.lastState:draw()
    assets.setColor('red')
    self.boardArea:printCenter("-- Game Paused --", -assets.blockSize * 1.5)
    -- draw menu like options
    self.menuArea:printCenter("-- (r)esume --", 0)
    assets.setColor()
end


-- Return the module
return GamePauseState