Class = require'src.Class'
GameState = require'src.appState.GameState'
GameOverState = require'src.appState.GameOverState'

-- Needs to inherit from the gamestate so that it can share those methods.
-- this way anything that needs to be in both can be. mostly the draw function
-- same goes for the pause state

local GameUpdateState = Class(GameState)

function GameUpdateState:init(app)
    -- Initialize the state
    GameState.init(self, app)
end

function GameUpdateState:update(dt)
    -- All game updates for the state
    GameState.update(self, dt)
    -- Update the animations that are not finished
    for i, animation in ipairs(blockingAnims) do
        if not animation.finished then
            animation:update(dt)
        end
    end
    -- Remove all finished animations
    -- Had to put in another loop because the removeal of objects from the table mid loop
    -- seems to skip updating some of the animations. Though the max animations is 64 so it
    -- should not be a performance drain
    for i, animation in ipairs(blockingAnims) do
        if animation.finished then
            table.remove(blockingAnims, i)
            board.items[(animation.y / itemSize) + 1][(animation.x / itemSize) + 1].visible = true
        end
    end
    if #blockingAnims == 0 then
        self.app.changeState(GameRunState(self.app))
    end
end

function GameUpdateState:mousePressed(x, y, button)
    -- Handle mouse events for the state
end

function GameUpdateState:keyPressed(key)
    -- Handle key press events for the state
    if key == 'p' then
        self.app.changeState(GamePauseState(self.app))
    elseif key == 'q' then
        self.app.changeState(GameOverState(self.app))
    end
end

function GameUpdateState:draw()
    -- Draw everything for the state to the screen
    -- Draw all items
    GameState.draw(self)
    -- All drawing that might be specific to this state can go here
    love.graphics.printf("(h)int" , gameArea.x, gameArea.y + 380,
            320, 'left')
    love.graphics.printf("(p)ause", gameArea.x, gameArea.y + 380,
            320, 'right')
end

return GameUpdateState
