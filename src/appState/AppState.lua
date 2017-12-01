Class = require'src.Class'

-- Base class/interface for all app state classes
local AppState = Class()

function AppState:init(app)
    -- Initialize the state
    self.app = app
end

function AppState:update(dt)
    -- All game updates for the state
end

function AppState:mousePressed(x, y, button)
    -- Handle mouse events for the state
end

function AppState:keyPressed(key)
    -- Handle key press events for the state
    if key == 'escape' then
        love.event.quit()
    end
end

function AppState:draw()
    -- Draw everything for the state to the screen
    love.graphics.draw(background, 0, 0)
    love.graphics.setFont(largerFont)
    love.graphics.printf(self.app.gameTitle, 0, 40, 800, 'center')
    love.graphics.setFont(font)
end

return AppState
