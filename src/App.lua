Class = require'src.Class'
Game = require'src.Game'
GameState = require'src.states.GameState'

local App = Class()

function App:init()
    self.width = love.graphics:getWidth()
    self.height = love.graphics:getHeight()
    self.state =  GameState(self)-- The starting state of the program
    self.game = Game(Game.EASY, 0) -- Still needs way to set these
    self.title = "Space Match 3000"
    self.version = 3.0
    self.company = "Plimpton Productions"
end

function App:changeState(state)
    self.state = state
end

return App