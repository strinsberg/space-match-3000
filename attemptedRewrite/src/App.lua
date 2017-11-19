Class = require'src.Class'
MainMenuState = require'src.gameState.MainMenuState'


-- Main application class
local App = Class()


-- Creates an instance of class App
function App:init(title, version, company)
    -- could be some kind of object
    self.title = title
    self.version = version
    self. company = company
    
    self.windowWidth = 800
    self.windowHeight = 640

    self.game = nil
    
    self.state = MainMenuState(self)
end

function App:changeState(state)
    self.state = state
end

return App