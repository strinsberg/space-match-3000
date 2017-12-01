Class = require'src.Class'
Panel = require'src.view.panel.Panel'

local ScorePanel = Class(Panel)

function ScorePanel:init(app, x, y)
    Panel.init(self, app, x, y)
    self.width = 240
    self.height = 320
end

function ScorePanel:render()
    Panel.render(self)
    Panel.printf(self, string.format("Score: %s", board.score), 0, 'center')
    -- Change color for modifier
        if board.modifier > 3 then
        love.graphics.setColor(0, 255, 0, 255)
    elseif board.modifier > 5 then
        love.graphics.setColor(255, 0, 0, 255)
    end
    -- Print modifier
    Panel.printf(self, string.format("Mod: %s", board.modifier), 35, 'center')
    -- Change color back to white
    love.graphics.setColor(255, 255, 255, 255)
    -- Draw individual match score animations
    Panel.printf(self, "Match Scores", 70, 'center')
    for i, animation in ipairs(scoreAnims) do
        Panel.printf(self, animation.image, 70 + (i * fontSize), 'center')
    end
    
end

return ScorePanel