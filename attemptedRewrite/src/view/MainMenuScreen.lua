Screen = require'src.view.Screen'
ScreenArea = require'src.view.ScreenArea'

local MainMenuScreen = Class(Screen)

function MainMenuScreen:init(state)
    Screen.init(self, state)
    self.menuArea = ScreenArea(0, 160, self.main.width, 320)
    self.infoArea = ScreenArea(0, 560, self.main.width, 80)
end

function MainMenuScreen:draw()
    self.menuArea:printf(self.state.menu.title, 0, "center")
    local text = ""
    for i, item in ipairs(self.state.menu:getOrderedMenu()) do
        if item.id == "c" then
            text = string.format("%s: %s", item.text, self.state.numColors)
        elseif item.id == "m" then
            text = string.format("%s: %s", item.text, self.state.mode.name)
        elseif item.id == "l" then
            text = string.format("%s: %s", item.text, self.state.limitName)
        else
            text = item.text
        end
        self.menuArea:printf(text, (i + 1) * 30, "center")
    end
    self.infoArea:printf(self.app.version, 10, "center")
    self.infoArea:printf(self.app.company, 40, "center")
end

return MainMenuScreen