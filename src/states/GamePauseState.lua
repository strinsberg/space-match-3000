Class = require'src.Class'
ScreenArea = require'src.view.ScreenArea'
Mode = require'src.Mode'
assets = require 'assets.assets'

local GamePauseState = Class(GameState)

function GamePauseState:init(app)
    GameState.init(self, app)
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
        self.app:changeState(MainMenuState(self.app))
    elseif key == 'p' then
        self.app:changeState(GameRunState(self.app))
    end
end


-- Draw everything for the state to the screen
function GamePauseState:draw()
    -- Super draw
    GameState.draw(self)
    self.boardArea:printCenter("-- Game Paused --", -assets.blockSize)
end

return GamePauseState