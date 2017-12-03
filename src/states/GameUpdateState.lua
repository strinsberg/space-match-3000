Class = require'src.Class'
GameState = require'src.states.GameState'
ScreenArea = require'src.view.ScreenArea'
Animation = require'src.view.Animation'
assets = require 'assets.assets'

local GameUpdateState = Class(GameState)

function GameUpdateState:init(app, movingBlocks)
    GameState.init(self, app)
    self.animations = self:createAnimations(movingBlocks)
end

-- Update game elements
function GameUpdateState:update(dt)
    -- Super update
    GameState.update(self, dt)
    
    for i, animation in ipairs(self.animations) do
        if not animation.finished then
            animation:update(dt)
        end
    end
    
    for i, animation in ipairs(self.animations) do
        if animation.finished then
            table.remove(self.animations, i)
            self.app.game.board.board[assets.toIndex(animation.y)][assets.toIndex(animation.x)].isVisible = true
        end
    end
    
    if #self.animations == 0 then
        self.app:changeState(GameRunState(self.app))
    end
end


-- Handle mouse press events for the state
function GameUpdateState:mousePressed(x, y, button)
    -- Super mouse events
    GameState.mousePressed(self, x, y, button)
end


-- Handle key press events
function GameUpdateState:keyPressed(key)
    -- Super key events
    GameState.keyPressed(self, key)
end


-- Draw everything for the state to the screen
function GameUpdateState:draw()
    -- Super draw
    GameState.draw(self)
    
    for i, animation in ipairs(self.animations) do
        -- If the animation is only one block above the top of the board
        if animation.y > -assets.blockSize then
            -- Draw it on the board area
            self.boardArea:draw(animation.image, animation.x, animation.y)
        end
    end
end

-- Helper methods

-- Create all the animations from a table of moving blocks
function GameUpdateState:createAnimations(movingBlocks)
    local animations = {}
    for i, block in ipairs(movingBlocks) do
        animations[#animations + 1] = Animation(assets.toPixel(block.moveColumn),
                assets.toPixel(block.moveRow), assets.toPixel(block.column),
                assets.toPixel(block.row),
                assets.getBlockImage(block.color))
    end
    return animations
end

return GameUpdateState