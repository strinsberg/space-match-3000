Class = require'src.Class'
Panel = require'src.view.panel.Panel'

local HorizontalMenuPanel = Class(Panel)

function HorizontalMenuPanel:init(app, x, y, menu)
    Panel.init(self, app, x, y)
    self.menu = menu
    self.width = app.screenW
    self.height = 30
    self.menuString = ""
    for i, menuItem in ipairs(menu.items) do
        if i == 1 then
            self.menuString = menuItem.text
        else
            self.menuString = string.format("%s   %s", self.menuString, menuItem.text)
        end
    end
end

function HorizontalMenuPanel:render()
    Panel.render(self)
    Panel.printf(self, self.menuString, 0, 'center')
end

return HorizontalMenuPanel