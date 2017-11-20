Class = require'src.Class'
AppState = require'src.appState.AppState'

local MainMenuState = Class(AppState)

function MainMenuState:init(app)
    -- Initialize the state
    AppState.init(self, app)
end

function MainMenuState:update(dt)
    -- All game updates for the state
end

function MainMenuState:mousePressed(x, y, button)
    -- Handle mouse events for the state
end

function MainMenuState:keyPressed(key)
    -- Handle key press events for the state
    AppState.keyPressed(self, key)
    currentMenu:action(key) -- Relies on a global variable from main.lua
end

function MainMenuState:draw()
    -- Draw everything for the state to the screen
    AppState.draw(self)
    love.graphics.printf(currentMenu.title, gameArea.x, gameArea.y, 320, "center")
    love.graphics.printf(string.format("Difficulty: %s", game.diffToString(gameDifficulty)),
            gameArea.x, gameArea.y + 320, 320, 'center')
    love.graphics.printf(string.format("Mode: %s", game.modeToString(gameMode)),
            gameArea.x, gameArea.y + 350, 320, 'center')
    for i, item in ipairs(currentMenu.items) do
        love.graphics.printf(item.text, gameArea.x, gameArea.y + 20 + (i * fontSize),
                320, "center")
    end
    love.graphics.printf(version, 0, gameArea.y2 + 90, 800, 'center')
    love.graphics.printf(creator, 0, gameArea.y2 + 120, 800, 'center')
end

return MainMenuState
