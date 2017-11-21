Class = require'src.Class'
AppState = require'src.appState.AppState'
MainMenuState = require'src.appState.MainMenuState'

local HighScoreState = Class(AppState)

function HighScoreState:init(app)
    -- Initialize the state
    AppState.init(self, app)
end

function HighScoreState:update(dt)
    -- All game updates for the state
end

function HighScoreState:mousePressed(x, y, button)
    -- Handle mouse events for the state
end

function HighScoreState:keyPressed(key)
    -- Handle key press events for the state
    AppState.keyPressed(self, key)
    if key == 'return' then
        self.app.changeState(MainMenuState(self.app))
    elseif key == 'm' then
        cycleMode()
    elseif key == 'd' then
        cycleDifficulty()
    end
end

function HighScoreState:draw()
    -- Draw everything for the state to the screen
    AppState.draw(self)
    local diff = game.diffToString(gameDifficulty)
    local mode = game.modeSaveString(gameMode)
    love.graphics.printf(string.format("%s %s High Scores", diff, game.modeToString(gameMode)),
            gameArea.x - 50, gameArea.y - 50, 400, 'center')
    for i, score in ipairs(highScores[diff][mode]) do
        love.graphics.printf(score.score,
                gameArea.x - 100, gameArea.y + ((i - 1) * fontSize), 200, "right")
        love.graphics.printf(score.name,
                gameArea.x + 130, gameArea.y + ((i - 1) * fontSize), 320, "left")
    end
    love.graphics.printf("(m)ode, (d)ifficulty", gameArea.x,
        gameArea.y + 380, 320, 'center')
    love.graphics.printf("(enter) for Main Menu", gameArea.x,
        gameArea.y + 420, 320, 'center')
end


return HighScoreState
