State = require'src.gameState.State'
GameState = require'src.gameState.GameState'
MainMenuScreen = require'src.view.MainMenuScreen'
colors = require'src.gameSettings.colors'
mode = require'src.gameSettings.mode'
limit = require'src.gameSettings.limitClasses'
menus = require'src.menu'

-- helper functions
local function newGame(stat)
    print("new game")
    --[[
    self.app.game = Game(self.numColors, self.mode)
    self.app:changeState(GameState(self.app))
    --]]
end

local function cycleNumColors(state)
    colors.cycle()
    state.numColors = colors.get()
end

local function cycleMode(state)
    mode.cycle()
    state.mode = mode.get()
end

local function cycleLimitName(state)
    limit.cycle()
    state.limitName = limit.getName()
end

local function createMenu()
    local menu = menus.Menu("Main Menu")
    menu:add(menus.MenuItem(1, "n", "(n)ew Game", newGame))
    menu:add(menus.MenuItem(2, "c", "(c)olors", cycleNumColors))
    menu:add(menus.MenuItem(3, "m", "(m)ode", cycleMode))
    menu:add(menus.MenuItem(4, "l", "(l)imit", cycleLimitName))
    menu:add(menus.MenuItem(5, "q", "(q)uit", love.event.quit))
    return menu
end

-- Main Menu State class --------------------------------
local MainMenuState = Class(State)

function MainMenuState:init(app)
    State.init(self, app)
    self.screen = MainMenuScreen(self)
    self.menu = createMenu(self)
    self.numColors = colors.get()
    self.mode = mode.get()
    self.limitName = limit.getName()
end

function MainMenuState:update(dt)
    -- Nothing
end

function MainMenuState:mousePressed(x, y, button)
    -- Nothing
end

function MainMenuState:keyPressed(key)
    self.menu:action(key, self) -- the state makes this not portable
end

function MainMenuState:draw(dt)
    self.screen:draw()
end

return MainMenuState