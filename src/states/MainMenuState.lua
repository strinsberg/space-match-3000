Class = require'src.Class'
AppState = require'src.states.AppState'
HighScoreState = require'src.states.HighScoreState'
HelpState = require'src.states.HelpState'
ScreenArea = require'src.view.ScreenArea'
assets = require'assets.assets'

---------------------------------------------------------------------
-- The state of the app for the main menu
-- AppState -> The base state for app states
---------------------------------------------------------------------
local MainMenuState = Class(AppState)


---------------------------------------------------------------------
-- Initialize the state
-- app -> the app the state is part of
---------------------------------------------------------------------
function MainMenuState:init(app)
    AppState.init(self, app)
    self.menuArea = ScreenArea(240, 180, 320)
    self.settingsArea = ScreenArea(240, 440, 320)
    self.infoArea = ScreenArea(0, 560, app.width)
end


---------------------------------------------------------------------
-- Update the state
-- dt -> delta time
---------------------------------------------------------------------
function MainMenuState:update(dt)
    -- All game updates for the state
    AppState.update(self, dt)
end


---------------------------------------------------------------------
-- Handler for mouse events
-- x -> the x coord of the event
-- y -> the y coord of the event
-- button -> the mouse button pressed
---------------------------------------------------------------------
function MainMenuState:mousePressed(x, y, button)
    -- Handle mouse events for the state
    AppState.mousePressed(self, x, y, button)
end


---------------------------------------------------------------------
-- Handler for key press events
-- key -> the key pressed
---------------------------------------------------------------------
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


---------------------------------------------------------------------
-- Draw the state information
---------------------------------------------------------------------
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


-- Return the module
return MainMenuState