Class = require'src.Class'
functions = require'src.libFunctions'


---------------------------------------------------------------------
-- An object for the game type
-- Needs some work. Should not be a singleton object that is changed
-- around, but an object creted and passed to the game based on the
-- game type and difficulty.
---------------------------------------------------------------------
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
    HARD = 6,
    ROUGH = 7
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
    if self.difficulty == Mode.diff.ROUGH then
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
    elseif self.gameType == Mode.types.UNLIMITED then
        if self.refill then
            self.refill = false
        else
            self.refill = true
            self.gameType = Mode.types.TIMED
            typeIndex = 1
            self.limit = timeLimits[typeIndex]
            self.limitLeft = self.limit
        end
    end
end


function Mode:typeToString()
    return string.format("Mode: %s", self:gameTypeString())
end

function Mode:gameTypeString()
    if self.gameType == Mode.types.UNLIMITED then
        return "Endless"
    elseif self.gameType == Mode.types.MOVES then
        return "Moves"
    elseif self.gameType == Mode.types.TIMED then
        return "Timed"
    end
end

function Mode:diffToString()
    return string.format("Difficulty: %s", self:difficultyString())
end

function Mode:difficultyString()
    if self.difficulty == Mode.diff.EASY then
        return "Easy"
    elseif self.difficulty == Mode.diff.NORMAL then
        return "Normal"
    elseif self.difficulty == Mode.diff.HARD then
        return "Hard"
    else
        return "Rough"
    end
end

function Mode:limitToString()
    if self.gameType == Mode.types.MOVES then
        return string.format("%s",self.limit)
    elseif self.gameType == Mode.types.TIMED then
        return string.format("%s", functions.secToMin(self.limit))
    else
        if self.refill then
            return "Refill"
        else
            return "No-Refill"
        end
    end
end

function Mode:limitLeftToString()
    if self.gameType == Mode.types.MOVES then
        return string.format("Moves Left: %s", self.limitLeft)
    elseif self.gameType == Mode.types.TIMED then
        return string.format("Time Left: %s",
                functions.secToMin(self.limitLeft))
    elseif not self.refill then
        return "No-Refill"
    else
        return ""
    end
end

return Mode