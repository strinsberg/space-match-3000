Class = require'src.Class'

---------------------------------------------------------------------
-- Holds data for a high score.
---------------------------------------------------------------------
local HighScore = Class()

---------------------------------------------------------------------
-- Initialize a high score object.
-- gameType -> name for the game type
-- limit -> name of the game type's limit
-- difficulty -> name of the dificulty
-- name -> players name
-- score -> the high score
---------------------------------------------------------------------
function HighScore:init(gameType, limit, difficulty, name, score)
    self.gameType = gameType
    self.limit = limit
    self.difficulty = difficulty
    self.name = name
    self.score = score
end

---------------------------------------------------------------------
-- Returns a string of the high score.
---------------------------------------------------------------------
function HighScore:toString()
    return string.format("%s %s %s %s %s", self.gameType,
            self.limit, self.difficulty, self.name, self.score)
end

-- Return the module
return HighScore