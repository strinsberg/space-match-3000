Class = require'src.Class'
AppState = require'src.appState.AppState'
NameEntryState = require'src.appState.NameEntryState'
HighScoreState = require'src.appState.HighScoreState'

local GameOverState = Class(AppState)

function GameOverState:init(app)
    -- Initialize the state
    AppState.init(self, app)
end

function GameOverState:update(dt)
    -- All game updates for the state
end

function GameOverState:mousePressed(x, y, button)
    -- Handle mouse events for the state
end

function GameOverState:keyPressed(key)
    -- Handle key press events for the state
    AppState.keyPressed(self, key)
    if key == 'return' then
        -- get all high scores for this mode
        local scores = {}
        local diff = game.diffToString(gameDifficulty)
        local mode = game.modeSaveString(gameMode)
        -- if the players score is a high score go to name entry screen
        for _, score in ipairs(highScores[diff][mode]) do
            if board.score > score.score or
                    (#highScores[diff][mode] < 10 and board.score > 0) then
                self.app.changeState(NameEntryState(self.app))
                return
            end
        end
        -- if players score is not a high score just go straight to the score screen
        self.app.changeState(HighScoreState(self.app))
    end
end

function GameOverState:draw()
    -- Draw everything for the state to the screen
    AppState.draw(self)
    love.graphics.printf("Game Over", gameArea.x, gameArea.y, 320, 'center')
    love.graphics.printf(string.format("Final Score: %s", board.score),
            gameArea.x, gameArea.y + 80, 320, 'center')
    love.graphics.printf("(enter) to continue", gameArea.x,
        gameArea.y + 380, 320, 'center')
end

return GameOverState
