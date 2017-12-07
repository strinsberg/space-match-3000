Class = require'src.Class'
AppState = require'src.states.AppState'
HighScoreState = require'src.states.HighScoreState'
HelpState = require'src.states.HelpState'
ScreenArea = require'src.view.ScreenArea'
assets = require'assets.assets'

local MainMenuState = Class(AppState)

function MainMenuState:init(app)
    AppState.init(self, app)
    self.menuArea = ScreenArea(240, 180, 320)
    self.settingsArea = ScreenArea(240, 440, 320)
    self.infoArea = ScreenArea(0, 560, app.width)
end

function MainMenuState:update(dt)
    -- All game updates for the state
    AppState.update(self, dt)
end

function MainMenuState:mousePressed(x, y, button)
    -- Handle mouse events for the state
    AppState.mousePressed(self, x, y, button)
end

function MainMenuState:keyPressed(key)
    -- Handle key press events for the state
    AppState.keyPressed(self, key)
    
    if key == 'q' then
        love.event.quit()
    elseif key == 'n' then
        self.app:newGame()
    elseif key == 'd' then
        self.app.currentMode:changeDifficulty()
    elseif key == 'm' then
        self.app.currentMode:changeGameType()
    elseif key == 's' then
        self.app:changeState(HighScoreState(self.app))
    elseif key == 'h' then
        self.app:changeState(HelpState(self.app))
    end
end

function MainMenuState:draw()
    -- Draw everything for the state to the screen
    AppState.draw(self)
    
    self.titleArea:printCenter("-- MAIN MENU --", 0)
    
    self.menuArea:printCenter("(n)ew game", 0)
    self.menuArea:printCenter("(d)ifficulty", assets.fontSize)
    self.menuArea:printCenter("(m)ode", assets.fontSize * 2)
    self.menuArea:printCenter("(s)cores", assets.fontSize * 3)
    self.menuArea:printCenter("(h)elp", assets.fontSize * 4)
    self.menuArea:printCenter("(q)uit", assets.fontSize * 5)
    
    self.settingsArea:printCenter(self.app.currentMode:diffToString(), 0)
    self.settingsArea:printCenter(string.format("%s %s",
            self.app.currentMode:typeToString(),
            self.app.currentMode:limitToString()), assets.fontSize)
        
    self.infoArea:printCenter(string.format("Version %s", self.app.version), 0)
    self.infoArea:printCenter(self.app.company, assets.fontSize)
end

return MainMenuState