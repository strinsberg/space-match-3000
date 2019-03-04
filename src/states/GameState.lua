Class = require'src.Class'
AppState = require'src.states.AppState'
ScreenArea = require'src.view.ScreenArea'
assets = require 'assets.assets'

-- TODO pull logic out of update and draw functions and put it
-- into helpers
---------------------------------------------------------------------
-- Base class / Interface for all states in the game
---------------------------------------------------------------------
local GameState = Class(AppState)


---------------------------------------------------------------------
-- Initialize the state
-- app -> the app the state is part of
---------------------------------------------------------------------
function GameState:init(app)
    AppState.init(self, app)
    self.boardArea = ScreenArea(240, 160, 320)
    self.scoreArea = ScreenArea(560, 160, 240)
    self.settingsArea = ScreenArea(0, 160, 240)
    self.menuArea = ScreenArea(120, 500, 560)
    self.messageArea = ScreenArea(0, 110, app.width)
    self.game = app.game
    self.board = self.game.board
    self.message = nil
end


---------------------------------------------------------------------
-- Update the state
-- dt -> delta time
---------------------------------------------------------------------
function GameState:update(dt)
    -- Super update
    AppState.update(self, dt)
    
    -- Update the matchScores duration
    for i, score in pairs(self.game.matchScores) do
        score.duration = score.duration - dt
    end
    
    -- Remove matchScores with ended durations
    for i, score in pairs(self.game.matchScores) do
        if score.duration < 0 then
            table.remove(self.game.matchScores, i)
        end
    end
    
    -- Update the time if needed
    if self.game.mode.gameType == Mode.types.TIMED then
        self.game.mode:updateLimit(dt)
    end
end


---------------------------------------------------------------------
-- Handler for mouse events
-- x -> the x coord of the event
-- y -> the y coord of the event
-- button -> the mouse button pressed
---------------------------------------------------------------------
function GameState:mousePressed(x, y, button)
    AppState.mousePressed(self, x, y, button)
    
    self.message = nil
end


---------------------------------------------------------------------
-- Handler for key press events
-- key -> the key pressed
---------------------------------------------------------------------
function GameState:keyPressed(key)
    AppState.keyPressed(self, key)
    
    self.message = nil
    
    if key == 'q' then
        self.game.isOver = true
    elseif key == 'p' then
        self.app:changeState(GamePauseState(self.app, self))
    end
end


---------------------------------------------------------------------
-- Draw the state information
---------------------------------------------------------------------
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
    
    -- If there is a hint position draw it
    if self.game.hint then
        self.boardArea:draw(assets.hint,
            assets.toPixel(self.game.hint.column),
            assets.toPixel(self.game.hint.row))
    end
    
    -- If there is a selection draw the selection inicator
    if self.game.selection then
        self.boardArea:draw(assets.selection,
            assets.toPixel(self.game.selection.column),
            assets.toPixel(self.game.selection.row))
    end
    
    -- Draw all the score stuff
    self.scoreArea:printCenter("Score: "..self.game.score, 0)
    -- Set color for modifier
    if self.game.scoreModifier > 3 and self.game.scoreModifier <= 6 then
        assets.setColor('green')
    elseif self.game.scoreModifier > 6 then
        assets.setColor('red')
    end
    self.scoreArea:printCenter("Modifier: "..self.game.scoreModifier,
            assets.blockSize)
    assets.setColor() -- Color back to white
    self.scoreArea:printCenter("Match Scores", assets.blockSize * 2)
    for i, score in ipairs(self.game.matchScores) do
        if score.score > 10 and score.score <= 25 then
            assets.setColor('green')
        elseif score.score > 25 then
            assets.setColor('red')
        end
        self.scoreArea:printCenter(score.score, (i + 2) * assets.blockSize)
        assets.setColor()
    end
    
    -- Draw all the settings stuff
    self.settingsArea:printCenter(self.game.mode:diffToString(), 0)
    self.settingsArea:printCenter(self.game.mode:typeToString(),
            assets.blockSize)
    if self.game.mode.limit then
        local left = self.game.mode.limitLeft
        if left <= 10 then
            assets.setColor('red')
        end
    elseif not self.game.mode.refill then
        assets.setColor('red')
    end
    self.settingsArea:printCenter(self.game.mode:limitLeftToString(),
                assets.blockSize * 2)
    assets.setColor()
    
    -- draw menu options
    self.menuArea:printCenter("(p)ause  -  (h)int  -  (q)uit",
            assets.blockSize * 1.5)
        
    -- Print the message if there is one
    if self.message then
        self.messageArea:printCenter(self.message, 0)
    end
end


---------------------------------------------------------------------
-- Draw a block on the board
---------------------------------------------------------------------
function GameState:drawBlock(block, row, column)
    -- If the block is visible then draw it
    if block.isVisible then
        self.boardArea:draw(assets.getBlockImage(block.color),
                assets.toPixel(column), assets.toPixel(row))
    end
end


-- Return the module
return GameState