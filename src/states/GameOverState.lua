Class = require'src.Class'
AppState = require'src.states.AppState'


---------------------------------------------------------------------
-- The state of the app for the game over screen (no high score)
-- AppState -> The base state for app states
---------------------------------------------------------------------
local GameOverState = Class(AppState)


---------------------------------------------------------------------
-- Initialize the state
-- app -> the app the state is part of
---------------------------------------------------------------------
function GameOverState:init(app)
    AppState.init(self, app)
end


---------------------------------------------------------------------
-- Handler for key press events
-- key -> the key pressed
---------------------------------------------------------------------
function GameOverState:keyPressed(key)
    -- Super key pressed
    AppState.keyPressed(self, key)
    
    if key == 'return' then
        self.app:changeState(MainMenuState(self.app))
    elseif key == 's' then
        self.app:changeState(HighScoreState(self.app))
    end
end


---------------------------------------------------------------------
-- Draw the state information
---------------------------------------------------------------------
function GameOverState:draw()
    -- Super draw
    AppState.draw(self)
    
    assets.setColor('red')
    self.titleArea:printCenter("-- GAME OVER --", 0)
    assets.setColor()
    
    self.scoreArea:printCenter(
            string.format("Final Score: %s", self.app.game.score),
            assets.fontSize)
    
    self.menuArea:printCenter("(s)cores  -  (enter) Main Menu", 0)
end


-- Return the module
return GameOverState