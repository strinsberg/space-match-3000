Class = require'src.Class'
assets = require'assets.assets'

-- Base class/interface for all app state classes
local HelpState = Class(AppState)

function HelpState:init(app)
    -- Super Constructor
    AppState.init(self, app)
    self.text = {"Menu items can be activated with the key in brackets.\n",
            "Ex. (q)uit - press \"q\" to quit.\n",
            "\nIn game the \"left-mouse-button\" selects an item. If the next",
            " \"left\" click is on an adjacent item the selected item will be",
            "switched with that item.\n",
            "The \"right-mouse-button\" removes the selection.\n",
            "\nPressing \"h\" during the game will highlight an item that ",
            "can be matched, \"p\" will pause and return to the main menu, ",
            "and \"q\" will end the game prematurely.\n"}
end

function HelpState:update(dt)
    -- Super update
    AppState.update(self, dt)
end

function HelpState:mousePressed(x, y, button)
    -- Super mousePressed
    AppState.mousePressed(self, x, y, button)
end

function HelpState:keyPressed(key)
    -- Super keyPressed
    AppState.keyPressed(self, key)
    if key == 'return' then
        self.app:changeState(MainMenuState(self.app))
    end
end

function HelpState:draw()
    -- Super Draw
    AppState.draw(self)
    self.titleArea:printCenter("-- Help --", 0)
    self.textArea:printLeft(table.concat(self.text, ""), 0)
    self.menuArea:printCenter("continue (enter)", 0)
end

return HelpState