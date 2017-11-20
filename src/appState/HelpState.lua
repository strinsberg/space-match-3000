Class = require'src.Class'
AppState = require'src.appState.AppState'

local HelpState = Class(AppState)

function HelpState:init(app)
    -- Initialize the state
    AppState:init(self, app)
end

function HelpState:update(dt)
    -- All game updates for the state
end

function HelpState:mousePressed(x, y, button)
    -- Handle mouse events for the state
end

function HelpState:keyPressed(key)
    -- Handle key press events for the state
    AppState:keyPressed(self, key)
    if key == 'return' then
        state = MENU
    end
end

function HelpState:draw()
    -- Draw everything for the state to the screen
    AppState:draw(self)
    love.graphics.printf("HELP", gameArea.x, gameArea.y - 40, 320, 'center')
    love.graphics.printf(helpString, 40, gameArea.y, 720, 'left')
    love.graphics.printf("(enter) to go Back", gameArea.x,
        gameArea.y + 420, 320, 'center')
end

return HelpState
