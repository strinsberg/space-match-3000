Class = require'src.Class'
Match3Board = require'src.Match3Board'

local Game = Class()

-- Game Constants

-- Default board size
Game.ROWS = 8
Game.COLUMNS = 8

-- Create a game with a new board
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


-- Add to score total for a group of matches
function Game:scoreMatches(matches)
    for i, match_ in ipairs(matches) do
        self:scoreMatch(match_.size)
    end
end


-- Score a match based on its length and the current modifier
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


-- Set the seleced block
function Game:setSelection(row, column)
    -- If no arguments are given set selection to nil
    if not row or not column then
        self.selection = nil
    else
        -- Else set it to the row column
        self.selection = {row = row, column = column}
    end
end


-- set hint block
function Game:setHint(row, column)
    -- If no arguments are given set selection to nil
    if not row or not column then
        self.hint = nil
    else
        -- Else set it to the row column
        self.hint = {row = row, column = column}
    end
end

return Game