Class = require'src.Class'
Mode = require'src.Mode'

local HighScore = Class()

function HighScore:init(gameType, limit, difficulty, name, score)
    self.gameType = gameType
    self.limit = limit
    self.difficulty = difficulty
    self.name = name
    self.score = score
end

function HighScore:toString()
    return string.format("%s %s %s %s %s", self.gameType,
            self.limit, self.difficulty, self.name, self.score)
end

return HighScore