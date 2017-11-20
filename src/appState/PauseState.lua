Class = require'src.Class'
AppState = require'src.appState.AppState'

local PauseState = Class(GameState)
-- Use the game state as a prototype for this class
-- and call its methods in each of these method that you want the pause
-- and game state to share things. Then follow that with all the things
-- you want to only happen in this state

function GamePauseState:init(app)
    GameState.init(self, app)
end

function GamePauseState:keyPressed(key)
    if key == 'p' or key == 'return' then
        self.app.changeState(GameRunState(self.app))
    elseif key == 'q' then
        self.app.changeState(GameOverState(self.app))
    end
end

function GamePauseState:draw()
    GameState.draw(self)
    love.graphics.printf("Game Paused", gameArea.x, gameArea.y + 120,
            320, 'center')
    love.graphics.printf("(p) or (enter) to resume", gameArea.x,
            gameArea.y + 160, 'center')
end

return GamePauseState
