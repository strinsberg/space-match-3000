Class = require'src.Class'
GameState = require'src.appState.GameState'
GameOverState = require'src.appState.GameOverState'

local GamePauseState = Class(GameState)

function GamePauseState:init(app)
    GameState.init(self, app)
end

function GamePauseState:update(dt)
    -- Do nothing
end

function GamePauseState:mousePressed(x, y, button)
    -- Do nothing
end

function GamePauseState:keyPressed(key)
    if key == 'p' or key == 'return' then
        self.app.changeState(GameUpdateState(self.app))
    elseif key == 'q' then
        self.app.changeState(GameOverState(self.app))
    end
end

function GamePauseState:draw()
    GameState.draw(self)
    love.graphics.printf("Game Paused", gameArea.x, gameArea.y - 40,
            320, 'center')
    love.graphics.printf("(p) or (enter) to resume", gameArea.x - 40,
            gameArea.y + 340, 400, 'center')
end

return GamePauseState
