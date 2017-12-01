Class = require'src.Class'
Panel = require'src.view.panel.Panel'

local AppDetailsPanel = Class(Panel)

function AppDetailsPanel:init(app, x, y)
    Panel.init(self, app, x, y)
    self.width = app.screenW
    self.height = 60
end

function AppDetailsPanel:render()
    Panel.render(self)
    -- Eventually reference a dtails object and loop with font size * i
    Panel.printf(self, self.app.version, 0, 'center')
    Panel.printf(self, self.app.company, 30, 'center')
end

return AppDetailsPanel