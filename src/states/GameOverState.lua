Class = require'src.Class'
AppState = require'src.states.AppState'

local GameOverState = Class(AppState)

function GameOverState:init(app)
    AppState.init(self, app)
    self.titleArea = ScreenArea(0, 120, app.width)
    self.scoreArea = ScreenArea(0, 200, app.width)
    self.menuArea = ScreenArea(0, 500, app.width)
end

-- All updates for the state
function GameOverState:update(dt)
    -- Super update
    AppState.update(self, dt)
end

-- Handle mouse events for the state
function GameOverState:mousePressed(x, y, button)
    -- Super mouse pressed
    AppState.mousePressed(app, x, y, button)
end

-- Handle key press events for the state
function GameOverState:keyPressed(key)
    -- Super key pressed
    AppState.keyPressed(self, key)
    if key == 'c' then
        self.app:changeState(HighScoreState(self.app))
    end
end

-- Draw everything for the state
function GameOverState:draw()
    -- Super draw
    AppState.draw(self)
    
    self.titleArea:printCenter("Game Over", 0)
    self.scoreArea:printCenter(
            string.format("Final Score: %s", self.app.game.score), 0)
    
    self.menuArea:printCenter("(c)ontinue", 0)
end

return GameOverState