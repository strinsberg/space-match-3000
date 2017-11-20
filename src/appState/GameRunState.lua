Class = require'Class'
GameState = require'src.appState.GameState'

local GameRunState = Class(GameState)

function GameRunState:init(app)
    GameStater.init(self, app)
end

function GameRunState:update(dt)
    -- All game updates for the state
    GameState.update(self, dt)
    -- all the code that is not shared with update should go here
end

function GameRunState:mousePressed(x, y, button)
    -- Handle mouse events for the state
    GameState.mousePressed(self, x, y, button)
    -- all of the mouse code for the game should go here
end

function GameRunState:keyPressed(key)
    -- Handle key press events for the state
    GameState.keyPressed(self, key)
    -- all of the keyPress code should go here
end

function GameRunState:draw()
    -- Draw everything for the state to the screen
    GameState.draw(self)
    -- all of the code that draws the menu should go here since that is
    -- the only thing that is unique to this state
end

return GameRunState
