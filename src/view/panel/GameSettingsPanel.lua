Class = require'src.Class'
Panel = require'src.view.panel.Panel'

-- Class GameSettingsPanel
local GameSettingsPanel = Class(Panel)

function GameSettingsPanel:init(app, x, y)
    Panel.init(self, app, x, y)
    self.width = 240
    self.height = 105
end

function GameSettingsPanel:render()
    Panel.render(self)
    Panel.printf(self, string.format("Difficulty: %s", game.diffToString(gameDifficulty)),
            0, 'center')
    Panel.printf(self, string.format("Mode: %s", game.modeToString(gameMode)),
            35, 'center')
    -- should be able to print the limit if it exists
end

return GameSettingsPanel