Class = require'src.Class'
GameState = require'src.states.GameState'
ScreenArea = require'src.view.ScreenArea'
assets = require 'assets.assets'

-- The state when the game is running and the player can interact with it
-- as opposed to the game being paused or the board updateing
local GameRunState = Class(GameState)

function GameRunState:init(app)
    GameState.init(self, app)
    self.game = app.game
    self.board = self.game.board
    -- Some stuff for updates
    self.updateBoard = false
    self.switchBlocksBack = nil -- Two blocks to switch
end

function GameRunState:update(dt)
    -- All game updates for the state
    GameState.update(self, dt)
    
    -- check to see if game is over
    
    -- Get all matches on the board and set state to update to animate them
    if self.updateBoard then
        local matches = self.board:getMatches()
        if #matches > 0 then
            self.board:removeMatches(matches)
            local droppingBlocks =
                    self.board:getDroppingBlocks(self.game.refill)
            self.board:dropBlocks(droppingBlocks)
            -- for now set blocks back to visible
            for i, block in ipairs(droppingBlocks) do
                block.isVisible = true
            end
            -- set update state with all blocks that need to be updated
            -- self.app.changeState(GameUpdateState(self.app, droppingBlocks)
            -- score all matches
        else
            self.checkForMatches = false
        end
    end
    
    -- Switch back blocks that did not create matches
    if self.switchBack then
        local block1, block2 = self.board:switchBlocks(
            self.switchBack[1].row, self.switchBack[1].column,
            self.switchBack[2].row, self.switchBack[2].column)
        -- add change to update state with blocks
        -- self.app.changeState(GameUpdateState(self.app, {block1, block2})
        self.switchBack = nil
    end
end


-- Handle mouse press events for the state
function GameRunState:mousePressed(x, y, button)
    -- Super mouse events
    GameState.mousePressed(self, x, y, button)
    
    -- Set row column for the mouse click
    local row, column = self:clickIndex(x, y)
    
    -- If the click is not on the board return
    if not self:isClickOnBoard(row, column) then
        return
    end
    
    -- Button events
    if button == 2 then -- Might want to move this before in bounds check
        self.game:setSelection() -- Clear selection
    -- If there is a selection and the next click is a valid move
    elseif self.game.selection and self.board:isAdjacentMove(
            self.game.selection.row, self.game.selection.column,
            row, column) then
        -- Switch the two blocks
        local block1, block2 = self.board:switchBlocks(self.game.selection.row,
            self.game.selection.column, row, column)
        -- Add these blocks to be animated and change state
        -- self.app.changeState(GameUpdateState(self.app, {block1, block2})
        -- If the switch created a match set the board to update
        if self.board:isBlockMatched(row, column)
                or self.board:isBlockMatched(self.game.selection.row,
                self.game.selection.column) then
            self.updateBoard = true
        else
            -- Set the blocks to be switched back
            self.switchBack = {block1, block2}
        end
        self.game:setSelection() -- Clear selections
    else
        -- There is no selection so set it to the row column clicked
        self.game:setSelection(row, column)
    end
    -- somewhere in this section update limits or maybe have move made var
    -- to allow update to update limits?
end


-- Handle key press events
function GameRunState:keyPressed(key)
    -- Super key events
    GameState.keyPressed(self, key)
end


-- Draw everything for the state to the screen
function GameRunState:draw()
    -- Super draw
    GameState.draw(self)
end


-- Helper methods

-- Get the row and column for a click position with an x and y value
function GameRunState:clickIndex(x, y)
    row = math.floor((y - self.boardArea.y) / assets.blockSize) + 1
    column = math.floor((x - self.boardArea.x) / assets.blockSize) + 1
    return row, column
end

-- Make sure the click is on the board
function GameRunState:isClickOnBoard(row, column)
    if row < 1 or row > self.board.rows
            or column < 1 or column > self.board.rows then
        return false
    end
    return true
end

return GameRunState