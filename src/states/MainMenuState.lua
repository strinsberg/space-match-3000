Class = require'src.Class'
AppState = require'src.states.AppState'
ScreenArea = require'src.view.ScreenArea'
assets = require'assets.assets'

local MainMenuState = Class(AppState)

function MainMenuState:init(app)
    AppState.init(self, app)
    self.menuArea = ScreenArea(240, 160, 320)
    self.settingsArea = ScreenArea(240, 400, 320)
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
    end
end

function MainMenuState:draw()
    -- Draw everything for the state to the screen
    AppState.draw(self)
    
    self.menuArea:printCenter("(n)ew game", 0)
    self.menuArea:printCenter("(d)ifficulty", assets.blockSize)
    self.menuArea:printCenter("(m)ode", assets.blockSize * 2)
    self.menuArea:printCenter("(q)uit", assets.blockSize * 3)
    
    self.settingsArea:printCenter(self.app.currentMode:diffToString(), 0)
    self.settingsArea:printCenter(string.format("%s %s",
            self.app.currentMode:typeToString(),
            self.app.currentMode:limitToString()), assets.blockSize)
        
    self.infoArea:printCenter(string.format("Version %s", self.app.version), 0)
    self.infoArea:printCenter(self.app.company, assets.blockSize)
end

return MainMenuState