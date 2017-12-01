Class = require'src.Class'
Panel = require'src.view.panel.Panel'

local MainPanel = Class(Panel)

function MainPanel:init(app)
    Panel.init(self, app, 0, 0)
    self.width = app.screenW
    self.height = app.screenH
    self.background = background -- Needs to be moved to view images
end

function MainPanel:render()
    Panel.render(self)
    Panel.draw(self, background, 0, 0)
    love.graphics.setFont(largerFont) -- Still need to address this maybe in the print and printf methods?
    Panel.printf(self, self.app.gameTitle, 40, 'center')
    love.graphics.setFont(font)
end

return MainPanel