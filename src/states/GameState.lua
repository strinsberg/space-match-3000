Class = require'src.Class'
AppState = require'src.states.AppState'
ScreenArea = require'src.view.ScreenArea'
assets = require 'assets.assets'

-- This is the parent class for the actual match 3 part of the game
-- It will include all code that must run during any point in the game
local GameState = Class(AppState)


-- Constructor for the state
function GameState:init(app)
    AppState.init(self, app)
    self.boardArea = ScreenArea(240, 160, 320)
    self.scoreArea = ScreenArea(560, 160, 240)
    self.settingsArea = ScreenArea(0, 160, 240)
    self.menuArea = ScreenArea(120, 500, 560)
    self.game = app.game
    self.board = self.game.board
end


-- Perfome all updates for the state
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


-- Handle all mouse presses for the state
function GameState:mousePressed(x, y, button)
    AppState.mousePressed(self, x, y, button)
end


-- Handle all key presses for the state
function GameState:keyPressed(key)
    AppState.keyPressed(self, key)
    
    if key == 'q' then
        self.app:changeState(MainMenuState(self.app))
    elseif key == 'p' then
        self.app:changeState(GamePauseState(self.app, self))
    end
end


-- Draw everything for the state
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
    self.scoreArea:printCenter(string.format("Score: %s", self.game.score), 0)
    self.scoreArea:printCenter(string.format("Modifier: %s",
            self.game.scoreModifier), assets.blockSize)
    self.scoreArea:printCenter("Match Scores", assets.blockSize * 2)
    for i, score in ipairs(self.game.matchScores) do
        self.scoreArea:printCenter(score.score, (i + 2) * assets.blockSize)
    end
    
    -- Draw all the settings stuff
    self.settingsArea:printCenter(self.game.mode:diffToString(), 0)
    self.settingsArea:printCenter(self.game.mode:typeToString(),
            assets.blockSize)
    if self.game.mode.limit then
        self.settingsArea:printCenter(self.game.mode:limitLeftToString(),
                assets.blockSize * 2)
    end
    
    -- draw menu like options
    self.menuArea:printCenter("(p)ause  (h)int  (q)uit",
            assets.blockSize * 1.5)
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