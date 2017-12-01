Class = require'src.Class'
Panel = require'src.view.panel.Panel'

local MessagePanel = Class(Panel)

function MessagePanel:init(app, x, y, message, width)
    Panel.init(self, app, x, y)
    self.message = message
    self.width = width
    self.height = app.screenY
end

function MessagePanel:render()
    Panel.render(self)
    Panel.printf(self, self.message, 0, 'center')
end

return MessagePanel