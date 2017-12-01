Class = require'src.Class'
Panel = require'src.view.panel.Panel'

local VerticalMenuPanel = Class(Panel)

function VerticalMenuPanel:init(app, x, y, menu)
    Panel.init(self, app, x, y)
    self.menu = menu
    self.width = 320
    self.height = (#menu + 1) * 30
end

function VerticalMenuPanel:render()
    Panel.render(self)
    Panel.printf(self, self.menu.title, 0, 'center')
    for i, menuItem in ipairs(self.menu.items) do
        Panel.printf(self, menuItem.text, ((i + 1) * 35) - 10, 'center')
    end
end

return VerticalMenuPanel