Class = require'src.Class'
Match3Board = require'src.Match3Board'

---------------------------------------------------------------------
-- A match 3 game
---------------------------------------------------------------------
local Game = Class()

-- Default board size
Game.ROWS = 8
Game.COLUMNS = 8


---------------------------------------------------------------------
-- Initialize a new game.
-- mode -> the game mode
---------------------------------------------------------------------
function Game:init(mode)
    self.mode = mode
    self.board = Match3Board(Game.ROWS, Game.COLUMNS, mode.difficulty)
    self.score = 0
    self.matchScores = {}
    self.scoreModifier = 1
    self.selection = nil
    self.hint = nil
    self.isOver = false
end


---------------------------------------------------------------------
-- Score a group of matches.
-- matches -> an array of matches to score
---------------------------------------------------------------------
function Game:scoreMatches(matches)
    for _, m in ipairs(matches) do
        self:scoreMatch(m.size)
    end
end


---------------------------------------------------------------------
-- Decide on the score for a match and add it to the game's score
---------------------------------------------------------------------
function Game:scoreMatch(size)
    local score = 0
    if size < 6 then
        score = size * (((size % 3) * 0.5) + 1)
    else
        score = size * 2.5
    end
    score = score * self.scoreModifier
    self.matchScores[#self.matchScores + 1] = {score = score, duration = 1}
    self.score = self.score + score
end


---------------------------------------------------------------------
-- Set the selected block to row, column
---------------------------------------------------------------------
function Game:setSelection(row, column)
    -- If no arguments are given set selection to nil
    if not row or not column then
        self.selection = nil
    else
        -- Else set it to the row column
        self.selection = {row = row, column = column}
    end
end


---------------------------------------------------------------------
-- Set the hint block to row, column
---------------------------------------------------------------------
function Game:setHint(row, column)
    -- If no arguments are given set selection to nil
    if not row or not column then
        self.hint = nil
    else
        -- Else set it to the row column
        self.hint = {row = row, column = column}
    end
end

-- Return module
return Game