Class = require'src.Class'
functions = require'src.libFunctions'

local Mode = Class()

-- Mode Constants and local variables
Mode.types = {
    UNLIMITED = 1,
    MOVES = 2,
    TIMED = 3
}

Mode.diff = {
    EASY = 4,
    NORMAL = 5,
    HARD = 6
}

local moveLimits = {25, 50, 75, 100}
local timeLimits = {30, 60, 120, 180, 300}
local typeIndex = 1

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


function Mode:changeDifficulty()
    if self.difficulty == Mode.diff.HARD then
        self.difficulty = Mode.diff.EASY
    else
        self.difficulty = self.difficulty + 1
    end
end

function Mode:changeGameType()
    if self.gameType == Mode.types.TIMED then
        if typeIndex == #timeLimits then
            self.gameType = Mode.types.MOVES
            typeIndex = 1
            self.limit = moveLimits[typeIndex]
            self.limitLeft = self.limit
        else
            typeIndex = typeIndex + 1
            self.limit = timeLimits[typeIndex]
            self.limitLeft = self.limit
        end
    elseif self.gameType == Mode.types.MOVES then
        if typeIndex == #moveLimits then
            self.gameType = Mode.types.UNLIMITED
            typeIndex = 1
            self.limit = nil
            self.limitLeft = self.limit
        else
            typeIndex = typeIndex + 1
            self.limit = moveLimits[typeIndex]
            self.limitLeft = self.limit
        end
    else
        self.gameType = Mode.types.TIMED
        typeIndex = 1
        self.limit = timeLimits[typeIndex]
        self.limitLeft = self.limit
    end
end


function Mode:typeToString()
    local label = "Mode:"
    if self.gameType == Mode.types.UNLIMITED then
        return string.format("%s Endless", label)
    elseif self.gameType == Mode.types.MOVES then
        return string.format("%s Moves", label, self.limit)
    elseif self.gameType == Mode.types.TIMED then
        return string.format("%s Timed", label)
    end
end

function Mode:diffToString()
    local label = "Difficulty:"
    if self.difficulty == Mode.diff.EASY then
        return string.format("%s Easy", label)
    elseif self.difficulty == Mode.diff.NORMAL then
        return string.format("%s Normal", label)
    elseif self.difficulty == Mode.diff.HARD then
        return string.format("%s Hard", label)
    end
end

function Mode:limitToString()
    if self.gameType == Mode.types.MOVES then
        return string.format("%s",self.limit)
    elseif self.gameType == Mode.types.TIMED then
        return string.format("%s", functions.secToMin(self.limit))
    else
        return ""
    end
end

function Mode:limitLeftToString()
    if self.gameType == Mode.types.MOVES then
        return string.format("Moves Left: %s", self.limitLeft)
    elseif self.gameType == Mode.types.TIMED then
        return string.format("Time Left: %s",
                functions.secToMin(self.limitLeft))
    end
end

return Mode