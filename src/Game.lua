Class = require'src.Class'
Match3Board = require'src.Match3Board'

local Game = Class()

-- Game Constants

-- Default board size
Game.ROWS = 8
Game.COLUMNS = 8
-- Number of colors for each difficulty
Game.EASY = 4
Game.NORMAL = 5
Game.HARD = 6
Game.ROUGH = 7


-- Create a game with a new board
function Game:init(difficulty, mode)
    self.difficulty = difficulty
    self.mode = mode
    self.board = Match3Board(Game.ROWS, Game.COLUMNS, difficulty)
    self.score = 0
    self.scoreModifier = 1
    self.selection = nil
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
        score = size * (((size % 3) * 0.5) * 1)
    else
        score = size * 2.5
    end
    return score * self.modifier
end


-- Set the seleced block
function Game:setSelection(row, column)
    self.selection = {row = row, column = column}
end

return Game