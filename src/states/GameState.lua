Class = require'src.Class'
AppState = require'src.states.AppState'
ScreenArea = require'src.view.ScreenArea'
assets = require 'assets.assets'

-- This is the parent class for the actual match 3 part of the game
-- It will include all code that must run during any point in the game
local GameState = Class(AppState)

function GameState:init(app)
    AppState.init(self, app)
    self.boardArea = ScreenArea(240, 160, 320)
end

function GameState:update(dt)
    -- All game updates for the state
    AppState.update(self, dt)
end

function GameState:mousePressed(x, y, button)
    -- Handle mouse events for the state
    AppState.mousePressed(self, x, y, button)
end

function GameState:keyPressed(key)
    -- Handle key press events for the state
    AppState.keyPressed(self, key)
end


-- Draw everything for the state to the screen
function GameState:draw()
    -- Super draw
    AppState.draw(self)
    
    -- Draw the board needs to be fixed
    for row = 1, app.game.board.rows do
        for column = 1, app.game.board.columns do
            local block = app.game.board.board[row][column]
            self:drawBlock(block, row, column)
        end
    end
    
    -- If there is a selection draw the selection inicator
    if app.game.selection then
        self.boardArea:draw(assets.selection,
            assets.toPixel(self.app.game.selection.column),
            assets.toPixel(self.app.game.selection.row))
    end
end


-- Helper methods

-- Draw a block on the board
function GameState:drawBlock(block, row, column)
    -- If the block is visible then draw it
    if block.isVisible then
        self.boardArea:draw(assets.getBlockImage(block.color),
                assets.toPixel(column), assets.toPixel(row))
    end
end

return GameState