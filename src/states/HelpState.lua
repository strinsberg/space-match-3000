Class = require'src.Class'
assets = require'assets.assets'

---------------------------------------------------------------------
-- The state of the app for the help screen
-- AppState -> The base state for app states
---------------------------------------------------------------------
local HelpState = Class(AppState)



---------------------------------------------------------------------
-- Initialize the state
-- app -> the app the state is part of
---------------------------------------------------------------------
function HelpState:init(app)
    -- Super Constructor
    AppState.init(self, app)
    self.text = {"Menu items can be activated with the key in brackets.\n",
            "Ex. (q)uit - press \"q\" to quit.\n",
            "\nIn game the \"left-mouse-button\" selects an block. If the next",
            " \"left\" click is on an adjacent block the selected block will be ",
            "switched with that block, else the new block will be selected. ",
            "The \"right-mouse-button\" removes the selection.\n",
            "\nPressing \"h\" during the game will highlight an block that ",
            "can be matched, \"p\" will pause, \"r\" will resume, ",
            "and \"q\" will end the game prematurely.\n"}
end


---------------------------------------------------------------------
-- Handler for key press events
-- key -> the key pressed
---------------------------------------------------------------------
function HelpState:keyPressed(key)
    -- Super keyPressed
    AppState.keyPressed(self, key)
    
    -- State specific keys
    if key == 'return' then
        self.app:changeState(MainMenuState(self.app))
    end
end


---------------------------------------------------------------------
-- Draw the state information
---------------------------------------------------------------------
function HelpState:draw()
    -- Super Draw
    AppState.draw(self)
    
    -- State specific drawing
    self.titleArea:printCenter("-- HELP --", 0)
    self.textArea:printLeft(table.concat(self.text, ""), 20)
    self.menuArea:printCenter("(enter) Main Menu", 0)
end


-- Return the module
return HelpState