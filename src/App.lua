Class = require'src.Class'
Game = require'src.Game'
GameRunState = require'src.states.GameRunState'
GameUpdateState = require'src.states.GameUpdateState'
Mode = require'src.Mode'

local App = Class()

function App:init()
    self.width = love.graphics:getWidth()
    self.height = love.graphics:getHeight()
    self.game = Game(Mode(Mode.UNLIMITED, Mode.NORMAL, 100, true))
    self.state =  GameRunState(self)-- The starting state of the program
    self.title = "Space Match 3000"
    self.version = 3.0
    self.company = "Plimpton Productions"
end

function App:changeState(state)
    self.state = state
end

return App