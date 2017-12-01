Class = require'src.Class'
AppState = require'src.appState.AppState'
Screen = require'src.view.Screen'
MainPanel = require'src.view.panel.MainPanel'
AppDetailsPanel = require'src.view.panel.AppDetailsPanel'
VerticalMenuPanel = require'src.view.panel.VerticalMenuPanel'
GameSettingsPanel = require'src.view.panel.GameSettingsPanel'

local MainMenuState = Class(AppState)

function MainMenuState:init(app)
    -- Initialize the state
    AppState.init(self, app)
    self.screen = Screen()
    self.screen:addPanel(MainPanel(app))
    self.screen:addPanel(AppDetailsPanel(app, 0, 580))
    self.screen:addPanel(VerticalMenuPanel(app, 240, 160, currentMenu)) -- current menu will need to be created somwhere non global
    self.screen:addPanel(GameSettingsPanel(app, 400 - 120, 480))
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
    self.screen:render()
end

return MainMenuState
