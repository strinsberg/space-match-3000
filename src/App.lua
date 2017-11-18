-- Modules
state = require'src.state'
menus = require'src.menu'
difficulty = require'src.difficulty'
mode = require'src.mode'
limit =require'src.limit'

-- Classes
Class = require'src.Class'
Game = require'src.Game'


-- Main application class
local App = Class()


-- Creates an instance of class App
function App:init()
    self.state = state.MenuState(this)
    self.menu = self:mainMenu()
    self.game = nil
end

function newGame() -- Will not work properly-----------------------------
    self.game = Game( difficulty.new(), mode.new(), limit.new(self))
end

function App:changeState(state)
    self.state = state
end

-- Are menus really helping me here?
function App:mainMenu()
    self.menu = menus.Menu("Main Menu")
    self.menu:add(menus.MenuItem("n", "(n)ew Game", newGame))
    self.menu:add(menus.MenuItem("d", "(d)ifficulty", difficulty.cycleDifficulty))
    self.menu:add()
end