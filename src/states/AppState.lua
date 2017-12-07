Class = require'src.Class'
assets = require'assets.assets'
ScreenArea = require'src.view.ScreenArea'

-- Base class/interface for all app state classes
local AppState = Class()

function AppState:init(app)
    -- Initialize the state
    self.app = app
    self.mainArea = ScreenArea(0, 0, app.width)
    self.titleArea = ScreenArea(0, 120, app.width)
    self.scoreArea = ScreenArea(0, 160, app.width)
    self.textArea = ScreenArea(20, 160, app.width - 40)
    self.menuArea = ScreenArea(0, 580, app.width)
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
    self.mainArea:draw(assets.background, 0, 0)
    love.graphics.setFont(assets.largerFont)
    self.mainArea:printCenter(self.app.title, 40)
    love.graphics.setFont(assets.font)
end

return AppState
