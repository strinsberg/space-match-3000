Class = require'src.Class'

-- Object to hold all the panels that may be needed on a screen
local Screen = Class()

function Screen:init()
    -- Initialization code
    self.panels = {}
end

function Screen:addPanel(panel)
    self.panels[#self.panels + 1] = panel
end

function Screen:render()
    -- Draw everything to the screen
    for i, panel in ipairs(self.panels) do
        panel:render()
    end
end

return Screen