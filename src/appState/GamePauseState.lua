Class = require'src.Class'
GameState = require'src.appState.GameState'
GameOverState = require'src.appState.GameOverState'
MessagePanel = require'src.view.panel.MessagePanel'

local GamePauseState = Class(GameState)

function GamePauseState:init(app)
    GameState.init(self, app)
    self.screen:addPanel(MessagePanel(app, 0, 120, "Game Paused", app.screenW))
    self.screen:addPanel(MessagePanel(app, 200, 500, "(p) or (enter) to resume", 400))
end

function GamePauseState:update(dt)
    -- Do nothing
end

function GamePauseState:mousePressed(x, y, button)
    -- Do nothing
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
end

return GamePauseState
