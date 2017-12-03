Class = require'src.Class'
Game = require'src.Game'

local App = Class()

function App:init()
    self.width = love.graphics:getWidth()
    self.height = love.graphics:getHeight()
    self.state = nil -- set to an AppState instance
end

return app