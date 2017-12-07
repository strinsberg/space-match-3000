Class = require'src.Class'
ScreenArea = require'src.view.ScreenArea'
Mode = require'src.Mode'
assets = require 'assets.assets'

local GamePauseState = Class(GameState)

function GamePauseState:init(app, state)
    GameState.init(self, app)
    self.lastState = state
end

function GamePauseState:update(dt)
    -- Do Nothing
end

function GamePauseState:mousePressed(x, y, button)
    -- Do nothing
end

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


-- Draw everything for the state to the screen
function GamePauseState:draw()
    -- Draw whatever the previous state is
    self.lastState:draw()
    assets.setColor('red')
    self.boardArea:printCenter("-- Game Paused --", -assets.blockSize * 1.5)
    -- draw menu like options
    self.menuArea:printCenter("-- (r)esume --", 0)
    assets.setColor()
end

return GamePauseState