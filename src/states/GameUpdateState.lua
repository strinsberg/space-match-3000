Class = require'src.Class'
GameState = require'src.states.GameState'
ScreenArea = require'src.view.ScreenArea'
assets = require 'assets.assets'

local GameUpdateState = Class(GameState, movingBlocks)

function GameUpdateState:init(app)
    GameState.init(self, app)
    self.movingBlocks = movingBlocks
end



return GameUpdateState