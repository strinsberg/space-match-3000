Class = require'src.Class'
Game = require'src.Game'
GameState = require'src.states.GameState'
GamePauseState = require'src.states.GamePauseState'
GameRunState = require'src.states.GameRunState'
GameUpdateState = require'src.states.GameUpdateState'
MainMenuState = require'src.states.MainMenuState'
Mode = require'src.Mode'

---------------------------------------------------------------------
-- Class for the app's data and current state.
---------------------------------------------------------------------
local App = Class()


---------------------------------------------------------------------
-- Initializes the app.
---------------------------------------------------------------------
function App:init()
    self.width = love.graphics:getWidth()
    self.height = love.graphics:getHeight()
    self.game = nil
    self.state =  MainMenuState(self)
    self.title = "Space Match 3000"
    self.version = "3.0"
    self.company = "Strinberg Solutions"
    self.currentMode = Mode(Mode.types.UNLIMITED, Mode.diff.EASY, nil, true)
    self.highScores = nil
    self.name = nil
end


---------------------------------------------------------------------
-- Changes the state of the app.
-- state -> the new State of the app
---------------------------------------------------------------------
function App:changeState(state)
    self.state = state
end


-- Something will have to change here if the Mode class is fixed
---------------------------------------------------------------------
-- Starts a new game.
---------------------------------------------------------------------
function App:newGame()
    local mode = Mode(self.currentMode.gameType, self.currentMode.difficulty,
            self.currentMode.limit, self.currentMode.refill)
    self.game = Game(mode)
    self:changeState(GameRunState(self))
end


-- Return the module
return App