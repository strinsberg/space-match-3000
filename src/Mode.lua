Class = require'src.Class'
functions = require'src.libFunctions'

local Mode = Class()

-- Mode Constants
Mode.UNLIMITED = 1
Mode.MOVES = 2
Mode.TIMED = 3
Mode.EASY = 4
Mode.NORMAL = 5
Mode.HARD = 6


function Mode:init(gameType, difficulty, limit, refill)
    self.gameType = gameType
    self.difficulty = difficulty
    self.limit = limit
    self.limitLeft = limit
    self.refill = refill
end

function Mode:updateLimit(amount)
    if self.limit then
        self.limitLeft = self.limitLeft - amount
    end
end

function Mode:limitIsReached()
    if not self.limit then
        return false
    end
    if self.limitLeft <= 0 then
        return true
    else
        return false
    end
end

function Mode:typeToString()
    local label = "Mode:"
    if self.gameType == Mode.UNLIMITED then
        return string.format("%s Endless", label)
    elseif self.gameType == Mode.MOVES then
        return string.format("%s Moves", label, self.limit)
    elseif self.gameType == Mode.TIMED then
        return string.format("%s Timed", label)
    else
        return "Should be unreachable"
    end
end

function Mode:diffToString()
    local label = "Difficulty:"
    if self.difficulty == Mode.EASY then
        return string.format("%s Easy", label)
    elseif self.difficulty == Mode.NORMAL then
        return string.format("%s Normal", label)
    elseif self.difficulty == Mode.HARD then
        return string.format("%s Hard", label)
    else
        return "Should be unreachable"
    end
end

function Mode:limitToString()
    if self.gameType == Mode.MOVES then
        return string.format("Moves Left: %s", self.limitLeft)
    elseif self.gameType == Mode.TIMED then
        return string.format("Time Left: %s",
                functions.secToMin(self.limitLeft))
    else
        return "Should be unreachable"
    end
end

return Mode