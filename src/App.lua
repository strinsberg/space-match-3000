Class = require'src.Class'
Game = require'src.Game'
GameRunState = require'src.states.GameRunState'
GameUpdateState = require'src.states.GameUpdateState'
MainMenuState = require'src.states.MainMenuState'
Mode = require'src.Mode'

local App = Class()

function App:init()
    self.width = love.graphics:getWidth()
    self.height = love.graphics:getHeight()
    self.game = nil
    self.state =  MainMenuState(self)
    self.title = "Space Match 3000"
    self.version = 3.0
    self.company = "Plimpton Productions"
    self.currentMode = Mode(Mode.types.UNLIMITED, Mode.diff.EASY, nil, true)
end

function App:changeState(state)
    self.state = state
end

function App:newGame()
    local mode = Mode(self.currentMode.gameType, self.currentMode.difficulty,
            self.currentMode.limit, self.currentMode.refill)
    self.game = Game(mode)
    self:changeState(GameRunState(self))
end

return App